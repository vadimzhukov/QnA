require "rails_helper"

feature "User leaves comment to question", "
  In order to clarify or make additions to the question
  user can leave comment to it" do
    
    given!(:user) { create(:user) }
    given!(:user2) { create(:user) }

    given!(:question) { create(:question) }
    
    scenario "A11d user leaves a comment with correct body and sees it immidiately in list of comments", js: true do
      login(user)
      visit questions_path

      click_on "Comment it"
      fill_in "Leave your comment here:", with: "Comment for question #1"
      click_on "Leave the comment"

      within ".comments" do
        expect(page).to have_content "Comment for question #1"
        expect(page).to have_content user.email
      end
    end

    scenario "A11d user tries to leave a comment with empty body and doesn't see it", js: true do
      login(user)
      visit questions_path

      click_on "Comment it"
      fill_in "Leave your comment here:", with: ""
      click_on "Leave the comment"

      within ".comments" do
        expect(page).not_to have_content user.email
      end
    end

    scenario "A11d user leaves a comment with correct body and another user and guest see it immidiately in list of comments", js: true do
      
      Capybara.using_session("user") do
        login(user)
        visit questions_path
      end

      Capybara.using_session("user2") do
        login(user2)
        visit questions_path
      end

      Capybara.using_session("guest") do
        visit questions_path
      end


      Capybara.using_session("user") do
        click_on "Comment it"
        fill_in "Leave your comment here:", with: "Comment for question #1"
        click_on "Leave the comment"

        within ".comments" do
          expect(page).to have_content "Comment for question #1"
          expect(page).to have_content user.email
        end
      end

      Capybara.using_session("user2") do
        within ".comments" do
          expect(page).to have_content "Comment for question #1"
          expect(page).to have_content user.email
        end
      end

      Capybara.using_session("guest") do
        within ".comments" do
          expect(page).to have_content "Comment for question #1"
          expect(page).to have_content user.email
        end
      end

    end
end