# encoding: utf-8
class Cart < ActiveRecord1
  
  has_many :cart_items, :dependent => :delete_all

  has_many :items, :through => :cart_items

  delegate :sum_amount, :to => :cart_items, :prefix => true
  delegate :total, :to => :cart_items
          
  class_inheritable_accessor :cart, :link_to_new_order_form, :link_to_clear_cart,
        :total_items_dom_id, :total_sum_dom_id, :content_tag, :cart_totals_dom_id
  self.link_to_new_order_form = "link_to_new_order_form"
  self.link_to_clear_cart = "link_to_clear_cart"
  self.total_items_dom_id = "cart_total_items"
  self.total_sum_dom_id = "cart_total_sum"
  self.content_tag = "cart"
  self.cart_totals_dom_id = "cart_totals"

  attr_accessor_with_default( :cart_totals ) {
    [ [ Cart.total_items_dom_id, cart_items_sum_amount ], [ Cart.total_sum_dom_id, total ] ] }    

  class << self

# actions
    def find_or_create( session )
      find( session[ :cart_id ] ) rescue create.tap { |cart| session[ :cart_id ] = cart.id }
    end

    def find_current_object( params, session )
      session.cart
    end
  
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
  def render_destroy( page, session )
    @cart_items_clone.each { |cart_item| cart_item.render_destroy( page, session ) }
  end

# notices
  def destroy_notice
    self.class.human_attribute_name( :destroy_notice )
  end  

end
