require 'stump/version'
require 'rubyg'
require 'logger'
require 'logger_targets'

module Stump

  def init(options)
    log_path = options[:path]
    if  FileTest.exist?(log_path)
      log_file = open_logger(log_path)
    else
      log_file = create_logger(log_path)
    end

     Logger.new LoggerTargets.new(STDOUT, log_file)

  end

  private

  def open_logger(file_path)
    File.open(log_path, 'a')
  end

  def create_logger(file_path)
    File.new(log_path)
  end

end
