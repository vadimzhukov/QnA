require 'sphinx2_helper'

feature 'User can search for question', "
  In order to find needed question
  As a User
  I'd like to be able to search for the question
" do

  let!(:questions) { create_list(:question, 3) }
  # ThinkingSphinx::Test.config
  # ThinkingSphinx::Test.start

  # ThinkingSphinx::Test.index
  scenario 'User searches for the question', sphinx: true, js: true do
    visit questions_path

    fill_in id: "search_query", with: "Test"
    click_on "Search"
    expect(page).to have_content questions[0].title

  end
end