Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'users/registrations'       
  }

  resources :users do
    resources :stores, only: [:index, :new, :edit, :update]   
  end  

  root 'pages#index'
  get "/user_type/sign_up", to: "pages#select_user_type"
  



end
