require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  use_doorkeeper
  root to: "questions#index"

  concern :votable do
    member do
      patch :like
      patch :dislike
      patch :reset_vote
    end
  end

  concern :commentable do
    member do
      patch :add_comment
      delete :delete_comment
    end
  end

  concern :file_deletable do
    member do
      patch :delete_file
    end
  end

  concern :subscriptable do
    member do
      patch :add_subscription
      delete :delete_subscription
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  resources :email_registrations do
    get :confirm, on: :member
  end

  resources :users

  resources :questions, concerns: [:votable, :file_deletable, :commentable, :subscriptable] do
    resources :answers, shallow: true, only: %i[new create edit update destroy],
                        concerns: [:votable, :file_deletable, :commentable] do
      patch :mark_as_best, on: :member
    end
  end
  resources :rewards, only: %i[index]

  mount ActionCable.server => "/cable"
  
  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
        get :others, on: :collection
      end

      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :answers, only: [:index, :show, :create, :update, :destroy], shallow: true
      end
    end
  end

  get '/search', to: 'search#find'
end
