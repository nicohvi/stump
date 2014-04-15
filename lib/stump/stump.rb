require 'logger'
require 'stump/logger_targets'

module Stump

  #
  # Instantiates a new Logger and provides a LoggerTargets object as the logger's LogDevice.
  # The LoggerTargets object can write to several targets in contrast to a regular device.
  #
    def self.new(path = {})
      return Logger.new(LoggerTargets.new(STDOUT)) unless path

      if FileTest.exist?(path)
        log_file = File.open(log_path, 'a')
      else
        FileUtils.mkdir_p(File.dirname(log_path))
        log_file = File.new(log_path, 'w')
      end

       Logger.new(LoggerTargets.new(STDOUT, log_file), shift_age)
    end

    def level=(level)

    end

end
