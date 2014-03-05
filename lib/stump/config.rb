require 'logger'
require 'logger_targets'

module Stump

  #
  # Instantiates a new Logger and provides a LoggerTargets object as the logger's LogDevice.
  # The LoggerTargets object can write to several targets in contrast to a regular device.
  #
  class Config
    def self.init(options = {})
      log_path = options[:path]
      return Logger.new LoggerTargets.new(STDOUT) if log_path.nil?

      if FileTest.exist?(log_path)
        log_file = File.open(log_path, 'a')
      else
        log_file = File.new(log_path, 'w')
      end
       Logger.new LoggerTargets.new(STDOUT, log_file)
    end

  end
end