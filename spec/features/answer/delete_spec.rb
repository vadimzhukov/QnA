require "rails_helper"

feature "Delete answer", "
In order to clean site of bad answer,
As an a11d user,
I can delete my answer
" do
  given!(:user1) { create(:user) }
  given!(:question) { create(:question, user: user1) }
  given!(:answers1) { create_list(:answer, 5, user: user1, question:) }

  scenario "A11d user deletes his answer", js: true do
    login(user1)
    visit question_path(question)

    within "#answer-#{answers1[0].id}" do
      click_button "Delete answer"
    end

    within ".answers-list" do
      expect(page).not_to have_content answers1[0].body
    end
  end

  given!(:user2) { create(:user) }
  given!(:answers2) { create_list(:answer, 3, user: user2, question:) }

  scenario "A11d user tries to delete not his answer", js: true do
    login(user2)
    visit question_path(question)

    within "#answer-#{answers1[0].id}" do
      page.has_no_button? "Delete answer"
    end
  end

  scenario "Una11d user tries to delete question" do
    visit questions_path

    page.has_no_button? "Delete question"
  end
end
