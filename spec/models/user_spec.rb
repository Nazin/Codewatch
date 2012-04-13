# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  mail            :string(64)      not null
#  name            :string(32)      not null
#  fullName        :string(64)
#  havePicture     :boolean         default(FALSE)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#

require 'spec_helper'

describe User do
  

 #TODO salts!
  before { @user = User.new(name: "Example User", mail: "user@example.com", passHash: "a", passSalt: "aa") }
  
  subject { @user }
  
  it { should respond_to(:name) }
  it { should respond_to(:mail) }

  describe "when email address is already taken (case insensitivity)" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.mail = @user.mail.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when mail is not present" do
    before { @user.mail = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a"*33 }
    it { should_not be_valid }
  end

  describe "when name is too short" do
    before { @user.name = "aa" } 
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |invalid_address|
        @user.mail = invalid_address
        @user.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.mail = valid_address
        @user.should be_valid
      end      
    end
  end

end
