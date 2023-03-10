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

    scenario "User creates question with files" do
      click_on "Ask question"

      fill_in "Title", with: "Test question title"
      fill_in "Body", with: "Test question body"

      attach_file ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on "Ask"

      expect(page).to have_content "Test question title"
      expect(page).to have_content "Test question body"
      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end

    scenario "User creates question with valid link" do
      click_on "Ask question"

      fill_in "Title", with: "Test question title"
      fill_in "Body", with: "Test question body"

      within "#links" do
        fill_in "Name", with: "yandex"
        fill_in "Url", with: "http://yandex.ru"
      end

      click_on "Ask"

      within ".question-links" do
        expect(page).to have_link "yandex", href: "http://yandex.ru"
      end
    end

  end

  context "Una11d user" do

    scenario "user tries to add question" do
      visit questions_path

      expect(page).not_to have_link "Add question"
    end
  end

end
