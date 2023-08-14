require 'sphinx_helper'

feature 'User can search for question', "
  In order to find needed question
  As a User
  I'd like to be able to search for the question
" do

  let!(:questions) { create_list(:question, 3) } 

  scenario 'User searches for the question', sphinx: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      expect(Question.search "1 Title").to be_a Question
    end
  end
end