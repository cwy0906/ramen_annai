class PagesController < ApplicationController

    def index
    end
    
    def select_user_type           
    end

    def new_comment
        if Store.find_by(id:params["store_id"])    
            @user_id  = current_user.id
            @store    = Store.find_by(id:params["store_id"])
            @comment  = current_user.comments.build
        else
            redirect_to "/stores_error_show"
        end        
    end

    def create_comment
        commented_store_id = params.require(:comment)["store_id"]
        if is_self_comment?(current_user,commented_store_id)
            redirect_to "/", alert: '無法自評自家餐廳評價喔!'
        else
            if Comment.find_by( user_id:current_user.id, store_id:commented_store_id ).present? 
                until_comment_count = Comment.where( user_id:current_user.id, store_id:commented_store_id ).count
            else 
                until_comment_count = 0
            end    

            params.require(:comment)["visit_count"] = until_comment_count + 1; 
            params.require(:comment)["user_id"]     = current_user.id
            @user_id  = current_user.id
            @store    = Store.find_by(id:commented_store_id)
            @comment = Comment.new(comment_params)

            if @comment.save
                user_session.delete_if { |key,value| key == "form_error_message" }
                update_store_related_comment(@store)
                update_user_related_comment(current_user)
                redirect_to "/", notice: "評論資料新增成功"
            else
                user_session["form_error_message"] = blank_params_check(@comment.errors.messages)                          
                render :new_comment
            end        
        end    
    end

    def edit_comment
    end

    def update_comment
    end

    def user_list_comments
        @comments = current_user.comments.order(updated_at: :desc)
    end

    def search_stores
        params                    = key_word_params
        geo_keyword               = params["geo_keyword"].nil?                ?            "" : params["geo_keyword"].strip
        feat_keyword              = params["feat_keyword"].nil?               ?            "" : params["feat_keyword"].strip
        order_keyword             = params["order_keyword"].nil?              ?   "avg_score" : params["order_keyword"].strip
        filter_price_from_keyword = params["filter_price_from_keyword"].nil?  ?             1 : params["filter_price_from_keyword"].to_i
        filter_price_to_keyword   = params["filter_price_to_keyword"].nil?    ?          1000 : params["filter_price_to_keyword"].to_i

        if    filter_price_from_keyword > filter_price_to_keyword 
            filter_depiction =  "error" 
        elsif filter_price_from_keyword == filter_price_to_keyword     
            filter_depiction =  "budget = "+ filter_price_from_keyword.to_s
        else
            filter_depiction = filter_price_from_keyword.to_s+" <= budget AND "+filter_price_to_keyword.to_s+" >= budget"
        end    

        if geo_keyword == "" && feat_keyword == ""
            flash[:alert]  = "所有搜尋欄位不得為空白"
            redirect_to "/"
        elsif filter_depiction == "error"
            flash[:alert]  = "價格區間設定錯誤"
            redirect_to "/"
        else    
            geo_keyword_fix = "%"+geo_keyword+"%"
            feat_keyword_fix = "%"+feat_keyword+"%"
            @stores = Store.where("address LIKE ?",geo_keyword_fix).where("title LIKE ? OR  feature LIKE ?",feat_keyword_fix,feat_keyword_fix).where(filter_depiction).order(order_keyword.to_sym => :desc).distinct
            flash[:notice] = "查詢關鍵字為: " + geo_keyword+"、"+feat_keyword+", 共回傳了"+@stores.count.to_s+"個結果"
            @geo_kw_temp    = geo_keyword
            @feat_kw_temp   = feat_keyword
            @order_kw_temp  = order_keyword
            @filter_kw_price_from_temp = filter_price_from_keyword 
            @filter_kw_price_to_temp   = filter_price_to_keyword
        end          
    end    

    def show_store
        if Store.find_by(id:params["id"])
            @store     = Store.find_by(id:params["id"]) 
            @latitude  = Geocoder.search(Store.find_by(id:params["id"]).address).first.coordinates[0].to_s
            @longitude = Geocoder.search(Store.find_by(id:params["id"]).address).first.coordinates[1].to_s
        else
            redirect_to "/stores_error_show"
        end      
    end    

    def error_show    
    end  

    def edit_menu
        store_id = params["store_id"]
        if Menu.find_by(store_id:store_id ).present?
            menuArray    = Menu.find_by(store_id:store_id).content.split("?")
            @menu_status = "revise"
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
            @menu_status = "create"
            @dish_01     = ""
            @dish_02     = ""
            @dish_03     = ""
            @dish_04     = ""
            @dish_05     = ""
            @price_01    = "100"
            @price_02    = "100"
            @price_03    = "100"
            @price_04    = "100"
            @price_05    = "100"
        end    
    end
    
    def update_menu
        params      = menu_params
        store_id    = params["store_id"]
        menu_status = params["menu_status"]
        content     = menu_content_chain(params)

        if menu_status == "create"
            if Menu.new(store_id: store_id, content: content).save
                flash[:notice]  = "菜單內容新增成功"
                redirect_to "/"
            else
                flash[:notice]  = "菜單內容新增失敗"
                redirect_to "/"
            end 
        elsif menu_status == "revise"   
            if Menu.update(store_id: store_id, content: content)
                flash[:notice]  = "菜單內容修改成功"
                redirect_to "/"
            else
                flash[:notice]  = "菜單內容修改失敗"
                redirect_to "/"
            end     
        end
        
    end    
   
    private
    def comment_params
        params.require(:comment).permit( :user_id, :store_id, :visit_count, :score,
                                         :visit_time, :spend, :content)   
    end   
    
    def key_word_params
        params.permit(:geo_keyword, :feat_keyword, :order_keyword, :filter_price_from_keyword, :filter_price_to_keyword)
    end    

    def menu_params
        params.permit(:store_id, :dish_01, :dish_02, :dish_03, :dish_04, :dish_05,
                      :price_01, :price_02, :price_03, :price_04, :price_05, :menu_status);
    end    

    def is_self_comment?(current_user,store_id)
        if user_session["has_store?"] == true
            return current_user.store.id.to_s.eql?(store_id) 
        else
            return false      
        end    
    end

    def blank_params_check(message_hash)    
        message_hash.keep_if {|key, value| value == ["can't be blank"] }.keys.to_s+"以上欄位不得為空白" 
    end 

    def update_store_related_comment(store) 
        renew_comments_count = store.comments_count
        renew_comments_count = renew_comments_count+1
        renew_avg_score      = Comment.where(store_id:store.id ).average(:score).to_f.round(2)        
        store.update_attributes(avg_score: renew_avg_score, comments_count: renew_comments_count )   
    end
    
    def update_user_related_comment(user)
        renew_comment_count = user.comment_count.to_i + 1  
        user.update_attribute(:comment_count,renew_comment_count)
    end    
    
    def menu_content_chain(params)
        content = "#{params["dish_01"]}?#{params["price_01"]}?#{params["dish_02"]}?#{params["price_02"]}?#{params["dish_03"]}?#{params["price_03"]}?#{params["dish_04"]}?#{params["price_04"]}?#{params["dish_05"]}?#{params["price_05"]}"    
    end    

end
