class StoreSubPagesController < ApplicationController
   
    def show_gmap
        address    = params["address"]
        @latitude  = Geocoder.search(address).first.coordinates[0].to_s
        @longitude = Geocoder.search(address).first.coordinates[1].to_s
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
        if Menu.find_by(store_id:store_id ).present?
            menuArray    = Menu.find_by(store_id:store_id).content.split("?")
            @menu_exist = true
            @dish_01     = menuArray[0]
            @dish_02     = menuArray[2]
            @dish_03     = menuArray[4]
            @dish_04     = menuArray[6]
            @dish_05     = menuArray[8]
            @price_01    = menuArray[1]
            @price_02    = menuArray[3]
            @price_03    = menuArray[5]
            @price_04    = menuArray[7]
            @price_05    = menuArray[9]
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