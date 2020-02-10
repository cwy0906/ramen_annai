class StoresController < ApplicationController
    before_action :authenticate_user!, except: [:show] 

    def new
        @store  = current_user.build_store
        @url    = user_stores_path(user_id:current_user.id)
        @method = :GET
    end
    
    def create
        @store = current_user.build_store(store_params)
        if @store.save
            user_session[:has_store?] = true 
            user_session.delete_if { |key,value| key == "form_error_message" }
            redirect_to "/", notice: "店面資料新增成功"
        else 
            user_session["form_error_message"] = blank_params_check(@store.errors.messages)                          
            render :new        
        end        
    end    

    def edit
        @store  = current_user.store
        @url    = user_store_path(user_id:current_user.id,id:current_user.store.id)
        @method = :PUT    
    end
    
    def update
        if @store = current_user.store.update(store_params)
            user_session.delete_if { |key,value| key == "form_error_message" }
            redirect_to "/", notice: "店面資料修改成功"    
        else
            user_session["form_error_message"] = blank_params_check(@store.errors.messages)                          
            render :edit
        end            
    end
    
    def show
        if Store.find_by(id: params[:id])
            @store     = Store.find_by(id: params[:id]) 
            @latitude  = Geocoder.search(@store.address).first.coordinates[0].to_s
            @longitude = Geocoder.search(@store.address).first.coordinates[1].to_s
        else
            redirect_to "/stores_error_show"
        end 
    end    

    def index
        @store     = current_user.store
        @latitude  = Geocoder.search(current_user.store.address).first.coordinates[0].to_s
        @longitude = Geocoder.search(current_user.store.address).first.coordinates[1].to_s
    end
        
    private
    def store_params
        params.require(:store).permit(:user_id, :tiltle, :city, :district, :title,
                                      :address, :tel, :promote, :intro, :feature,
                                      :opening_hours, :closed_day, :budget, :memo)    
    end    

    def blank_params_check(message_hash)    
        message_hash.keep_if {|key, value| value == ["can't be blank"] }.keys.to_s+"以上欄位不得為空白" 
    end    

end
