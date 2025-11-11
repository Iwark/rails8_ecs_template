class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  queue_as :default

  sidekiq_options lock: :until_and_while_executing,
                  on_conflict: {
                    client: :log,
                    server: :log
                  }

  delegate :logger, to: :Sidekiq

  protected

  def capture_exception(exception, extra: {})
    Rails.logger.error "Error: #{exception.message}, #{extra.inspect}"
    Sentry.capture_exception(exception, extra:)
  end
end
