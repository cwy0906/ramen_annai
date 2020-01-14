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
  get "/show_menu/:store_id",           to: "store_sub_pages#show_menu"
  get "/show_album/:store_id",          to: "store_sub_pages#show_album"

  get "/stores/:id",                    to: "pages#show_store",                  as: "show_store_page"
  get "/stores_error_show",             to: "pages#error_show"

  scope :controller => "pages", :path => "/comments", :as => "comment" do
    get "new/:store_id"     => :new_comment,       :as => "new"
    get "create/:store_id"  => :create_comment,    :as => "create"
    get "edit/:id"          => :edit_comment,      :as => "edit"
    get "update/:id"        => :update_comment,    :as => "update"
    get "user_list"         => :user_list_comments,:as => "by_user_list"
  end
  get "/comments/store_list/:store_id", to: "store_sub_pages#show_comments", as: "comment_by_store_list"

  get "/search_stores",                 to: "pages#search_stores",           as: "search_stores"  

  get "/edit_menu/:store_id",           to: "pages#edit_menu",               as: "edit_menu"
  get "/update_menu/:store_id",         to: "pages#update_menu",               as: "update_menu"

  get  "/edit_store_pictures/:store_id",                     to: "stores#edit_pictures",        as: "edit_store_pictures"
  post "/update_store_pictures/:store_id",                   to: "stores#update_pictures",      as: "update_store_pictures"
  get  "/delete_store_picture/:store_id/store_picture/:id",  to: "stores#delete_picture",       as: "delete_store_picture"
  post "/find_store_picture_url/:store_id/:id",                        to: "stores#find_picture_url"            
end
