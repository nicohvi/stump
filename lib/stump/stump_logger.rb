require 'logger'

module Stump

  #
  # The StumpLogger ensures that the logger provided (could be a standard Ruby Logger)
  # gets called by Rack.
  #
  class StumpLogger
    def initialize(app, logger, level_threshold = ::Logger::INFO)
      @app = app
      @logger = logger
      @logger.level = level_threshold
    end

    def call(env)
      env['rack.logger'] = @logger
      @app.call(env)
    end
  end

end