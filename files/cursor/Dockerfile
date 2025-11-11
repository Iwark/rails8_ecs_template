# Cursor Background Agent Dockerfile for Development Environment
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Sync hardware clock to system clock FIRST to fix time issues in Background Agent environment
RUN hwclock --hctosys || true

# Disable APT time checks globally to fix Background Agent environment issues (backup measure)
RUN echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99disable-time-check && \
    echo 'Acquire::Check-Date "false";' >> /etc/apt/apt.conf.d/99disable-time-check

# Install sudo first to avoid configuration conflicts
RUN apt-get update && \
    apt-get install -y sudo && \
    rm -rf /var/lib/apt/lists/*

# Install Ruby dependencies and Ruby 3.4.5
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    wget \
    ca-certificates \
    gnupg \
    lsb-release \
    libyaml-dev \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Ruby 3.4.5 from source
RUN cd /tmp && \
    wget https://cache.ruby-lang.org/pub/ruby/3.4/ruby-3.4.5.tar.gz && \
    tar -xzf ruby-3.4.5.tar.gz && \
    cd ruby-3.4.5 && \
    ./configure --disable-install-doc && \
    make -j$(nproc) && \
    make install && \
    cd / && \
    rm -rf /tmp/ruby-3.4.5*

# Create a non-root user with sudo privileges
RUN groupadd --gid 1000 ubuntu && \
    useradd --uid 1000 --gid ubuntu --shell /bin/bash --create-home ubuntu && \
    usermod -aG sudo ubuntu && \
    echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Add PostgreSQL 16 official APT repository
RUN curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Add Redis 7.2 official APT repository
RUN curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/redis.gpg && \
    echo "deb https://packages.redis.io/deb $(lsb_release -cs) main" > /etc/apt/sources.list.d/redis.list

# Install additional system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    git \
    vim \
    libpq-dev \
    tzdata \
    shared-mime-info \
    # Database services (specific versions)
    postgresql-16 \
    postgresql-contrib-16 \
    postgresql-client-16 \
    redis-server \
    redis-tools \
    # For PDF preview using ActiveStorage
    poppler-utils \
    # For JavaScript/Node.js
    nodejs \
    npm \
    # Additional development tools
    less \
    tmux \
    htop \
    chromium-browser \
    chromium-chromedriver \
    && rm -rf /var/lib/apt/lists/*

# Install bundler
RUN gem install bundler --no-document --version 2.7.1

# Create mock docker command to handle "docker compose exec web" calls
RUN mkdir -p /usr/local/bin && \
    cat <<'EOF' > /usr/local/bin/docker
#!/bin/sh
# Mock docker command for Background Agent environment
echo "DEBUG: docker called with args: $*" >&2
if [ "$1" = "compose" ] && [ "$2" = "exec" ] && [ "$3" = "web" ]; then
  # Remove "docker compose exec web" and execute the remaining command directly
  shift 3
  echo "DEBUG: About to execute: $*" >&2
  # Use sh -c with properly quoted command to handle special characters
  exec sh -c 'exec "$@"' -- "$@"
elif [ "$1" = "compose" ]; then
  echo "Note: Running in Background Agent environment"
  echo "Docker Compose commands are not available, but services are running locally"
  exit 0
else
  echo "Note: Docker commands other than compose are not available in Background Agent environment"
  exit 1
fi
EOF
RUN chmod +x /usr/local/bin/docker

# Switch to non-root user and set proper WORKDIR
USER ubuntu
WORKDIR /home/ubuntu

# Configure bundler for the ubuntu user
RUN bundle config set --global path 'vendor/bundle' && \
    bundle config set --global bin 'vendor/bundle/bin' && \
    bundle config set --global jobs 4 && \
    bundle config set --global retry 3

# Disable bash history expansion for the ubuntu user
RUN echo 'set +H' >> /home/ubuntu/.bashrc

# Set environment variables for development
ENV RAILS_ENV=development \
    BUNDLE_PATH=vendor/bundle \
    NODE_ENV=development \
    DATABASE_URL=postgresql://postgres:password@localhost/noman_web_development \
    TEST_DATABASE_URL=postgresql://postgres:password@localhost/noman_web_development_test \
    REDIS_URL=redis://localhost:6379/0 \
    TEST_BROWSER_PATH=/usr/bin/chromium-browser

# Expose the default Rails development port
EXPOSE 3000

# Default command - this will be overridden by background agent
CMD ["bash"]
