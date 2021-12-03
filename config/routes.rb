Rails.application.routes.draw do
  devise_for :users, path: :qna, path_names: { sign_in: :login, sign_out: :logout }
  root to: 'questions#index'

  resources :questions do 
    resources :answers, shallow: true, only: [:create, :update, :destroy]
  end
end
