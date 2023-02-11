require "rails_helper"

feature "Create question", "
  In order to find help in community
  As unauthenticated user
  I can ask a question
" do
  scenario "user asks question with correct body" do
    visit "/questions"
    click_on "Ask question"

    fill_in "question_title", with: "Test question title"
    fill_in "question_body", with: "Test question body"
    click_on "Ask"

    expect(page).to have_content "Test question title"
    expect(page).to have_content "Test question body"
  end
  scenario "user asks question with invalid empty body" do
    visit "/questions"
    click_on "Ask question"

    fill_in "question_title", with: "Test question title"

    click_on "Ask"

    expect(page).to have_content "Error in question"
  end
end


