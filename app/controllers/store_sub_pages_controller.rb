class StoreSubPagesController < ApplicationController
   
    def show_gmap
        @full_address    = params["full_address"]
        @latitude        = Geocoder.search(@full_address).first.coordinates[0].to_s
        @longitude       = Geocoder.search(@full_address).first.coordinates[1].to_s
    end    
        
    def show_comments
        store_id  = params["store_id"]
        store     = Store.find_by(id:store_id)
        if store.comments.present? 
            @comments_exist = true
            @comments = store.comments.order(updated_at: :desc)
        else
            @comments_exist = false
        end        
    end    

    def show_menu
        store_id = params["store_id"]
        if Menu.where(store_id:store_id ).present?
            @menu_exist = true
            @menus      = Menu.where(store_id:store_id )
        else
            @menu_exist = false
        end 
    end    

    def show_album
        store_id     = params["store_id"]
        store        = Store.find_by(id:store_id)        
        if store.store_images.present? 
            @store_images_exist = true
            @store_id           = store.id
            @store_images       = store.store_images
        else
            @store_images_exist = false
        end
    end    

end