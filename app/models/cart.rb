# encoding: utf-8
class Cart < ActiveRecord1
  
  has_many :cart_items, :dependent => :delete_all

  has_many :items, :through => :cart_items

  delegate :sum_amount, :to => :cart_items, :prefix => true
  delegate :total, :to => :cart_items

  class << self

# actions
    def find_or_create( session )
      find( session[ :cart_id ] ) rescue create.tap { |cart| session[ :cart_id ] = cart.id }
    end

    def find_current_object( params, cart ) cart end
  
  end

# actions
  def clear_cart
    @cart_items_clone = cart_items.clone
    cart_items.clear
  end
  alias_method :destroy_object, :clear_cart    

  def populate_order( order )
    cart_items.each do |cart_item|
      order.populate_order_item( cart_item )
    end
  end

#renders
  def render_destroy( page, cart )
    @cart_items_clone.each { |cart_item| cart_item.render_destroy( page, cart ) }
  end

# notices
  def destroy_notice() human_attribute_name( :destroy_notice ) end  

end
