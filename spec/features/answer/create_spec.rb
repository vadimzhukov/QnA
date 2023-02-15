require "rails_helper"

feature "create answer on question page", "
  In order to help author of question,
  As an unauthenticated user,
  I can create answer on question page
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    login(user)
    visit question_path(question)
  end

  scenario "create answer with valid body" do
    fill_in "answer_body", with: "Test answer body"
    click_on "Submit answer"

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content "Test answer body"
  end

  scenario "create answer with invalid empty body" do
    click_on "Submit answer"

    expect(page).to have_content "Answer was not saved"
  end
end
