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

    def user_list_comments
        if current_user.comments.present?
            @comments_exist = true
            @comments = current_user.comments.order(updated_at: :desc)
        else
            @comments_exist = false
        end       
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
            condition_keyword = ( "" if geo_keyword.empty? && feat_keyword.empty?) || 
                                (geo_keyword if !geo_keyword.empty? && feat_keyword.empty?) || 
                                (feat_keyword if geo_keyword.empty? && !feat_keyword.empty?) ||
                                (geo_keyword+"、"+feat_keyword)
            @stores = Store.where("address LIKE ? OR city LIKE ? OR district LIKE ?", geo_keyword_fix, geo_keyword_fix, geo_keyword_fix,).where("title LIKE ? OR  feature LIKE ?",feat_keyword_fix,feat_keyword_fix).where(filter_depiction).order(order_keyword.to_sym => :desc).distinct
            flash[:notice] = "查詢關鍵字為: " +condition_keyword+", 共回傳了"+@stores.count.to_s+"個結果"
            @geo_kw_temp    = geo_keyword
            @feat_kw_temp   = feat_keyword
            @order_kw_temp  = order_keyword
            @filter_kw_price_from_temp = filter_price_from_keyword 
            @filter_kw_price_to_temp   = filter_price_to_keyword
        end          
    end    

    def error_show    
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
        params.require(:store).permit(menus_attributes: [:id, :item_name, :item_price, :_destroy])     
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
end
