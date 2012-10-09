# == Schema Information
#
# Table name: milestones
#
#  id         :integer         not null, primary key
#  name       :string(32)      not null
#  deadline   :datetime
#  project_id :integer         not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Milestone < ActiveRecord::Base
  belongs_to :project
  has_many :tasks

  attr_accessible :name, :deadline

  validates :name, presence: true, length: {maximum: 32}
end
