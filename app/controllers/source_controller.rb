class SourceController < ApplicationController

  include CodeSnippetsHelper

  before_filter :company_member?


  def index
    repo = @project.repo
    @branches = repo.heads
    @current_branch_name = get_current_branch_name(repo)
    @current_branch_commits = repo.commits(@current_branch_name)
  end

  #TODO make it more restful
  #TODO incorporate branch name (its slug?) into url rather than in session
  def choose_branch
    branch_name = params[:branch_name]
    project_id = params[:project_id]
    store_branch_id(project_id, branch_name)
    redirect_to project_source_index_path
  end

  #shows given commit in a branch
  def show
    repo = @project.repo
    commits = repo.commits(params[:id])
    @commit = commits.first

    if commits[1].nil?
      @diffs = get_tree_diffs @commit.tree, [], ''
    else
      @diffs = Grit::Commit.diff repo, commits[1].id, params[:id]
    end
  end

  def tree

    repo = @project.repo

    #TODO last commit?
    last_commit = get_head_commit(repo)

    if params[:path].nil?
      tree = last_commit.tree
    else
      @path = params[:path]
      @path.gsub! '_', '/'
      tree = last_commit.tree/params[:path]
    end

    @tree = tree
  end

  def blob

    repo = @project.repo
    last_commit = get_head_commit(repo)
    @path = params[:path]
    @path.gsub! '_', '/' if not @path.nil?
    if params[:path].nil?
      #is it the case when file is in repo's root directory?
      @blob = repo.blob params[:blob_id]
    else
      #TODO does all repo have to have 'master' branch?
      @tree = last_commit.tree/params[:path]
      @blob = @tree.blobs.find { |b| b.id == params[:blob_id] }
    end

    @text = @blob.data
    #TODO ? use blob.mime_type method
    @textfile = (@blob.name =~ /\.rb|\.js|\.php|\.css/i) || (@textfile = @text.ascii_only?)

    if @textfile

      @lines = @text.lines.count+1

      lexer = nil

      if @blob.name =~ /\./i
        parts = @blob.name.split '.'
        lexer = Pygments::Lexer.find_by_extname '.' + parts[-1]
      end

      if lexer.nil?
        @highlighted = Pygments.highlight @text
      else
        @highlighted = lexer.highlight @text
      end

      @highlighted = @highlighted.gsub! "</pre>\n</div>", '</div></pre></div>'
      @highlighted = @highlighted.gsub! '<pre>', '<pre><div class="line">'
      @highlighted = @highlighted.gsub! /\n/, '</div><div class="line">'
      @highlighted = @highlighted.gsub! /\t/, '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
      @highlighted = @highlighted.gsub! '<div class="line"></div>', '<div class="line">&nbsp;</div>'

      @comment = @project.comments.build params[:comment]
      @comment.blob = @blob.id
      @comment.revision = repo.heads.first.commit.id #TODO z urla jak bedzie    #TODO narazie jest z cookies
      @comment.path = @path

      @comments = @project.comments.order('"comments"."startLine"').find_all_by_path_and_blob @path, @blob.id

      @ccomment = CommentComment.new
    end
  end

  private

  def get_head_commit repo
    branch_name = get_current_branch_name(repo)
    repo.commits(branch_name).first
  end

  def get_current_branch_name repo
    branch_name = get_branch_id(@project.id)
    if branch_name.blank?
      first_branch_name = repo.heads.first.name
      store_branch_id(@project.id, first_branch_name)
    end
    get_branch_id(@project.id)
  end

  def get_tree_diffs tree, elements, path

    for el in tree.contents

      if el.is_a? Grit::Tree
        elements = get_tree_diffs el, elements, (path != '' ? (File.join path, el.name) : el.name)
      else

        temp = Server::ServerDiff.new
        temp.deleted_file = false
        temp.new_file = false
        temp.a_blob = el.id
        temp.a_path = path != '' ? (File.join path, el.name) : el.name
        temp.tree = tree

        elements.push temp
      end
    end

    elements
  end
end
