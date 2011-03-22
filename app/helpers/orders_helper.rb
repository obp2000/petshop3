module OrdersHelper
  
  def closed_at_or_link_to_close( object )
    object.closed? ? l( object.updated_at, :format => :long ) : link_to_close( object )     
  end  
  
end
