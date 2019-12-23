class StoresController < ApplicationController
    before_action :authenticate_user!

    def new
        @store = Store.new(users_id:current_user.id)
    end
    
    def edit
    end
    
    def index
    end    


end
