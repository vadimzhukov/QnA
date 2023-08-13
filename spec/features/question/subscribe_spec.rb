require "rails_helper"

feature "User subscribes to question updates", "
  In order to know of new answers to the question 
  user can subscribe to it to receive updates by email" do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }

  given!(:question) { create(:question, user: author) }

  scenario "A11d user subscribes to question" do
    login(user)
    visit question_path(question)

    click_on "Subscribe"

    within ".alert-success" do
      expect(page).to have_content "Вы успешно подписаны"
    end

    click_on "Unsubscribe"
    
    within ".alert-success" do
      expect(page).to have_content "Вы успешно отписались"
    end
  end

  scenario "Author of question is subscribed to question by default and can unsubscribes from it" do
    login(author)
    visit question_path(question)

    click_on "Unsubscribe"

    within ".alert-success" do
      expect(page).to have_content "Вы успешно отписались"
    end
  end
end
