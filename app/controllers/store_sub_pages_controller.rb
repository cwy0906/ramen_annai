class StoreSubPagesController < ApplicationController
   
    def show_gmap
        address    = params["address"]
        @latitude  = Geocoder.search(address).first.coordinates[0].to_s
        @longitude = Geocoder.search(address).first.coordinates[1].to_s
    end    
        
    def show_comments
        store_id  = params["store_id"]   
        store     = Store.find_by(id:store_id) 
        @comments = store.comments.order(updated_at: :desc)    
    end    

    def show_menu
    end    

    def show_album
    end    

end