require "rails_helper"

feature "Edit answer", "
  In order to fix mistakes in answer,
  As an author of the answer,
  I can edit the answer
" do

  given!(:user1) { create(:user) }
  given!(:user2) { create(:user) }
  
  given!(:question) { create(:question) }
  
  given!(:answer) { create(:answer, user: user1, question: question) }

  scenario "A11d user tries to edit answer of another author", js: true do
    login(user2)
    visit(question_path(question))

    within ".answers-list" do
      expect(page).not_to have_content "Edit"
    end
  end

  scenario "Und11d user tries to edit answer", js: true do
    visit(question_path(question))

    within ".answers-list" do
      expect(page).not_to have_content "Edit"
    end
  end

  describe "Author of the answer", js: true do
    background do
      login(user1)
      visit(question_path(question))
    end
    scenario "inputs valid body" do
      
      click_on "Edit"

      within ".answers-list" do
        expect(page).not_to have_content "Edit"
        fill_in "answer_body", with: "Corrected answer text"
        click_on "Save"
      end

      expect(current_path).to eq question_path(question)

      within ".answers-list" do
        expect(page).to have_content "Corrected answer text"
        expect(page).to have_content "Edit"
        expect(page).not_to have_selector "textarea"
      end
    end

    scenario "inputs invalid body" do
      click_on "Edit"

      within ".answers-list" do
        expect(page).not_to have_content "Edit"
        fill_in "answer_body", with: ""
        click_on "Save"
      end

      expect(current_path).to eq question_path(question)

      within ".answers-list" do
        expect(page).to have_content answer.body
        
        expect(page).to have_content "Body can't be blank"
        page.has_button? "Save"
      end

    end

    
    scenario "adds file" do
      
      click_on "Edit"

      within "#answer-#{answer.id}" do
        attach_file ["#{Rails.root}/spec/spec_helper.rb"]
        
        click_on "Save"
      end

      expect(current_path).to eq question_path(question)

      within "#answer-#{answer.id}" do
        expect(page).to have_content "Edit"
        expect(page).not_to have_selector "textarea"
        expect(page).to have_link "spec_helper.rb"
      end
    end

    scenario "deletes file" do
      
      click_on "Edit"

      within "#answer-#{answer.id}" do
        attach_file ["#{Rails.root}/spec/rails_helper.rb"] 
        
        click_on "Save"
      end

      within "#answer-#{answer.id}" do
        click_button "Delete file" 
      end

      expect(current_path).to eq question_path(question)

      within "#answer-#{answer.id}" do
        expect(page).not_to have_link "rails_helper.rb"
      end
    end

    scenario "adds valid link" do
      within "#answer-#{answer.id}" do
        click_on "Edit"

        within "#links" do
          click_on "add link"
          fill_in "Name", with: "Link1"
          fill_in "Url", with: "http://google.com"
        end
        click_on "Save"
      
        expect(page).to have_link "Link1", href: "http://google.com"
      end
    end

    scenario "adds invalid link" do
      within "#answer-#{answer.id}" do
        click_on "Edit"

        within "#links" do
          click_on "add link"
          fill_in "Name", with: "Link1"
          fill_in "Url", with: "google"  
        end
        click_on "Save"

        expect(page).to have_content "Links url is not a valid URL"
      end
    end

    scenario "deletes link" do
      within "#answer-#{answer.id}" do
        click_on "Edit"

        within "#links" do
          click_on "add link"
          fill_in "Name", with: "Link1"
          fill_in "Url", with: "http://google.com"  
        end
        click_on "Save"

        expect(page).to have_link "Link1", href: "http://google.com"

        click_on "Edit"
        within "#links" do
          click_on "remove link"
        end
        click_on "Save"

        expect(page).not_to have_link "Link1", href: "http://google.com"
      end
    end
    
  end
end