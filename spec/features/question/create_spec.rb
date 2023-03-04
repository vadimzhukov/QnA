require "rails_helper"

feature "Create question", "
  In order to find help in community
  As unauthenticated user
  I can ask a question
" do
  given(:user) { create(:user) }

  describe "A11d user" do

    background do
      login(user)
      visit questions_path
    end

    scenario "user asks question with correct body" do
      click_on "Ask question"

      fill_in "Title", with: "Test question title"
      fill_in "Body", with: "Test question body"
      click_on "Ask"

      expect(page).to have_content "Test question title"
      expect(page).to have_content "Test question body"
    end

    scenario "user asks question with invalid empty body" do
      click_on "Ask question"

      fill_in "question_title", with: "Test question title"

      click_on "Ask"

      expect(page).to have_content "Error in question"
    end

    scenario "User creates question with file" do
      click_on "Ask question"

      fill_in "Title", with: "Test question title"
      fill_in "Body", with: "Test question body"

      attach_file "File", "#{Rails.root}/spec/rails_helper.rb"

      click_on "Ask"

      expect(page).to have_content "Test question title"
      expect(page).to have_content "Test question body"
      expect(page).to have_link "rails_helper.rb"
    end
  end

  context "Una11d user" do

    scenario "user tries to add question" do
      visit questions_path

      expect(page).not_to have_link "Add question"
    end
  end

end
