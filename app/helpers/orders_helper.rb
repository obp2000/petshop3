module OrdersHelper
  
  def closed_at_or_link_to_close( object )
    object.closed? ? date_time_rus( object.updated_at ) : link_to_close( object )     
  end  
  
end
