module CartsHelper
  
  def link_to_new_order_form
    link_to image_tag( NewProcessedOrderImage ) + ProcessedOrder.human_attribute_name( :new_text ),
        new_processed_order_path, :remote => true
  end
  
  def link_to_clear_cart
    link_to image_tag( ClearCartImage ) + t( :clear_cart ), cart,
        :remote => true, :method => :delete
  end
  
end
