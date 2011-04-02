# coding: utf-8
module CartItemsHelper

  def render_create_or_update_cart_item( cart_item, session )
    delay( Duration ) do
      action :remove, cart_item.row_tag if cart_item.amount.zero? or session.cart.cart_items.empty?
      check_cart_totals( session )
      check_cart_links( session, false )
    end    
  end  
  
end
