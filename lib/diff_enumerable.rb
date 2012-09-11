module Codewatch
  require 'diff/lcs'

  class DiffEnumerable
    include Enumerable

    #TODO test it, check arrays of lines
    # @param [String] code_a
    # @param [String] code_b
    def initialize code_a, code_b
      @code_a, @code_b = code_a, code_b
      @diff_result = ""
    end


    def each
      each_diff_part do |fragment, operation|
        yield [fragment, operation]
      end
    end

    # yield pairs representing sections of diff output
    # e,g, ["ala", :-] - means that "ala" must removed from first file to obtain lcs
    # @return [Object] - nothing
    def each_diff_part
      #list of difference_entries where each entry is an array of Diff::LCS::Chang objects
      #e.g. #<Diff::LCS::Change:0x0000000127f5a0 @action="-", @position=0, @element="a">
      # if action == "-" the position points to char at the first file that should be deleted to obtain lcs (longest common subsequence)
      # if action == "+" the position points to char at the second file that should be deleted to obtain lcs
      difference_array = Diff::LCS.diff(@code_a, @code_b)

      code_a_index = 0
      @chars_added = 0
      @chars_deleted = 0

      #difference_entry is a list of Diff::LCS::Change instances
      difference_array.each do |difference_entry|

        #obtain the index where deletion(-) or insertion(+) should be done transform code_a into code_b
        next_change_index = difference_entry[0].position

        if next_change_index_taken_from_b_file?(difference_entry[0]) then
          next_change_index = convert_position_from_code_b_to_code_a(next_change_index)
        end

        lcs_fragment, code_a_index = read_lcs_fragment(code_a_index, next_change_index)

        yield [lcs_fragment, :lcs]

        green_segment, red_segment, code_a_index = get_red_and_green_fragments(code_a_index, difference_entry)

        yield [red_segment, :-]
        yield [green_segment, :+]
      end
    end

    private

    def get_red_and_green_fragments(code_a_index, difference_entry)
      red_segment = ""
      green_segment = ""
      difference_entry.each do |difference_instance|
        if difference_instance.action == "+" then
          green_segment << difference_instance.element
          @chars_added+=1
        end
        if difference_instance.action == "-" then
          red_segment << difference_instance.element
          #increment index to skip chars from first file that are not in lcs
          code_a_index+=1
          @chars_deleted+=1
        end
      end
      [green_segment, red_segment, code_a_index]
    end

    # @param [Fixnum] code_a_index - first index of lcs fragment
    # @param [Fixnum] next_change_index - first element not in lcs fragment
    # @return [[String, Fixnum]] - pair of first element not read from lcs and read lcs fragment
    def read_lcs_fragment(code_a_index, next_change_index)
      fragment=@code_a[code_a_index...next_change_index]
      code_a_index+=next_change_index - code_a_index
      [fragment, code_a_index]
    end

    def convert_position_from_code_b_to_code_a(next_change_index)
      next_change_index-@chars_added+@chars_deleted
    end


    # @param [Diff::LCS::Change] difference_instance
    def next_change_index_taken_from_b_file?(difference_instance)
      difference_instance.action == "+"
    end
  end
end