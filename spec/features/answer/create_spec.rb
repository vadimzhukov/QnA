require "rails_helper"

feature "create answer on question page", "
  In order to help author of question,
  As an unauthenticated user,
  I can create answer on question page
" do

  given(:question) { create(:question) }

  scenario "create answer with valid body" do
    visit question_path(question)
    fill_in "answer_body", with: "Test answer body"
    click_on "Submit answer"

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content "Test answer body"
  end

  scenario "create answer with invalid empty body" do
    visit question_path(question)
    click_on "Submit answer"

    expect(page).to have_content "Answer was not saved"
  end
end