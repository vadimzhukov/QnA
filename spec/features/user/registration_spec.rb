require "rails_helper"

feature "Register new user", "
  In order to log in to ask questions and leave answers,
  As an unauthenticated user,
  I can register
" do
  given(:users) { create_list(:user, 5) }

  background do
    visit new_user_registration_path
  end

  scenario "Una11d user registers new account with unique email and confirmed password" do
    fill_in "Email", with: "unique@qna.com"
    fill_in "Password", with: "123456"
    fill_in "Password confirmation", with: "123456"
    click_button "Sign up"

    expect(page).to have_content "Welcome! You have signed up successfully."
  end

  scenario "Una11d user with existed email" do
    fill_in "Email", with: users[0].email
    fill_in "Password", with: users[0].password
    fill_in "Password confirmation", with: "123456"
    click_button "Sign up"

    expect(page).not_to have_content "Welcome! You have signed up successfully."
    expect(page).to have_content "Password confirmation"
  end
end
