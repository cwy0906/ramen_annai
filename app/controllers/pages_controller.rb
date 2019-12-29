class PagesController < ApplicationController

    def index
    end
    
    def select_user_type           
    end





    def new_comment
        @user_id  = params["user_id"]
        @store_id = params["store_id"]
    end

    def create_comment
    end

    def edit_comment
    end

    def update_comment
    end

    def user_list_comments
    end

end
