module Codewatch
  class DiffExecutor

    require 'diff_file'

    #calculates diff of two texts
    #returns pair of diffed files as DiffFile
    def self.execute_diff code_a, code_b
      #TODO random filenames
      #TODO 2 UNIQUE file names
      filename_a= "./tmp/filea"
      filename_b= "./tmp/fileb"


      write_code_to_files(code_a, code_b, filename_a, filename_b)

      diff_lines = execute_diff_command(filename_a, filename_b)

      diff_a, diff_b = create_diff_files_based_on_diff_output(code_a, diff_lines)

      File.delete filename_a
      File.delete filename_b

      [diff_a, diff_b]
    end

    #code_a - one of the original files (possibly must be first one)
    #dif_lines - array of lines from diff command
    #returns [diff_a, diff_b] - DiffFile instances
    def self.create_diff_files_based_on_diff_output(code_a, diffed_lines)
      diff_a = DiffFile.new
      diff_b = DiffFile.new

      #TODO why diffed_lines might be nil?
      if !diffed_lines
        0.upto(code_a.lines.count-1) do |i|
          diff_a.mutual
          diff_b.mutual
        end
      else
        diffed_lines.each do |line|
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
      end
      return diff_a, diff_b
    end

    def self.write_code_to_files(code_a, code_b, filename_a, filename_b)
      File.open(filename_a, "w+") do |file_a|
        File.open(filename_b, "w+") do |file_b|
          file_a.write code_a + "\n"
          file_b.write code_b + "\n"
        end
      end
    end

    private

    #returns an array of diffed lines
    #lines may start with +, -, or space
    def self.execute_diff_command(filename_a, filename_b)
      diff_result = %x(diff --unified=999999 #{filename_a} #{filename_b})
      puts diff_result
      diff_lines = diff_result.lines.to_a
      diff_lines = diff_lines[3..999999]
      diff_lines
    end
  end


end