# coding: utf-8
module CartItemsHelper

  def after_create_or_update_cart_item( tag, it_was_last_cart_item, session )
    delay( Duration ) do
      action :remove, tag if it_was_last_cart_item
      check_cart_totals( session )
      check_cart_links( session, false )
    end    
  end  
  
end
