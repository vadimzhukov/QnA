require "rails_helper"

feature "User can log out to end up session", "
  In order to close my current session,
  As authenticated user,
  I can log out
" do
  given(:user) { create(:user) }

  describe "Authenticated user" do
    background do
      login(user)
      visit questions_path
    end

    scenario "logs out" do
      click_button "Log out"

      expect(page).to have_content "Log in"
      expect(page).to have_content "Email"
      expect(page).to have_content "Password"
      expect(page).to have_content "Forgot your password?"
    end
  end

  scenario "Unathenticated user can not Log out" do
    visit questions_path
    expect(page).not_to have_content "Log out"
  end
end
