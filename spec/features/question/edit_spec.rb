require "rails_helper"

feature "Edit question", "
  In order to fix mistakes in question,
  As an author of the question,
  I can edit the question
" do

  given!(:user1) { create(:user) }
  given!(:user2) { create(:user) }
  
  given!(:question) { create(:question, user: user1) }

  scenario "Try to edit question of another author", js: true do
    login(user2)
    visit(questions_path)

    within ".questions-list" do
      expect(page).not_to have_content "Edit"
    end
  end

  scenario "Und11d user tries to edit question", js: true do
    visit(questions_path)

    within ".questions-list" do
      expect(page).not_to have_content "Edit"
    end
  end

  describe "Author of question logged in", js: true do
    background do
      login(user1)
      visit(questions_path)
    end
    scenario "Edit question of the user with valid body" do

      click_on "Edit"

      within ".questions-list" do
        expect(page).not_to have_content "Edit"
        fill_in "question_body", with: "Corrected question text"
        click_on "Save"
      end

      expect(current_path).to eq questions_path

      within ".questions-list" do
        expect(page).to have_content "Corrected question text"
        expect(page).to have_content "Edit"
        expect(page).not_to have_selector "textarea"
      end
    end

    scenario "Try to edit question of the user with invalid body" do
      click_on "Edit"

      within ".questions-list" do
        expect(page).not_to have_content "Edit"
        fill_in "question_body", with: ""
        click_on "Save"
      end

      expect(current_path).to eq questions_path

      within ".questions-list" do
        expect(page).to have_content question.body
        
        expect(page).to have_content "Body can't be blank"
        page.has_button? "Save"
      end

    end

    
    scenario "Edit question of the user with adding files" do
      
      click_on "Edit"

      within "#question-#{question.id}" do
        attach_file ["#{Rails.root}/spec/spec_helper.rb"]
        
        click_on "Save"
      end

      expect(current_path).to eq questions_path

      within "#question-#{question.id}" do
        expect(page).to have_content "Edit"
        expect(page).not_to have_selector "textarea"
        expect(page).to have_link "spec_helper.rb"
      end
    end

    scenario "Delete file while edit question of the user" do
      
      click_on "Edit"

      within "#question-#{question.id}" do
        attach_file ["#{Rails.root}/spec/rails_helper.rb"] 
        
        click_on "Save"
      end

      within "#question-#{question.id}" do
        click_button "Delete file" 
      end

      expect(current_path).to eq questions_path

      within "#question-#{question.id}" do
        expect(page).not_to have_link "rails_helper.rb"
      end
    end
  end
end