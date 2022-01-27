Rails.application.routes.draw do
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
      resources :profiles, only: [] do
        get :me, on: :collection
      end
      resources :questions, only: [:index]
    end
  end

  resources :questions, concerns: :votable do 
    resources :comments, only: :create
    resources :answers, concerns: :votable, shallow: true, only: [:create, :update, :destroy] do
      resources :comments, only: :create
      member do 
        post :mark_as_best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
