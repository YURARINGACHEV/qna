Rails.application.routes.draw do
  devise_for :users, path: :qna, path_names: { sign_in: :login, sign_out: :logout }
  root to: 'questions#index'

  resources :questions do 
    resources :answers, shallow: true, only: [:create, :update, :destroy] do
      member do 
        post :mark_as_best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

end
