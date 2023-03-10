require "rails_helper"

feature "Edit question", "
  In order to fix mistakes in question,
  As an author of the question,
  I can edit the question
" do

  given!(:user1) { create(:user) }
  given!(:user2) { create(:user) }
  
  given!(:question) { create(:question, user: user1) }

  scenario "A11d user tries to edit question of another author", js: true do
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

  describe "Author of question", js: true do
    background do
      login(user1)
      visit(questions_path)
    end
    scenario "inputs valid body" do

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

    scenario "inputs invalid body" do
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

    
    scenario "adds file" do
      
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

    scenario "deletes file" do
      
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
    
    scenario "adds valid link" do

      click_on "Edit"

      within "#links" do
        click_on "add link"
        fill_in "Name", with: "Link1"
        fill_in "Url", with: "http://google.com"
      end
      click_on "Save"

      expect(current_path).to eq questions_path

      within ".questions-list" do
        expect(page).to have_link "Link1", href: "http://google.com"
      end
    end

    scenario "adds invalid link" do

      click_on "Edit"

      within "#links" do
        click_on "add link"
        fill_in "Name", with: "Link1"
        fill_in "Url", with: "google"  
      end
      click_on "Save"

      expect(current_path).to eq questions_path

      within "#question-#{question.id}" do
        expect(page).to have_content "Links url is not a valid URL"
      end
    end

    scenario "deletes link" do

      click_on "Edit"

      within "#links" do
        click_on "add link"
        fill_in "Name", with: "Link1"
        fill_in "Url", with: "http://google.com"  
      end
      click_on "Save"

      within ".questions-list" do
        expect(page).to have_link "Link1", href: "http://google.com"
      end

      click_on "Edit"
      within "#links" do
        click_on "remove link"
      end
      click_on "Save"

      expect(current_path).to eq questions_path

      within ".questions-list" do
        expect(page).not_to have_link "Link1", href: "http://google.com"
      end
    end
  end
end