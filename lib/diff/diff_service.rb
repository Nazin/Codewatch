module Codewatch

  require 'internal/char_htmlizer'
  require 'internal/line_pygment_combiner'
  require 'internal/enumerable'
  require 'internal/line_htmlizer'

  class DiffService

    # @param [String] code_a
    # @param [String] code_b
    # @param [String] pygmentized_a
    # @param [String] pygmentized_b
    # @return [Fixnum, String, String] - size, diff_a, diff_b
    def self.line_diff code_a, code_b, pygmentized_a, pygmentized_b
      code_a, code_b = code_a.lines.to_a, code_b.lines.to_a

      enumerable = CwDiff::DiffEnumerable.new(code_a, code_b)
      combiner = CwDiff::LinePygmentCombiner.new(code_a, enumerable, pygmentized_a, pygmentized_b)
      size, diff_a, diff_b = CwDiff::LineHtmlizer.new(combiner).htmlize

      [size, diff_a, diff_b]
    end

    # @param [String] code_a
    # @param [String] code_b
    # @return [String] diff
    def self.char_diff code_a, code_b
      enumerable = CwDiff::DiffEnumerable.new(code_a, code_b)
      diff = CwDiff::CharHtmlizer.new(enumerable).htmlize

      diff
    end

  end

end