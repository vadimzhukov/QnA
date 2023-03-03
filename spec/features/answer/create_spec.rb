require "rails_helper"

feature "create answer on question page", "
  In order to help author of question,
  As an unauthenticated user,
  I can create answer on question page
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  background do
    login(user)
    visit question_path(question)
  end

  scenario "create answer with valid body", js: true do
    fill_in "answer_body", with: "Test answer body"
    click_on "Submit answer"

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each { |a| expect(page).to have_content a.body }

    within ".answers-list" do  
      expect(page).to have_content "Test answer body"
    end
  end

  scenario "create answer with invalid empty body", js: true do
    click_on "Submit answer"

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    within ".answer-errors" do
      expect(page).to have_content "Body can't be blank"
    end
  end
end
