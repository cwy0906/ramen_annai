class StoresController < ApplicationController
    before_action :authenticate_user! 

    def new
        @store  = current_user.build_store
        @url    = user_stores_path(user_id:current_user.id)
        @method = :post
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

    def index
        @store     = current_user.store
        @latitude  = Geocoder.search(current_user.store.address).first.coordinates[0].to_s
        @longitude = Geocoder.search(current_user.store.address).first.coordinates[1].to_s
    end
   
    def edit_pictures
        @store     = current_user.store
    end
    
    def update_pictures  
        respond_to do |format|
            @store = current_user.store
            if @store.store_images.attach(update_store_pictures_params[:store_images])
              format.html { redirect_to update_store_pictures_path(store_id:@store.id) }
              format.json {
                # 遵循慣例參數為陣列，但 DirectUpload 一次只會負責一張圖片
                image = ActiveStorage::Blob.find_signed(update_store_pictures_params[:store_images].first)
                # 從後端取的圖片（resize）的網址
                image_url = Rails.application.routes.url_helpers.rails_representation_url(image.variant(resize: "200x200"), only_path: true)
                render json: { status: :ok, url: image_url, id: image.id }
              }
            else
              format.html { redirect_to update_store_pictures_path(store_id:@store.id) }
              format.json { render json: @store.errors, status: :unprocessable_entity }
            end
        end        
    end   
    
    def delete_picture
        image_id = params[:id].to_i
        @store = current_user.store
        # 有時有無法刪除的問題    
        # @store.store_images.find_by(id:image_id).purge
        ActiveStorage::Attachment.find(image_id).purge
        render json: { status: :ok }                  
    end 
    
    def find_picture_url
        respond_to do |format|
        image_id  = params[:id]
        store_id  = params[:store_id]
        image     = Store.find(store_id).store_images.find(image_id)       
        image_url = rails_blob_url(image)
        format.json { render json: {image_url: image_url, status: :ok} }
        end          
    end 

    private
    def store_params
        params.require(:store).permit(:user_id, :tiltle, :city, :district, :title,
                                      :address, :tel, :promote, :intro, :feature,
                                      :opening_hours, :closed_day, :budget, :memo)    
    end    

    def update_store_pictures_params
        params.require(:store).permit( store_images: [])
    end    

    def blank_params_check(message_hash)    
        message_hash.keep_if {|key, value| value == ["can't be blank"] }.keys.to_s+"以上欄位不得為空白" 
    end    

end
