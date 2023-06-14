require "rails_helper"

feature "Create question", "
  In order to find help in community
  As unauthenticated user
  I can ask a question
" do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }

  describe "A11d user" do
    background do
      login(user)
      visit questions_path
    end

    scenario "user asks question with correct body", js: true do
      click_on "Ask question"

      fill_in id: "question_title", with: "Test question title"

      fill_in id: "question_body", with: "Test question body"
      click_on "Ask question"

      expect(page).to have_content "Test question title"
      expect(page).to have_content "Test question body"
    end

    scenario "user asks question with invalid empty body", js: true do
      click_on "Ask question"

      fill_in id: "question_title", with: "Test question title"

      click_on "Ask"

      expect(page).to have_content "Body can't be blank"
    end

    scenario "User creates question with files", js: true do
      click_on "Ask question"

      fill_in id: "question_title", with: "Test question title"
      fill_in id: "question_body", with: "Test question body"

      attach_file "Files", ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on "Ask"

      expect(page).to have_content "Test question title"
      expect(page).to have_content "Test question body"
      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end

    scenario "User creates question with valid link", js: true do
      click_on "Ask question"

      fill_in id: "question_title", with: "Test question title"
      fill_in id: "question_body", with: "Test question body"

      within "#links" do
        fill_in "Name", with: "yandex"
        fill_in "Url", with: "http://yandex.ru"
      end

      click_on "Ask"

      within ".question-links" do
        expect(page).to have_link "yandex", href: "http://yandex.ru"
      end
    end

    scenario "User creates question with reward", js: true do
      click_on "Ask question"

      fill_in id: "question_title", with: "Test question title"
      fill_in id: "question_body", with: "Test question body"

      within "#reward" do
        fill_in id: "question_reward_attributes_name", with: "Medal"
        find(id: "question_reward_attributes_image").attach_file("#{Rails.root}/spec/rails_helper.rb")
      end

      click_on "Ask"

      expect(page).to have_content "The question was succesfully saved"
    end
  end

  context "Una11d user" do
    scenario "user tries to add question" do
      visit questions_path

      expect(page).not_to have_link "Add question"
    end
  end

  context "WebSocket broadcast in other session" do
    scenario "User creates question, another user and guest see it appeared without page refresh", js: true do
      Capybara.using_session("user") do
        login(user)
        visit questions_path
      end

      Capybara.using_session("user2") do
        login(user2)
        visit questions_path
      end

      Capybara.using_session("guest") do
        visit questions_path
      end

      Capybara.using_session("user") do
        click_on "Ask question"

        fill_in id: "question_title", with: "Test question title"

        fill_in id: "question_body", with: "Test question body"
        click_on "Ask question"

        expect(page).to have_content "Test question title"
        expect(page).to have_content "Test question body"
      end

      Capybara.using_session("user2") do
        expect(page).to have_content "Test question title"
        expect(page).to have_content "Test question body"
        expect(page).to have_content "Rating"
        expect(page).to have_css "i.bi-hand-thumbs-up"
        expect(page).to have_css "i.bi-hand-thumbs-down"
      end

      Capybara.using_session("guest") do
        expect(page).to have_content "Test question title"
        expect(page).to have_content "Test question body"
      end
    end
  end

end
