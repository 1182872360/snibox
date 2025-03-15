# frozen_string_literal: true

module DatabaseLogger
  class << self
    def log_connection_info
      config = ActiveRecord::Base.connection_config
      Rails.logger.info "Database Connection Parameters:"
      Rails.logger.info "  adapter: #{config[:adapter]}"
      Rails.logger.info "  database: #{config[:database]}"
      Rails.logger.info "  host: #{config[:host]}"
      Rails.logger.info "  port: #{config[:port]}"
      Rails.logger.info "  pool: #{config[:pool]}"
    end

    def log_connection_status
      begin
        ActiveRecord::Base.connection.active?
        Rails.logger.info "Database connection successful"
      rescue => e
        Rails.logger.error "Database connection failed: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end
    end
  end
end

# Log database connection info on application startup
Rails.application.config.after_initialize do
  DatabaseLogger.log_connection_info
  DatabaseLogger.log_connection_status
end

# Monitor database connection status
ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  if event.payload[:exception]
    Rails.logger.error "Database query error: #{event.payload[:exception]}"
    DatabaseLogger.log_connection_status
  end
end