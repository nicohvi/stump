require 'logger'
require 'logger_targets'

module Stump

  class Config
    def self.init(options)
      log_path = options[:path]
      if FileTest.exist?(log_path)
        log_file = File.open(log_path, 'a')
      else
        log_file = File.new(log_path, 'w')
      end
       Logger.new LoggerTargets.new(STDOUT, log_file)
    end

  end
end