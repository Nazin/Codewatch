# == Schema Information
#
# Table name: invitations
#
#  id         :integer         not null, primary key
#  mail       :string(64)      not null
#  key        :string(32)      not null
#  isActive   :boolean         default(TRUE)
#  company_id :integer         not null
#  role       :integer(2)      not null
#

require 'spec_helper'

describe Invitation do
	pending "add some examples to (or delete) #{__FILE__}"
end
