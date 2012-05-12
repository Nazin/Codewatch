class UserAction < ActiveRecord::Base
	
	TYPE_ACTIVATION = 1
	TYPE_REMINDER = 2
	TYPE_INVITATION = 3
	
	belongs_to :user
	
	def generate_key
		
		o = [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
		self.key = (0..31).map{o[rand(o.length)]}.join;
		
		self.key
	end
end
