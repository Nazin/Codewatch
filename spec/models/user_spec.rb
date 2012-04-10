require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: users
#
#  id          :integer         not null, primary key
#  mail        :string(64)      not null
#  name        :string(32)      not null
#  passHash    :string(40)      not null
#  passSalt    :string(5)       not null
#  fullName    :string(64)
#  havePicture :boolean         default(FALSE)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

