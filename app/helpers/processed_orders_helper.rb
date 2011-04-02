# coding: utf-8
module ProcessedOrdersHelper

  def new_processed_order( session )
    delay( Duration ) { check_cart_links( session, true ) }
  end 
 
  def render_create_processed_order( fade_duration )
    show_notice( :delay => fade_duration ) 
    fade_with_duration :errorExplanation
    delay( fade_duration ) { redirect_to "/" }    
  end 

  def update_processed_orders_amount( action1 )
    delay( Duration ) { action *action1 }
  end

  def render_close( order )
#    actions.each { |action1| action *action1 }
    action :replace_html, order.status_tag, ClosedOrder.human_attribute_name( :status_ )
    action :replace_html, order.updated_tag, I18n.l( order.updated_at, :format => :long )
    action :replace_html, "processed_orders_amount", ProcessedOrder.count
    show_notice
  end 
 
end
