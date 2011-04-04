# coding: utf-8
module CartItemsHelper

  def render_create_or_update_cart_item( cart_item, cart )
    delay( Duration ) do
      action :remove, cart_item.row_tag if cart_item.amount.zero? or cart.cart_items.empty?
      replace_html :cart_totals, :partial => "carts/totals"      
      check_cart_links( cart, false )
    end    
  end  

end
