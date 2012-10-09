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

require 'spec_helper'

describe UserAction do
	pending "add some examples to (or delete) #{__FILE__}"
end
