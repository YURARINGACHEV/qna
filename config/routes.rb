require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, 
             controllers: { omniauth_callbacks: 'oauth_callbacks', confirmations: 'confirmations'  }, 
             path: :qna, path_names: { sign_in: :login, sign_out: :logout }
              
  root to: 'questions#index'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      delete :unvote
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :create, :show, :update, :destroy] do 
        resources :answers, shallow: true, only: [:index, :create, :show, :update, :destroy]
      end
    end
  end

  resources :questions, concerns: :votable do 
    resources :subscriptions, only: [:create, :destroy], shallow: true
    resources :comments, only: :create
    resources :answers, concerns: :votable, shallow: true, only: [:create, :update, :destroy] do
      resources :comments, only: :create
      member do 
        post :mark_as_best
      end
    end
  end
  
  get  :search, to: 'search#index'
  
  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
