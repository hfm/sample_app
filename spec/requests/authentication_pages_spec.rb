require 'spec_helper'

describe "Authentication" do

  subject { page }

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

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }

      it { should have_title(user.name) }
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
end
