module Stump

  #
  # The Middleware ensures that the logger provided (could be a standard Ruby Logger)
  # gets called by Rack.
  #
  class AccessLog

    # Adheres to the Apache Common Log format: http://en.wikipedia.org/wiki/Common_Log_Format
    ACCESS_LOG_FORMAT = %{%s - %s [%s] "%s %s%s %s" %d %0.4f \n}

    def initialize(app, logger)
      @app = app
      @logger = logger || ::Logger.new(STDOUT, 'daily')
      @logger.level ||= 'info'
    end

    def call(env)
      env['rack.logger'] = @logger
      began_at = Time.now
      status, header, body = @app.call(env)
      log(env, status, began_at)
      [status, header, body]
    end

    private

    #
    # Logs access log type messages to the logger's targets if the @access_log instance
    # variable exists
    #
    def log(env, status, began_at)
      now = Time.now
      msg = ACCESS_LOG_FORMAT % [
          env['HTTP_X_FORWARDED_FOR'] || env['REMOTE_ADDR'] || '-',
          env['REMOTE_USER'] || '-',
          now.strftime('%d/%b/%Y:%H:%M:%S %z'),
          env['REQUEST_METHOD'],
          env['PATH_INFO'],
          env['QUERY_STRING'].empty? ? '' : '?'+env['QUERY_STRING'],
          env['HTTP_VERSION'],
          status.to_s[0..3],
          now - began_at ]

      # Standard library logger doesn't support write but it supports << which actually
      # calls to write on the log device without formatting
      # logger = @logger || env['rack.logger']
      if @logger.respond_to?(:write)
        @logger.write(msg)
      else
        @logger << msg
      end
    end

  end

end
