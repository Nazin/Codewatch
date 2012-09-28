module Codewatch

  module CwDiff

    require 'cgi'

    class CharHtmlizer

      # @param [DiffEnumerable] enumerable
      def initialize enumerable
        @enumerable = enumerable
      end

      # @return [String] htmlized diff
      def htmlize
        html_acc = @enumerable.inject("") do |html_acc, entry|
          fragment, operation = *entry
          fragment = CGI.escape_html(fragment)
          case operation
            when :lcs
              html_acc << apply_lcs_strategy(fragment)
            when :-
              html_acc << apply_red_strategy(fragment)
            when :+
              html_acc << apply_green_strategy(fragment)
          end
        end
        wrap_with_pre_tag(html_acc)
      end

      private

      # @param [String] fragment
      # @return [String]
      def apply_lcs_strategy fragment
        fragment
      end

      # @param [String] fragment
      # @return [String]
      def apply_red_strategy fragment
        "<span class=\"diff-fake\">#{fragment}</span>"
      end

      # @param [String] fragment
      # @return [String]
      def apply_green_strategy fragment
        "<span class=\"diff-extra\">#{fragment}</span>"
      end

      # @param [String] text
      # @return [String]
      def wrap_with_pre_tag(html)
        "<pre>" << html << "</pre>"
      end
    end

  end

end
