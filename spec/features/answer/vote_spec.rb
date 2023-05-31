require "rails_helper"

feature "Vote for answer", "
  In order to show that answer is good or bad
  As authenticated user
  I can vote for an answer
" do
  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users[0]) }
  given!(:answer1) { create(:answer, question:, user: users[0]) }
  given!(:answer2) { create(:answer, question:, user: users[1]) }

  describe "A11d user" do
    background do
      login(users[0])
      visit question_path(question)
    end

    scenario "user tries to vote for their answer", js: true do
      expect(page).not_to have_link(nil, href: "/answers/#{answer1.id}/like")
      expect(page).not_to have_link(nil, href: "/answers/#{answer1.id}/dislike")
      expect(page).not_to have_link(nil, href: "/answers/#{answer1.id}/reset_vote")
    end

    scenario "user set like to other users answer", js: true do
      votes_counter = find(id: "votes-count-#{answer2.id}")
      expect(votes_counter).to have_content("0")

      expect(page).to have_selector(:css, "a[href='/answers/#{answer2.id}/like']")
      expect(page).to have_selector(:css, "a[href='/answers/#{answer2.id}/dislike']")
      expect(page).not_to have_selector(:css, "a[href='/answers/#{answer2.id}/reset_vote']")

      find("a[href='/answers/#{answer2.id}/like']").click

      expect(votes_counter).to have_content("1")
      expect(page).to have_link(nil, href: "/answers/#{answer2.id}/reset_vote")
    end

    scenario "user resets liked answer", js: true do
      expect(page).to have_selector(:css, "a[href='/answers/#{answer2.id}/like']")

      votes_counter = find(id: "votes-count-#{answer2.id}")
      expect(votes_counter).to have_content("0")

      find("a[href='/answers/#{answer2.id}/like']").click

      expect(votes_counter).to have_content("1")

      expect(page).not_to have_selector(:css, "a[href='/answers/#{answer2.id}/like']")
      expect(page).not_to have_selector(:css, "a[href='/answers/#{answer2.id}/dislike']")
      expect(page).to have_selector(:css, "a[href='/answers/#{answer2.id}/reset_vote']")

      find("a[href='/answers/#{answer2.id}/reset_vote']").click

      expect(votes_counter).to have_content("0")

      expect(page).to have_selector(:css, "a[href='/answers/#{answer2.id}/like']")
      expect(page).to have_selector(:css, "a[href='/answers/#{answer2.id}/dislike']")
    end

    scenario "user resets disliked answer", js: true do
      votes_counter = find(id: "votes-count-#{answer2.id}")
      expect(votes_counter).to have_content("0")

      expect(page).to have_selector(:css, "a[href='/answers/#{answer2.id}/dislike']")

      find("a[href='/answers/#{answer2.id}/dislike']").click

      expect(votes_counter).to have_content("-1")

      expect(page).not_to have_selector(:css, "a[href='/answers/#{answer2.id}/like']")
      expect(page).not_to have_selector(:css, "a[href='/answers/#{answer2.id}/dislike']")
      expect(page).to have_selector(:css, "a[href='/answers/#{answer2.id}/reset_vote']")

      find("a[href='/answers/#{answer2.id}/reset_vote']").click

      expect(votes_counter).to have_content("0")

      expect(page).to have_selector(:css, "a[href='/answers/#{answer2.id}/like']")
      expect(page).to have_selector(:css, "a[href='/answers/#{answer2.id}/dislike']")
    end
  end
end
