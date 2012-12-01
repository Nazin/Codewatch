module Codewatch

	module CwDiff

		class LineHtmlizer

			def initialize combiner, show_removed
				@combiner = combiner
				@show_removed = show_removed
			end

			def htmlize
				file_a, file_b = "", ""
				total_size = @combiner.each_dual_line_status do |statuses, combiner|
					case statuses
						when [:lcs, :lcs]
							file_a << (htmlize_lcs combiner.next_pygment_a)
							file_b << (htmlize_lcs combiner.next_pygment_b)
						when [:extra, :fake]
							temp = combiner.next_pygment_a
							file_a << (htmlize_extra temp)
							file_b << (htmlize_removed temp)
						when [:fake, :extra]
							temp = combiner.next_pygment_b
							file_a << (htmlize_removed temp)
							file_b << (htmlize_extra temp)
					end
				end
				[total_size, wrap_html(file_a), wrap_html(file_b)]
			end

		private
			def htmlize_lcs line
				"<div>#{line.empty? ? " " : line}</div>"
			end

			def htmlize_extra line
				"<div class=\"diff-new\">#{line.empty? ? " " : line}</div>"
			end
			
			def htmlize_removed line
				"<div class=\"diff-removed\">#{line.empty? || !@show_removed ? " " : line}</div>"
			end

			def wrap_html html
				'<div class="highlight"><pre>' << html << "</div>"
			end
		end
	end
end
