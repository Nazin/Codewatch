# == Schema Information
#
# Table name: projects
#
#  id         :integer         not null, primary key
#  name       :string(32)      not null
#  ptype      :integer(2)      not null
#  location   :string(128)     not null
#  company_id :integer         not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Project < ActiveRecord::Base
	
	TYPE_SVN = 1
	TYPE_GIT = 2
	
	belongs_to :company
	has_and_belongs_to_many :users
	has_many :tasks
	
	attr_accessible :name, :ptype, :location, :user_ids
	validates :company_id, presence: true
	validates :location, presence: true, length: {maximum: 128 }
	validates :name, presence: true, length: {maximum: 32 }
	validates :ptype, presence: true, inclusion: { in: 1..2 }
end
