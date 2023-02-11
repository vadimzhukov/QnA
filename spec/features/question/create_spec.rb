require "rails_helper"

feature "Create question", "
  In order to find help in community
  As unauthenticated user
  I can ask a question
" do

  given(:user) { create(:user) }
  background do
    login(user)
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
end


