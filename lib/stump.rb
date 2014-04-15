require 'stump/logger_targets'
require 'stump/access_log'
require 'stump/version'
require 'logger'

module Stump

  module Logger

    #
    # Initialize a new Logger with the desired *targets*: either STDOUT,
    # a log file or both.
    # *path* is an array of file paths.
    #
    def self.new(path=nil)
      return ::Logger.new(LoggerTargets.new(STDOUT)) unless path

      if FileTest.exist?(path)
        log_file = File.open(path, 'a')
      else
        FileUtils.mkdir_p(File.dirname(path))
        log_file = File.new(path, 'w')
      end

      ::Logger.new LoggerTargets.new(STDOUT, log_file)
    end

  end

end
