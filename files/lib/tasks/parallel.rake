namespace :parallel do
  desc 'Run complete parallel RSpec workflow: precompile → parallel_rspec → cleanup'
  task spec_full: :environment do
    puts '🚀 Starting complete parallel RSpec workflow...'

    # Step 1: Precompile assets for test environment
    puts "\n📦 Step 1: Precompiling assets for test environment..."
    system({ 'RAILS_ENV' => 'test' }, 'bundle exec rails assets:precompile') || abort('❌ Asset precompilation failed')

    # Step 2: Prepare parallel test databases
    puts "\n🗄️  Step 2: Preparing parallel test databases..."
    Rake::Task['parallel:prepare'].invoke

    # Step 3: Run parallel RSpec tests
    puts "\n🧪 Step 3: Running parallel RSpec tests..."
    system({ 'RAILS_ENV' => 'test' }, 'bundle exec parallel_rspec') || abort('❌ Parallel tests failed')

    # Step 4: Clean up assets
    puts "\n🧹 Step 4: Cleaning up precompiled assets..."
    Rake::Task['assets:clobber'].invoke

    puts "\n✅ Complete parallel RSpec workflow finished successfully!"
  end

  # Alias for spec_full to prevent typos
  task full_spec: :spec_full
end
