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
    

    Rails.logger.fatal "1111111111111111111111111111111111"

    #TODO index of out bound lines.size-1
    lines = @highlighted[0].lines.to_a
    lines[0]["<div class=\"highlight\"><pre>"]=""
    Rails.logger.fatal lines.inspect
#    lines[lines.size-1]["</pre>"]=""
                        
    i = 0
    @diff_files[0].each_real do |line|
      line.line = lines[i]
      i+=1
    end

    lines = @highlighted[1].lines.to_a
    lines[0]["<div class=\"highlight\"><pre>"]=""
 #   lines[lines.size-1]["</pre>"]=""
                        
    i = 0
    @diff_files[1].each_real do |line|
      line.line = lines[i]
      i+=1
    end

    render 'show'
  end
 

  private

  class DiffLine
    attr_reader :status
    attr_accessor :line
    
    def initialize status, line=""
      @status=status
      @line=line
    end
  end

  class DiffFile
    include Enumerable
    
    def initialize
      @lines =[]
    end

    def add_mutual
      @lines << (DiffLine.new :mutual)
    end

    def add_fake 
      @lines << (DiffLine.new :fake)
    end
    
    def add_extra
      @lines << (DiffLine.new :extra)
    end

    def each_real
      @lines.each do |el|
        if el.status == :fake
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
        # diff_file_a.add_real
        # diff_file_b.add_real
       else
         case i[0,1]
         when "+" then 
           diff_file_a.add_extra
           diff_file_b.add_fake
         when "-"; then 
           diff_file_b.add_extra
           diff_file_a.add_fake
         else
           diff_file_b.add_mutual
           diff_file_a.add_mutual
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
