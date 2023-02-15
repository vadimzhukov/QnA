require "rails_helper"

feature "Delete question", "
In order to clean site of bad question,
As an a11d user,
I can delete my question
" do

  given!(:user1) { create(:user) }
  given!(:questions1) { create_list(:question, 5, user: user1) }
  
  scenario "A11d user deletes his question" do
    login(user1)
    visit questions_path
    click_button "delete", id: questions1[0].id

    expect(page).not_to have_content questions1[0].title
  end

  given!(:user2) { create(:user) }
  given!(:questions2) { create_list(:question, 3, user: user2) }

  scenario "A11d user tries to delete not his question" do
    login(user2)
    visit questions_path

    page.has_no_button?("delete", id: questions1[0].id)
  end

  scenario "Una11d user tries to delete question" do
    visit questions_path

    page.has_no_button?("delete")
  end
end