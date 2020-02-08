class MenusController < ApplicationController

    def edit
        store_id = params[:store_id]
        if Menu.where(store: store_id).present?
            @menus_status = "revise"
        else
            @menus_status = "create"
        end
        @store        = current_user.store
    end    
    
    def update
        ActiveRecord::Base.transaction do
            edit_store = current_user.store 
            Menu.where(store_id:current_user.store.id).destroy_all

            params[:store][:menus_attributes].each do |k,v|  
                item_name    = v["item_name"]
                item_price   = v["item_price"]
                item_destroy = v["_destroy"]
                if item_name.present? && item_price.present? && item_destroy == "false"
                    Menu.create(store:edit_store, item_name:item_name, item_price:item_price)    
                end        
            end

            flash[:notice]  = "菜單內容編輯成功"
            redirect_to "/"
        end
    end  

end    