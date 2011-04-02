# coding: utf-8
module ProcessedOrdersHelper

  def new_processed_order( cart )
    delay( Duration ) { check_cart_links( cart, true ) }
  end 
 
  def render_create_processed_order( fade_duration )
    show_notice( :delay => fade_duration ) 
    fade_with_duration :errorExplanation
    delay( fade_duration ) { redirect_to "/" }    
  end 

  def render_close( order )
    action :replace_html, order.status_tag, ClosedOrder.human_attribute_name( :status_ )
    action :replace_html, order.updated_tag, I18n.l( order.updated_at, :format => :long )
    update_processed_orders_amount
    show_notice
  end 
 
end
