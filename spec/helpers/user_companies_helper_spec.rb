require 'spec_helper'


describe UserCompanyHelper do
	include SessionsHelper

	before {
		@company = Company.create name: "PZU", slug: "pz"
		@user = User.create name: "Example User", mail: "user@example.com", password: "password", password_confirmation: "password"
		@user_company = @user.user_companies.build role: UserCompany::ROLE_USER
		@user_company.company = @company
		@user_company.save
		@current_user = @user # for SessionsHelper::current_user

	}
	
	subject { @result }

	describe "user has_role? role method" do
		before {
			@result = has_role? UserCompany::ROLE_USER 
		}
		it{ should be_true }
  end

	
	describe "ROLE_SPECTATOR" do
		before {@result = company_spectator? }
		it { should be_false }
	end


	describe "with changed role" do
		before { 
			@user_company.role= UserCompany::ROLE_ADMIN 
			@user_company.save
			@result = company_admin?
		}
		it { should be_true }
	
	end


end
