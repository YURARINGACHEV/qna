Rails.application.routes.draw do
  devise_for :users, path: :qna, path_names: { sign_in: :login, sign_out: :logout }
  root to: 'questions#index'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      delete :unvote
    end
  end


  resources :questions, concerns: :votable do 
    resources :answers, concerns: :votable, shallow: true, only: [:create, :update, :destroy] do
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
