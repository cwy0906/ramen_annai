Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'        
  }

  resources :users do
    resources :stores, only: [:index, :new, :create, :edit, :update]   
  end  
   
  get "/search_stores",          to: "pages#search_stores",           as: "search_stores"
  get "/stores_error_show",      to: "pages#error_show"
  get "/user_type/sign_up",      to: "pages#select_user_type"
  root "pages#index"

  resources :stores do
    resources :store_sub_pages do
      collection do
        get :show_gmap
        get :show_menu
        get :show_album
        get :show_comments       
      end 
    end
    
    resources  :store_pictures, only: [:destroy, :show] do
      collection do
        get  :edit
        post :update
      end
    end

    resource :menus, only: [:edit, :update]

  end

  scope :controller => "pages", :path => "/comments", :as => "comment" do
    get "new/:store_id"     => :new_comment,       :as => "new"
    get "create/:store_id"  => :create_comment,    :as => "create"
    get "user_list"         => :user_list_comments,:as => "by_user_list"
  end
              
end
