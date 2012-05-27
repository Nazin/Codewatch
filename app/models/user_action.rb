# == Schema Information
#
# Table name: user_actions
#
#  id       :integer         not null, primary key
#  key      :string(32)      not null
#  user_id  :integer         not null
#  isActive :boolean         default(TRUE)
#  atype    :integer(2)      not null
#

class UserAction < ActiveRecord::Base
	
	TYPE_ACTIVATION = 1
	TYPE_REMINDER = 2
	TYPE_INVITATION = 3
	
	belongs_to :user, :autosave => true
	
	def generate_key
		
		o = [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
		self.key = (0..31).map{o[rand(o.length)]}.join;
		
		self.key
	end
end
