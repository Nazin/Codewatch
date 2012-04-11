class DiffsController < ApplicationController
  def diff
  end

  def new 
    @lexers = @@lexers
  end


  def create
    inits = {}
    @snippets = []
    #TODO refactor params, -> new.html.erb
    lang = params[:diff][:lang]
    title = params[:title]
    code_1 = params[:code_1]
    code_2 = params[:code_2]
   

    @diff_files = diff code_1, code_2

    @highlighted = []
    @highlighted[0] = pygmentize code_1, lang
    @highlighted[1] = pygmentize code_2, lang
    
    i = 0
    h_array = @highlighted[0].split
    @diff_files[0].each_real do |line|
      line.line=h_array[i]
      i+=1
    end

    i = 0
    h_array = @highlighted[1].split
    @diff_files[1].each_real do |line|
      line.line=h_array[i]
      i+=1
    end
    render 'show'
  end
private

  class DiffLine
    attr_reader :is_real
    attr_accessor :line

    def initialize is_real, line=""
      @is_real=is_real
      @line=line
    end
  end

  class DiffFile
    include Enumerable
    
    def initialize
      @lines =[]
    end

    def add_real
      @lines << (DiffLine.new true)
    end

    def add_fake 
      @lines << (DiffLine.new false)
    end

    def each_real
      @lines.each do |el|
        unless el.is_real
          next
        end
        yield el
      end
    end
    
    def size
      @lines.size
    end

    def each
      @lines.each { |elt| yield elt }
    end

    
  end

 def diff code1, code2
   #TODO random filenames
   fileAName = "./tmp/filea"
   fileBName = "./tmp/fileb"
 
   fileA = File.new fileAName, "w+"
   fileB = File.new fileBName, "w+"
 
   fileA.write code1 + "\n"
   fileB.write code2 + "\n"
   fileA.close
   fileB.close
 
   lines = %x(diff --unified=999999 #{fileAName} #{fileBName})
   
   diff_file_a = DiffFile.new
   diff_file_b = DiffFile.new

   unless lines.empty?
     #TODO 99999 ?!
     lines.split(/\n/)[3..999999].each do |i|
       if i.empty?
         diff_file_a.add_real
         diff_file_b.add_real
       else
         case i[0,1]
         when "+" then 
           diff_file_a.add_real
           diff_file_b.add_fake
         when "-"; then 
           diff_file_b.add_real
           diff_file_a.add_fake
         else
           diff_file_b.add_real
           diff_file_a.add_real
         end
       end
     end
   end
 
   File.delete(fileAName)
   File.delete(fileBName)

   [diff_file_a, diff_file_b]
 end
  
 #TODO lexer
 def pygmentize code, lexer
   if lexer
     Pygments.highlight(code, lexer: "ruby" )
   else
     code
   end
 end


  class << self
    @@lexers =  Pygments::Lexer.all.sort { |a,b| a.name.downcase <=> b.name.downcase }
    @@lexers =  @@lexers.collect { |l| [l.name, l.aliases.first] }
  end 
end
