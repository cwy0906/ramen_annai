class PagesController < ApplicationController

    def index
    end
    
    def select_user_type           
    end

    def stimulus_demo
    end    

    def show_gmap
        address    = params["address"]
        @latitude  = Geocoder.search(address).first.coordinates[0].to_s
        @longitude = Geocoder.search(address).first.coordinates[1].to_s
    end    
        
end
