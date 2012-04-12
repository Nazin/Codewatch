module Codewatch
 
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

    def each_real
      @lines.each do |diff_line|
        if diff_line.status == :fake
          next
        end
        yield diff_line
      end
    end

    def each_real_with_index 
      i = 0
      each_real do |real|
        yield real,i
        i+=1
      end
    end
    
    def size
      @lines.size
    end

    def each
      @lines.each { |elt| yield elt }
    end
  
    def self.diff code_a, code_b
      #TODO random filenames
      filename_a= "./tmp/filea"
      filename_b= "./tmp/fileb"
      

      File.open(filename_a, "w+") do |file_a|
        File.open(filename_b, "w+") do |file_b|
          file_a.write code_a + "\n"
          file_b.write code_b + "\n"
        end
      end
      
      diff_result = %x(diff --unified=999999 #{filename_a} #{filename_b})
      diff_lines = diff_result.lines.to_a
      diff_lines = diff_lines[3..999999]

      diff_a = DiffFile.new
      diff_b = DiffFile.new
      
            
      diff_lines.each do |line|
       
        unless line.empty?
          case line[0]
          when "+"
            diff_a.fake line
            diff_b.extra line
          when "-"
            diff_a.extra line
            diff_b.fake line
          else
            diff_a.mutual line
            diff_b.mutual line
          end
        end

      end
      File.delete filename_a
      File.delete filename_b
      
      [diff_a, diff_b]
    end
  end

end
