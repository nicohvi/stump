module Stump

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