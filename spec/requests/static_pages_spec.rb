require 'spec_helper'

describe "StaticPages" do

  describe "Home page" do

    it "should have the content 'Home'" do
      visit '/static_pages/home'
      expect(page).to have_content('Home')
    end
    
    it "should have the base title" do
      visit '/static_pages/home'
      expect(page).to have_title('Ruby on Rails Tutorial Sample App')
    end
    
    it "should not have a custom page title" do
      visit '/static_pages/home'
      expect(page).not_to have_title("| Home")
    end
  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end
    
    it "should have the base title" do
      visit '/static_pages/help'
      expect(page).to have_title('Ruby on Rails Tutorial Sample App')
    end
    
    it "should not have a custom page title" do
      visit '/static_pages/help'
      expect(page).not_to have_title("| Help")
    end
  end

  describe "About page" do

    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end
    
    it "should have the base title" do
      visit '/static_pages/about'
      expect(page).to have_title('Ruby on Rails Tutorial Sample App')
    end
    
    it "should not have a custom page title" do
      visit '/static_pages/about'
      expect(page).not_to have_title("| About Us")
    end
  end

  describe "Contact page" do

    it "should have the content 'Contact'" do
      visit '/static_pages/contact'
      expect(page).to have_content('Contact')
    end
    
    it "should have the base title" do
      visit '/static_pages/contact'
      expect(page).to have_title('Ruby on Rails Tutorial Sample App')
    end
    
    it "should not have a custom page title" do
      visit '/static_pages/contact'
      expect(page).not_to have_title("| Contact")
    end
  end
end
