# == Schema Information
#
# Table name: user_companies
#
#  id         :integer         not null, primary key
#  user_id    :integer         not null
#  company_id :integer         not null
#  role       :integer(2)      not null
#

class UserCompany < ActiveRecord::Base
	
	belongs_to :user
	belongs_to :company
end
