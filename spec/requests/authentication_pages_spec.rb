require 'spec_helper'


RSpec.configure do |c|
  c.filter_run_excluding broken: true
end

describe "AuthenticationPages", broken: true do

  subject { page }

  let(:signin) { "Sign in" }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector 'h1', text: 'Sign in' }
    it { should have_selector 'title', text: 'Sign in' }
    it { should_not have_link 'Sign out' }
    it { should have_link 'Sign in', href: signin_path }
    it { should_not have_link 'Users', href: users_path }
    it { should_not have_link 'Settings' }

    describe "with invalid informations" do
      before { click_button signin }
      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "About" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_selector('title', text: user.name) }

      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      it { should have_link('Users', href: users_path) }
      it { should have_link('Settings', href: edit_user_path(user)) }


      describe "for signed-in user" do

        describe "visiting signup path" do
          before { visit signup_path }
          it { should_not have_selector 'title', text: full_title('Sign up') }
        end

        describe "submitting a CREATE request to the Users#create action" do
          before { post signup_path }
          specify { response.should redirect_to(root_path) }
        end
      end
    end
  end

  describe "authorization" do

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as admin user" do
      let(:admin) { FactoryGirl.create(:admin) }

      before { sign_in admin }
      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(admin) }

        describe "add admin account should be still present" do
          before { visit user_path(admin) }

          it { should have_selector 'title', text: admin.name }
        end
      end
    end

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "when attempting to visit a protected page" do
          before do
            visit edit_user_path(user)
            sign_in user
          end

          describe "after signing in" do

            it "should render the desired protected page" do
              page.should have_selector('title', text: 'Edit user')
            end

            describe "when signing in again" do
              before do
                visit signin_path
                sign_in user
              end

              it "should render the default (profile) page" do
                page.should have_selector('title', text: user.name)
              end
            end
          end
        end


        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, mail: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit user')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end

end
