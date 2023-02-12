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
