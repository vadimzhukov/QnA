Rails.application.routes.draw do
  get "/rewards", to: "rewards#index"
  devise_for :users
  root to: "questions#index"
  resources :questions do
    patch :delete_file, on: :member
    resources :answers, shallow: true, only: %i[new create edit update destroy] do
      patch :mark_as_best, on: :member
      patch :delete_file, on: :member
    end
  end

end
