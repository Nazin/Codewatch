module Codewatch

	module CwDiff

		class LinePygmentCombiner

			# @param [Array of Strings] code_a
			# @param [Array of Strings] code_b
			# @param [String] pygmentized_a
			# @param [String] pygmentized_b
			def initialize (code_a, diff_enumerable, pygmentized_a, pygmentized_b)
				@code_a = code_a
				@diff_enumerable = diff_enumerable
				@pygmentized_a, @pygmentized_b = prepare(pygmentized_a), prepare(pygmentized_b)
			end

			# @return [Fixnum] - total size
			def each_dual_line_status
				return 0 if @code_a.empty? && @code_b.empty?

				@pygmentized_a_index, @pygmentized_b_index = 0, 0

				total_size = each_dual_line_status_inner(@diff_enumerable.lines_mode) do |statuses|
					yield statuses, self
				end

				total_size
			end

			def next_pygment_a
				@pygmentized_a[@pygmentized_a_index].tap { @pygmentized_a_index+=1 }
			end

			def next_pygment_b
				@pygmentized_b[@pygmentized_b_index].tap { @pygmentized_b_index+=1 }
			end

			private

			def prepare pygmentized
				lines = pygmentized.lines.to_a.each { |line| line.gsub! "\n", "" }
				lines[0]["<div class=\"highlight\"><pre>"]
				lines
			end


			# @param [DiffEnumerable] diff_enumerable
			# @return [Fixnum] - total count all entries
			def each_dual_line_status_inner diff_enumerable
				diff_enumerable.inject(0) do |count, entry|
					p "each_dual_line_status, count: #{count}, entry: #{entry}"
					fragment, operation = *entry
					case operation
						when :lcs
							yield [:lcs, :lcs]
						when :-
							yield [:extra, :fake]
						when :+
							yield [:fake, :extra]
					end
					count+=1
				end
			end

		end

	end

end