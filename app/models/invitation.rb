class Invitation < ActiveRecord::Base
	
	attr_accessible :mail, :role
	
	belongs_to :company, :autosave => true
	
	validates :mail, presence: true, length: {maximum: 64}, email: {strict_mode: true}
	validates :role, presence: true, inclusion: { in: 1..4 }
	
	def generate_key
		
		o = [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
		self.key = (0..31).map{o[rand(o.length)]}.join;
		
		self.key
	end
end
