require "rails_helper"

feature "See a list of questions", "
  In order to search for my problem already solved,
  As unathenticated user,
  I can see a list of existed questions
" do
  given!(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5) }

  scenario "user goes on question page to see the list of all questions" do
    login(user)
    visit questions_path
    questions.each { |q| expect(page).to have_content q.title }
  end
end
