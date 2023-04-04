require "rails_helper"

feature "Vote for question", "
  In order to show that question is good or bad
  As authenticated user
  I can vote for a question
" do
  given(:users) { create_list(:user, 2) }
  given!(:question1) { create(:question, user: users[0]) }
  given!(:question2) { create(:question, user: users[1]) }

  describe "A11d user" do
    background do
      login(users[0])
      visit questions_path
    end

    scenario "user tries to vote for their question", js: true do
      expect(page).not_to have_link(nil, href: "/questions/#{question1.id}/like")
      expect(page).not_to have_link(nil, href: "/questions/#{question1.id}/dislike")
      expect(page).not_to have_link(nil, href: "/questions/#{question1.id}/reset_vote")
    end

    scenario "user set like to other users question", js: true do
      votes_counter = find(id: "votes-count-#{question2.id}")
      expect(votes_counter).to have_content("0")

      expect(page).to have_selector(:css, "a[href='/questions/#{question2.id}/like']")
      expect(page).to have_selector(:css, "a[href='/questions/#{question2.id}/dislike']")

      expect(page).not_to have_selector(:css, "a[href='/questions/#{question2.id}/reset_vote']")

      find("a[href='/questions/#{question2.id}/like']").click

      expect(votes_counter).to have_content("1")
      expect(page).to have_link(nil, href: "/questions/#{question2.id}/reset_vote")
    end

    scenario "user resets liked question", js: true do
      votes_counter = find(id: "votes-count-#{question2.id}")
      expect(votes_counter).to have_content("0")
      expect(page).to have_selector(:css, "a[href='/questions/#{question2.id}/like']")

      find("a[href='/questions/#{question2.id}/like']").click

      expect(votes_counter).to have_content("1")

      expect(page).not_to have_selector(:css, "a[href='/questions/#{question2.id}/like']")
      expect(page).not_to have_selector(:css, "a[href='/questions/#{question2.id}/dislike']")
      expect(page).to have_selector(:css, "a[href='/questions/#{question2.id}/reset_vote']")

      find("a[href='/questions/#{question2.id}/reset_vote']").click

      expect(votes_counter).to have_content("0")

      expect(page).to have_selector(:css, "a[href='/questions/#{question2.id}/like']")
      expect(page).to have_selector(:css, "a[href='/questions/#{question2.id}/dislike']")
    end

    scenario "user resets disliked question", js: true do
      votes_counter = find(id: "votes-count-#{question2.id}")
      expect(votes_counter).to have_content("0")

      expect(page).to have_selector(:css, "a[href='/questions/#{question2.id}/dislike']")

      find("a[href='/questions/#{question2.id}/dislike']").click

      expect(votes_counter).to have_content("-1")

      expect(page).not_to have_selector(:css, "a[href='/questions/#{question2.id}/like']")
      expect(page).not_to have_selector(:css, "a[href='/questions/#{question2.id}/dislike']")
      expect(page).to have_selector(:css, "a[href='/questions/#{question2.id}/reset_vote']")

      find("a[href='/questions/#{question2.id}/reset_vote']").click

      expect(votes_counter).to have_content("0")

      expect(page).to have_selector(:css, "a[href='/questions/#{question2.id}/like']")
      expect(page).to have_selector(:css, "a[href='/questions/#{question2.id}/dislike']")
    end
  end
end
