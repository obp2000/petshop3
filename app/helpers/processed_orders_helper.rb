# coding: utf-8
module ProcessedOrdersHelper

  def new_processed_order( session, controller_name )
    delay( DURATION ) { check_cart_links( session, controller_name ) }
  end 
 
  def create_processed_order( fade_duration )
    show_notice( :delay => fade_duration ) 
    fade_with_duration :errorExplanation
    delay( fade_duration ) { redirect_to "/" }    
  end 

  def update_processed_orders_amount( action1 )
    delay( DURATION ) { action *action1 }
  end

  def render_close( *actions )
    actions.each { |action1| action *action1 }
    show_notice
  end 
 
end
