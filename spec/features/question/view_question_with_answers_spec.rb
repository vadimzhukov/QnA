require "rails_helper"

feature "show question with answers", "
  In order to find solution for existed question,
  As an unauthenticated user,
  I can see page of question and its answers
" do
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, { question_id: question.id }) }

  scenario "Look at the question page with answers listed under" do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each { |a| expect(page).to have_content a.body }
  end
end
