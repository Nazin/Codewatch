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
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#  isActive        :boolean         default(FALSE)
#

require 'spec_helper'

describe User do


	before { @user = User.new(name: "Example User", mail: "user@example.com", password: "password", password_confirmation: "password") }

	subject { @user }

	it { should respond_to :name }
	it { should respond_to :mail }
	it { should respond_to :password_digest }
	it { should respond_to :password }
	it { should respond_to :password_confirmation }
	it { should respond_to :authenticate }
	it { should respond_to :remember_token }
	it { should respond_to :admin }
	it { should respond_to :public_key }

	it { should respond_to :projects }
	it { should respond_to :owned_tasks } #TODO test if returns correct values
	it { should respond_to :assigned_tasks } #TODO test if returns correct values
	it { should respond_to :owned_tasks_histories }
	it { should respond_to :assigned_tasks_histories }
	it { should respond_to :companies }

	it { should be_valid }
	it { should_not be_admin }

	describe "accessible attributes" do
		it "should not allow access to admin" do
			expect do
				User.new admin: true
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "with admin attribute set to 'true'" do
		before { @user.toggle!(:admin) }

		it { should be_admin }
	end

	describe "remember token" do
		before { @user.save }
		its(:remember_token) { should_not be_blank } # eq: it { @user.remember_token.should_not be_blank }
	end

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should be_invalid }
	end

	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) { User.find_by_mail(@user.mail) }

		describe "with valid password" do
			it { should == found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }

			it { should_not == user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end
	end

	describe "when password confirmation is nil" do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

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
