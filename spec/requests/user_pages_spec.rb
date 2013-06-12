require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do
      before (:all) { 30.times {FactoryGirl.create(:user) } }
      after (:all) { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete').to change(User, :count).by(-1) }
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      31.times { FactoryGirl.create(:micropost, user: user) } 
      sign_in user
      visit user_path(user)
    end

    describe "should have correct user" do
      it { should have_content(user.name) }
      it { should have_title(user.name) }
    end

    describe "should have correct microposts" do
      it { should have_selector('div.pagination') }
      it { should have_content(user.microposts.count) }

      it "should have 30 contents at page 1" do
        count = 0
        user.microposts.paginate(page: 1).each do |micropost|
          expect(page).to have_selector('li', text: micropost.content)
          count += 1
        end
        expect(count).equal? 30
      end

      it "should have 1 content at page 2" do
        count = 0
        user.microposts.paginate(page: 2).each do |micropost|
          expect(page).to have_selector('li', text: micropost.content)
          count += 1
        end
        expect(count).equal? 1
      end
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with:"Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }

      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success')  }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name    }
      specify { expect(user.reload.email).to eq new_email   }
    end

    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end

      before { patch user_path(user), params }
      specify { expect(user.reload).not_to be_admin }
    end
  end
  
  describe "other users pages" do
    let(:user_me) { FactoryGirl.create(:user) }
    let(:user_other) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user_other, content: "Foo") }
    before do
      sign_in user_me
      visit user_path(user_other)
    end

    describe "delete links" do
      it { should_not have_link('delete') }
    end
  end

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_title(full_title("Following")) }
      it { should have_selector("h3", text: "Following") }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_title(full_title("Followers")) }
      it { should have_selector("h3", text: "Followers") }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end
end
