require 'stump/logger_targets'
# require 'stump/stump'
# require 'stump/stump_logger'

module Stump

  p "fuck the world"

  class Logger

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

end

end
