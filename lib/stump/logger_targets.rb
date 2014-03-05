module Stump

  #
  # LoggerTargets gets passed to the Logger.rb instantiate method as its *logdevice*. Thus whenever *write*
  # is called for the logger, the *write* method defined below is called. This method loops through the predefined
  # targets (usually a file and STDOUT) and writes to them. *flush* is necessary due to the fact that *write* is
  # a buffered method.
  #
  class LoggerTargets

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