Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'        
  }

  resources :users do
    resources :stores, only: [:index, :new, :create, :edit, :update]   
  end  

  root 'pages#index'
  get "/user_type/sign_up",             to: "pages#select_user_type"

  get "/show_gmap",                     to: "store_sub_pages#show_gmap"
  





  get "/stores/:id",                    to: "stores#show"
  get "/stores_error_show",             to: "stores#error_show"

  scope :controller => "pages", :path => "/comments", :as => "comment" do
    get "new/:user_id/:store_id"     => :new_comment,       :as => "new"
    get "create/:user_id/:store_id"  => :create_comment,    :as => "create"
    get "edit/:id"                   => :edit_comment,      :as => "edit"
    get "update/:id"                 => :update_comment,    :as => "update"
    get "user_list/:user_id"         => :user_list_comments,:as => "user_list"
  end
  get "/comments/store_list/:store_id", to: "store_sub_pages#store_list_comments"



end
