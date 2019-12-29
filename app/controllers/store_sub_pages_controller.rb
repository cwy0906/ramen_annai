class StoreSubPagesController < ApplicationController
   
    def show_gmap
        address    = params["address"]
        @latitude  = Geocoder.search(address).first.coordinates[0].to_s
        @longitude = Geocoder.search(address).first.coordinates[1].to_s
    end    
        
    def store_list_comments     
    end    

end