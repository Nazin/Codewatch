class Project < ActiveRecord::Base
	
	TYPE_SVN = 1
	TYPE_GIT = 2
	
	belongs_to :company
end
