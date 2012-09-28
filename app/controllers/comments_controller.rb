class CommentsController < ApplicationController
	
	before_filter :company_admin?, only: [:destroy]
	
	def new
		
		@comment = @project.comments.build params[:comment]
		@comment.author = current_user
		
		respond_to do |format|
			if @comment.save
				log Log::Type::NEW_CODE_COMMENT
				format.json { render json: @comment.to_json(:include => { :author => { :only => [:name, :id] }}), status: :created }
			else
				format.json { render json: @comment.errors, :status => :unprocessable_entity }
			end
		end
	end
	
	#to create comment for "Comment"
	def new2
		
		@comment = @project.comments.find params[:id]
		@ccomment = @comment.comments.build params[:comment_comment]
		@ccomment.author = current_user
		
		respond_to do |format|
			if @ccomment.save
				log Log::Type::NEW_COMMENT_COMMENT
				format.json { render json: @ccomment.to_json(:include => { :author => { :only => [:name, :id] }}), status: :created }
			else
				format.json { render json: @ccomment.errors, :status => :unprocessable_entity }
			end
		end
	end
	
	def destroy
		
		@comment = @project.comments.find params[:id]
		path = @comment.path
		blob = @comment.blob
		branch = @comment.branch
		@comment.destroy
		flash[:success] = "Comment removed"
		
		if path.nil? || path == ''
			redirect_to project_branch_blob_path(@project, branch, blob)
		else
			path.gsub! '/','_'
			redirect_to project_parent_branch_blob_path(@project, branch, path, blob)
		end
	end
	
	def show
		
		@comment = @project.comments.find params[:id]
		@comments = @comment.comments.all(:include => :author, :order => :created_at)
		
		respond_to do |format|
			format.json { render json: @comments.to_json(:include => { :author => { :only => [:name, :id] }}) }
		end
	end
private
	
	def log type
		
		path = @comment.path
		
		if path.nil? || path == ''
			url = project_branch_blob_path @project, @comment.branch, @comment.blob
		else
			path.gsub! '/','_'
			url = project_parent_branch_blob_path @project, @comment.branch, path, @comment.blob
		end
		
		url += '#comment_' + @comment.id.to_s
		
		Log.it type, @project, current_user, {message: url}
	end
end
