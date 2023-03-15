require "rails_helper"

feature "A11d user rates answer", "
  in order to show best answer on my question,
  as author of question,
  I can rate any answer as best
" do
  given!(:user1) { create(:user) }
  given!(:user2) { create(:user) }
  given(:reward) { create(:reward) }
  given!(:question) { create(:question, user: user1, reward:) }
  given!(:answers) { create_list(:answer, 5, user: user2, question:) }

  scenario "Author of question rates answer as best" do
    login(user1)
    visit question_path(question)

    within ".answers-list" do
      click_on "Mark as best", id: "best-answer-btn-#{answers[2].id}"
    end

    within ".best-answer" do
      expect(page).to have_content answers[2].body
    end
  end

  given!(:user2) { create(:user) }

  scenario "Non author of question tries to rate answer as best" do
    login(user2)
    visit question_path(question)

    page.has_no_button? "Mark as best"
  end

  scenario "Una11d user tries to rate answer as best" do
    visit question_path(question)

    page.has_no_button? "Mark as best"
  end
end

feature "User see best answer", "
  in order to see the solution of question,
  as user,
  I can see the best answer
" do
  given!(:user1) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user1) }
  given!(:answers) { create_list(:answer, 5, user: user2, question:) }

  background do
    login(user1)
    visit question_path(question)
    click_on "Mark as best", id: "best-answer-btn-#{answers[2].id}"
  end

  scenario "Author of question see best answer" do
    within ".best-answer" do
      expect(page).to have_content answers[2].body
    end
  end

  scenario "Non-author of question see best answer" do
    within ".best-answer" do
      expect(page).to have_content answers[2].body
    end
  end

  scenario "Una11d user see best answer" do
    within ".best-answer" do
      expect(page).to have_content answers[2].body
    end
  end
end
