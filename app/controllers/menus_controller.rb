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

        edit_store           = current_user.store
        former_menus         = Menu.where(store_id:current_user.store.id).order(:position)
        former_menus_count   = former_menus.count
          
        array_of_next_menus  = Array.new()            
        params[:store][:menus_attributes].each do |k,v|  
            item_name    = v["item_name"]
            item_price   = v["item_price"]
            item_destroy = v["_destroy"]
            if item_name.present? && item_price.present? && item_destroy == "false"
                menu_temp = {item_name:item_name, item_price:item_price, not_new:false}
                array_of_next_menus.push(menu_temp) 
            end        
        end
        next_menus_count   = array_of_next_menus.count

        
        if !former_menus.present?
            array_of_next_menus.each do |next_menu|
                next_menu_item  = next_menu[:item_name]
                next_menu_price = next_menu[:item_price]
                Menu.create(store_id:current_user.store.id, item_name: next_menu_item, item_price: next_menu_price)
            end 
        else
        
            if former_menus_count <= next_menus_count
                former_menus.each_with_index do |former_menu, index|
                    next_menu_item  = array_of_next_menus[index][:item_name]
                    next_menu_price = array_of_next_menus[index][:item_price]
                    former_menu.update(item_name: next_menu_item, item_price: next_menu_price)
                end  
                
                if former_menus_count < next_menus_count
                    former_menus_count.upto(next_menus_count-1) do |i|
                        next_menu_item  = array_of_next_menus[i][:item_name]
                        next_menu_price = array_of_next_menus[i][:item_price]
                        Menu.create(store_id:current_user.store.id, item_name: next_menu_item, item_price: next_menu_price)
                    end                
                end    
    
            else
                former_menus.each_with_index do |former_menu, index|
                    if index < next_menus_count
                        next_menu_item  = array_of_next_menus[index][:item_name]
                        next_menu_price = array_of_next_menus[index][:item_price]
                        former_menu.update(item_name: next_menu_item, item_price: next_menu_price, position:index+1)
                    else
                        former_menu.delete        
                    end    
                end                
            end     

        end    

        flash[:notice]  = "菜單內容編輯成功"
        redirect_to "/"

    end

end    