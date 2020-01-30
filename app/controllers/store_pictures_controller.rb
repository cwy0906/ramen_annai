class StorePicturesController < ApplicationController
    before_action :authenticate_user!, except: [:show]

    def edit
        @store     = current_user.store    
    end

    def update
        respond_to do |format|
            @store = current_user.store
            if @store.store_images.attach(update_store_pictures_params[:store_images])
              format.html { redirect_to update_store_pictures_path(store_id:@store.id) }
              format.json {
                # 遵循慣例參數為陣列，但 DirectUpload 一次只會負責一張圖片
                image = ActiveStorage::Blob.find_signed(update_store_pictures_params[:store_images].first)
                # 從後端取的圖片（resize）的網址
                image_url = Rails.application.routes.url_helpers.rails_representation_url(image.variant(resize: "200x200"), only_path: true)
                render json: { status: :ok, url: image_url, id: image.id, file_name: image.filename, file_size: image.byte_size }
              }
            else
              format.html { redirect_to update_store_pictures_path(store_id:@store.id) }
              format.json { render json: @store.errors, status: :unprocessable_entity }
            end
        end    
    end
    
    def destroy
        image_id = params[:id].to_i
        @store = current_user.store
        # 有時有無法刪除的問題    
        # @store.store_images.find_by(id:image_id).purge
        ActiveStorage::Attachment.find(image_id).purge
        render json: { status: :ok }    
    end    
    
    def show
        respond_to do |format|
            image_id  = params[:id]
            store_id  = params[:store_id]
            image     = Store.find(store_id).store_images.find(image_id)       
            image_url = rails_blob_url(image)
            format.json { render json: {image_url: image_url, status: :ok} }
            end    
    end    


    private
    def update_store_pictures_params
        params.require(:store).permit( store_images: [])
    end 

end    