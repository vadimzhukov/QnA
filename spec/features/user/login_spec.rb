require "rails_helper"

feature "user signs in with Email and password", "
  In order to ask questions or leave answers,
  As unathenticated user,
  I can sign in
" do
  given(:user) { create(:user) }

  background do
    visit new_user_session_path
  end

  scenario "registered user enters right Email and Password" do
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect(page).to have_content "Signed in successfully"
  end

  scenario "unregistered user tries to sign in" do
    fill_in "Email", with: "unexistedemail@qna.com"
    fill_in "Password", with: "password"
    click_button "Log in"

    expect(page).to have_content "Invalid Email or password"
  end
end

feature "user signs in with OAuth" do

  context "GitHub" do
    it "can sign in with github account" do
      visit new_user_session_path
      page.should have_content("Sign in with GitHub")
      mock_auth_hash_with_email("github")
      click_link "Sign in with GitHub"
      page.should have_content("Successfully authenticated from github account.")
    end

    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      visit new_user_session_path
      page.should have_content("Sign in with GitHub")
      click_link "Sign in with GitHub"
      page.should have_content('Could not authenticate you from GitHub because "Invalid credentials"')
    end
  end

  context "Twitter" do
    it "can sign in with twitter account" do
      visit new_user_session_path
      page.should have_content("Sign in with GitHub")
      mock_auth_hash_without_email("twitter")
      click_link "Sign in with Twitter"
      
      page.should have_content("Email registration")
      fill_in "Email", with: "unique@qna.com"
      click_button "Register"

      message = ActionMailer::Base.deliveries.last
      message_page = Capybara.string(message.body.to_s)
      message_page.should have_content("Please follow the \n  link \nto confirm your email")
      url = message_page.find(:link, "link")[:href]
      visit url

      page.should have_content("Your account was successfully created, please login")
      click_link "Sign in with Twitter"

      page.should have_content("Successfully authenticated from twitter account.")
    end
  
  end
end
