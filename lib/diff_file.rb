module Codewatch

  require 'diff_executor'

  class DiffLine
    attr_reader :status # :mutual, :fake, :extra
    attr_accessor :line

    def initialize status, line=""
      @status=status
      @line=line
    end
  end

  class DiffFile
    include Enumerable

    def initialize
      @lines =[]
    end

    def mutual line=""
      @lines << (DiffLine.new :mutual, line)
    end

    def fake line=""
      @lines << (DiffLine.new :fake, line)
    end

    def extra line=""
      @lines << (DiffLine.new :extra, line)
    end

    #iterate over real lines
    def each_real
      @lines.each do |diff_line|
        if diff_line.status == :fake
          next
        end
        yield diff_line
      end
    end

    #iterate over real lines with index
    def each_real_with_index
      i = 0
      each_real do |real|
        yield real, i
        i+=1
      end
    end

    #number of lines
    def size
      @lines.size
    end

    def each
      @lines.each { |elt| yield elt }
    end

    #returns two DiffFile instances
    def self.diff code_a, code_b
      DiffExecutor.execute_diff code_a, code_b
    end
  end

end
