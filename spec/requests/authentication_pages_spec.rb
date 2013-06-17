require 'spec_helper'

describe "Authentication" do

  subject { page }

  let(:users) { 'Users' }
  let(:profile) { 'Profile' }
  let(:setting) { 'Setting' }
  let(:signin) { 'Sign in' }
  let(:signout) { 'Sign out' }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content(signin) }
    it { should have_title(signin) }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button signin }

      it { should have_title(signin) }
      it { should have_error_message('Invalid') }
      it { should_not have_link(profile) }
      it { should_not have_link(setting) }
      it { should_not have_link(signout, href: signout_path) }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_title(user.name) }
      it { should have_link(users, href: users_path) }
      it { should have_link(profile, href: user_path(user)) }
      it { should have_link(setting, href: edit_user_path(user)) }
      it { should have_link(signout, href: signout_path) }
      it { should_not have_link(signin, href: signin_path) }

      describe "followed by signout" do
        before { click_link signout }
        it { should have_link(signin) }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end

        describe "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "visiting the followers page" do
          before { visit followers_user_path(user) }
          it { should have_title('Sign in') }
        end
      end

      describe "in the Microposts controller" do
        
        describe "submitting to the create action" do
          before { post microposts_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { expect(response).to redirect_to(signin_path) }
        end
        
        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "in the Users controller" do

        describe "when attempting to visit a new page" do
          before { visit new_user_path }
          it { should have_content(user.name) }
        end

        describe "submitting a POST request to the Users#signup action" do
          before { post users_path(user) }
          specify { expect(response).to redirect_to(root_path) }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title(full_title('Edit user')) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end
  end
end
