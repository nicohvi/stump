require 'logger'

module Stump

  #
  # The StumpLogger ensures that the logger provided (could be a standard Ruby Logger)
  # gets called by Rack.
  #
  class StumpLogger

    # Adheres to the Apache Common Log format: http://en.wikipedia.org/wiki/Common_Log_Format
    ACCESS_LOG_FORMAT = %{%s - %s [%s] "%s %s%s %s" %d %0.4f \n}

    def initialize(app, options = {})
      @app = app
      @logger = options[:logger] || ::Logger.new(STDOUT, 'daily')
      @logger.level = extract_threshold(options[:logger_threshold])
      format_log(@logger) if options[:custom_format]
      @access_log = options[:access_log]
    end

    def call(env)
      env['rack.logger'] = @logger
      began_at = Time.now
      status, header, body = @app.call(env)
      access_log(env, status, began_at) unless @access_log.nil?
      [status, header, body]
    end

    private

    #
    # Logs access log type messages to the logger's targets if the @access_log instance
    # variable exists
    #
    def access_log(env, status, began_at)
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
      logger = @logger || env['rack.logger']
      if logger.respond_to?(:write)
        logger.write(msg)
      else
        logger << msg
      end
    end

    #
    # +INFO+ is the default logging level threshold if none is provided.
    #
    def extract_threshold(threshold)
      case threshold
        when 'debug'
          return ::Logger::DEBUG
        when 'info'
          return ::Logger::INFO
        when 'warn'
          return ::Logger::WARN
        else
          return ::Logger::INFO
      end
    end

    #
    # Formats the log to the following pattern:
    #   "#{severity} @ [ #{datetime} ] : #{message} "
    # e.g "DEBUG @ [2012-21-12 - 10:37:07] : The world is ending, did you remember to bring fancy hats?"
    #
    def format_log(logger)
      logger.datetime_format = '%Y-%m-%d - %H:%M:%S' # e.g. "2004-01-03 00:54:26"
      logger.formatter = proc do |severity, datetime, progname, msg|
        "#{severity} @ [#{datetime}] : #{msg} \n"
      end
    end

  end

end
