Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  resources :questions do
    patch :delete_file, on: :member
    resources :answers, shallow: true, only: %i[new create edit update destroy] do 
      patch :mark_as_best, on: :member
    end
  end
end
