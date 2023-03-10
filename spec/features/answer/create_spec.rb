require "rails_helper"

feature "create answer on question page", "
  In order to help author of question,
  As an unauthenticated user,
  I can create answer on question page
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  

  context "A11d user" do
    background do
      login(user)
      visit question_path(question)
    end

    scenario "creates answer with valid body", js: true do
      within ".new-answer" do
        fill_in "answer_body", with: "Test answer body"
        click_on "Submit answer"
      end

      
      expect(page).to have_content question.title
      expect(page).to have_content question.body

      within ".answers-list" do
        answers.each { |a| expect(page).to have_content a.body }
      end

      within ".answers-list" do  
        expect(page).to have_content "Test answer body"
      end
    end

    scenario "creates answer with invalid empty body", js: true do
      within ".new-answer" do
        click_on "Submit answer"
      end

      expect(page).to have_content question.title
      expect(page).to have_content question.body

      within ".answer-errors" do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "creates answer with attached files", js: true do
      within ".new-answer" do  
        fill_in "answer_body", with: "Test answer body"
        attach_file "File", ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on "Submit answer"
      end

      within ".answers-list" do  
        expect(page).to have_content "Test answer body"
        expect(page).to have_link "rails_helper.rb"
        expect(page).to have_link "spec_helper.rb"
      end   
    end

    scenario "creates answer with correct link", js: true do
      within ".new-answer" do  
        fill_in "answer_body", with: "Test answer body"
        fill_in "Name", with: "Link1"
        fill_in "Url", with: "http://google.com"
        click_on "Submit answer"
      end

      within ".answers-list" do  
        expect(page).to have_content "Test answer body"
        expect(page).to have_link "Link1", href: "http://google.com"
      end   
    end

    scenario "creates answer with invalid link", js: true do
      within ".new-answer" do  
        fill_in "answer_body", with: "Test answer body"
        fill_in "Name", with: "Link1"
        fill_in "Url", with: "google"
        click_on "Submit answer"
      end

      within ".answers-list" do  
        expect(page).not_to have_content "Test answer body"
        expect(page).not_to have_link "Link1", href: "http://google.com"
      end
      within ".answer-errors" do 
        expect(page).to have_content "Links url is not a valid URL"
      end   
    end
  end

  context "Una11d user" do
    scenario "Can not create answer", js: true do
      visit question_path(question)

      expect(page).not_to have_content "New answer"
      expect(page).not_to have_button "Submit answer"
    end

  end
end
