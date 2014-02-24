require 'stump/version'
require 'logger'

require 'logger'

module Stump
  # Sets up rack.logger to write to rack.errors stream
  class Logger
    def initialize(app, logger, level_threshold = ::Logger::INFO)
      @app = app
      @logger = logger
      @level_threshold = level_threshold
    end

    def call(env)
      logger = @logger
      logger.level = @level_threshold

      env['rack.logger'] = logger

        @app.call(env)
    end
  end

  class MultiIO
    def initialize(*targets)
      @targets = targets
    end

    def write(*args)
      @targets.each do |t|
        t.write(*args)
        t.flush
      end
    end

    def close
      @targets.each(&:close)
    end
  end

end