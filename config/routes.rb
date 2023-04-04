Rails.application.routes.draw do
  concern :votable do
    member do
      patch :like
      patch :dislike
      patch :reset_vote
    end
  end

  concern :file_deletable do
    member do
      patch :delete_file
    end
  end

  devise_for :users
  root to: "questions#index"
  resources :questions, concerns: [:votable, :file_deletable] do
    resources :answers, shallow: true, only: %i[new create edit update destroy],
                        concerns: [:votable, :file_deletable] do
      patch :mark_as_best, on: :member
    end
  end
  resources :rewards, only: %i[index]
end
