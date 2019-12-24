Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'        
  }

  resources :users do
    resources :stores, only: [:index, :new, :create, :edit, :update]   
  end  

  root 'pages#index'
  get "/user_type/sign_up", to: "pages#select_user_type"
  get "/stimulus_demo",     to: "pages#stimulus_demo"
  get "/show_gmap",         to: "pages#show_gmap"
  
end
