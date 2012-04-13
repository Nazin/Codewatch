class Diff
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :code_a, :code_b, :title, :lang, :url_a, :url_b

  validates_with DiffValidator
  validates :title, presence: true, length: {maximum: 50, minumum: 5}
  validates :lang, presence: true  #TODO #, inclusion: { in: DiffController.lexers }



  def build
    return false unless valid?
    if use_urls?
      @sha_a = extract_sha @url_a
      @sha_b = extract_sha @url_b
      if cannot_retrieve_shas?
        add_sha_errors
        return
      end
      @snippet_a = CodeSnippet.find_by_sha @sha_a
      @snippet_b = CodeSnippet.find_by_sha @sha_b
      if cannot_retrieve_snippets?
        add_snippet_errors
        return
      end
      @code_a = @snippet_a.code
      @code_b = @snippet_b.code
    end
    true
  end

    
    

  def initialize attributes={}
    attributes.each do |name,value|
      send "#{name}=", value
    end
  end

  def persisted?
    false
  end

private
  
  def add_snippet_errors
    errors[:url_a]="Snippet not found" unless @snippet_a
    errors[:url_b]="Snippet not found" unless @snippet_b
  end
  
  def cannot_retrieve_snippets?
    !@snippet_a || !@snippet_b
  end
  
  def add_sha_errors
    errors[:url_a]="Invalid Url" unless @sha_a
    errors[:url_b]="Invalid Url" unless @sha_b
  end
  
  def cannot_retrieve_shas?
    !@sha_a || !@sha_b
  end
  
  def extract_sha url
    sha_regex = /\/([a-f0-9]{40})/
    m = url.match sha_regex
    return m[1] if m
    false
  end

  def use_urls? 
    @code_b.blank? && @code_a.blank?
  end
end

