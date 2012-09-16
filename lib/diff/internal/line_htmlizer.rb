module Codewatch

  module CwDiff

    class LineHtmlizer

      def initialize combiner
        @combiner = combiner
      end

      def htmlize
        file_a, file_b = "", ""
        total_size = @combiner.each_dual_line_status do |statuses, combiner|
          case statuses
            when [:lcs, :lcs]
              file_a << htmlize_lcs(combiner.next_pygment_a)
              file_b << htmlize_lcs(combiner.next_pygment_b)
            when [:extra, :fake]
              file_a << htmlize_extra(combiner.next_pygment_a)
              file_b << HTMLIZED_FAKE
            when [:fake, :extra]
              file_a << HTMLIZED_FAKE
              file_b << htmlize_extra(combiner.next_pygment_b)
          end
        end
        [total_size, wrap_html(file_a), wrap_html(file_b)]
      end

      private
      HTMLIZED_FAKE = "<div class=\"diff-fake\"> </div>"

      #TODO: when line is empty no line is visible in browser (at least chrome), find better solution that current hack
      def htmlize_lcs line
        "<div class=\"diff-mutual\">#{line.empty? ? " " : line}</div>"
      end

      def htmlize_extra line
        "<div class=\"diff-extra\">#{line.empty? ? " " : line}</div>"
      end

      def wrap_html html
        '<div class="highlight"><pre>' << html << "</div>"
      end

    end

  end

end