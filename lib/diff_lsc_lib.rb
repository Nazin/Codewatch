module Codewatch

  require 'diff/lcs'
  require 'cgi'
  class DiffLcsLib

    # @param [String] code_a
    # @param [String] code_b
    # @return [String]
    def self.execute_diff code_a, code_b
      #list of difference_entries where each entry is an array of Diff::LCS::Chang objects
      #e.g. #<Diff::LCS::Change:0x0000000127f5a0 @action="-", @position=0, @element="a">
      difference_array = Diff::LCS.diff(code_a, code_b)

      p difference_array

      html_result = ""
      code_a_index = 0
      chars_added = 0
      chars_deleted = 0
      difference_array.each do |difference_entry|
        next_change_index = difference_entry[0].position

        if difference_entry[0].action == "+" then
          while (code_a_index < (next_change_index-chars_added+chars_deleted))
            html_result << CGI::escapeHTML(code_a[code_a_index])
            code_a_index+=1
          end
        elsif difference_entry[0].action == "-" then
          while (code_a_index < (next_change_index))
            html_result << CGI::escapeHTML(code_a[code_a_index])
            code_a_index+=1
          end
        else
          raise Exception.new
        end

        red_segment = ""
        green_segment = ""
        difference_entry.each do |difference_instance|
          if difference_instance.action == "+" then
            green_segment << difference_instance.element
            chars_added+=1
          end
          if difference_instance.action == "-" then
            red_segment << difference_instance.element
            code_a_index+=1
            chars_deleted+=1
          end
        end
        red_segment = htmlize_red(CGI::escapeHTML(red_segment))
        green_segment = htmlize_green(CGI::escapeHTML(green_segment))

        html_result << red_segment << green_segment
      end
      wrap_with_pre(html_result)
    end

    # @param [String] arg
    # @return [String]
    def self.htmlize_red arg
      "<span class=\"diff-fake\">#{arg}</span>"
    end

    # @param [String] arg
    # @return [String]
    def self.htmlize_green arg
      "<span class=\"diff-extra\">#{arg}</span>"
    end

    # @param [String] text
    # @return [String]
    def self.wrap_with_pre(html)
      "<pre>" << html << "</pre>"
    end
  end
end