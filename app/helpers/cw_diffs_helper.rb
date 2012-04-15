module CwDiffsHelper
	
	def diff_file_to_html diff_file
		html = '<div class="highlight"><pre>'
		diff_file.each do |el|
			if el.status == :fake
				html << "<div class=\"diff-fake\"> </div>"
			elsif el.status == :mutual
				html << "<div class=\"diff-mutual\">#{el.line}</div>"
			elsif el.status == :extra
				html << "<div class=\"diff-extra\">#{el.line}</div>"
			end
		end					
		html << "</div>"
		html
	end

end
