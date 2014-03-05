require 'logger'

module Stump

  class StumpLogger
    def initialize(app, logger, level_threshold = ::Logger::INFO)
      @app = app
      @logger = logger
      @logger.level = level_threshold
    end

    def call(env)
      @app.call(env)
    end
  end

end