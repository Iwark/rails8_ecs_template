# == base
FROM ruby:3.4.5-slim-bullseye AS base

WORKDIR /app

ENV RAILS_ENV=production \
  BUNDLE_DEPLOYMENT=true \
  BUNDLE_PATH=vendor/bundle \
  BUNDLE_WITHOUT=development:test

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  build-essential \
  bash \
  git \
  libyaml-dev && \
  gem install bundler --no-document --version 2.7.1 && \
  rm -rf /var/lib/apt/lists/*

FROM base AS builder

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  libpq-dev \
  tzdata \
  shared-mime-info && \
  rm -rf /var/lib/apt/lists/*

# == bundle
FROM builder AS bundle

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 \
  && rm -rf $BUNDLE_PATH/ruby/$RUBY_VERSION/cache/*

# == assets
FROM builder AS assets

COPY . .

COPY --from=bundle /app/vendor/bundle /app/vendor/bundle

# Set a dummy value to avoid errors when building docker image.
# refs: https://github.com/rails/rails/issues/32947
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile && \
  rm -rf tmp/cache/*

# == main
FROM base AS main

# Add packages
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  libpq-dev \
  tzdata \
  shared-mime-info \
  make \
  gcc \
  g++ && \
  rm -rf /var/lib/apt/lists/*

COPY . .

# Copy files from each stages
COPY --from=bundle /app/vendor/bundle /app/vendor/bundle
COPY --from=assets /app/public/assets /app/public/assets

ARG SHA
ENV SHA ${SHA}
ENV PORT 3000

EXPOSE ${PORT}

CMD ["bin/rails", "server", "-b", "0.0.0.0"]