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

feature "user signs in with Github" do

  it "can sign in with github account" do
    visit new_user_session_path
    page.should have_content("Sign in with GitHub")
    mock_auth_hash
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
