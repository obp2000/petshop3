# encoding: utf-8
class Cart < ActiveRecord1
  has_many :cart_items, :dependent => :delete_all do
    def clear_cart; dup.tap { clear } end
    def dom_id; name.tableize end
  end
  has_many :items, :through => :cart_items

  delegate :sum_amount, :to => :cart_items, :prefix => true
  delegate :total, :to => :cart_items

  self.delete_image = "basket_close.png"
  self.submit_image = [ "basket_add.png", { :title => human_attribute_name( :submit_title ),
     :onmouseover => "$(this).attr('src', 'images/basket_add_over.png')",
     :onmouseout => "$(this).attr('src', 'images/basket_add.png')",
     :onclick => "$(this).fadeOut().fadeIn()" } ]
  self.delete_text = human_attribute_name( :delete_text )
          
  class_inheritable_accessor :cart, :link_to_new_order_form, :link_to_clear_cart,
        :total_items_dom_id, :total_sum_dom_id, :content_tag, :cart_image, :cart_text,
        :cart_totals_dom_id
  self.link_to_new_order_form = "link_to_new_order_form"
  self.link_to_clear_cart = "link_to_clear_cart"
  self.total_items_dom_id = "cart_total_items"
  self.total_sum_dom_id = "cart_total_sum"
  self.content_tag = "cart"
  self.cart_image = "basket.png"
  self.cart_totals_dom_id = "cart_totals"

  attr_accessor_with_default( :delete_title ) { nil }
  attr_accessor_with_default( :cart_totals ) { [ [ Cart.total_items_dom_id, cart_items_sum_amount ],
        [ Cart.total_sum_dom_id, total ] ] }    

  class << self

# actions
    def find_or_create( session )
      find( session[ :cart_id ] ) rescue create.tap { |cart| session[ :cart_id ] = cart.id }
    end

    def find_current_object( params, session ); session.cart end
  
  end

# actions
  def clear_cart; cart_items.clear_cart end
  alias_method :destroy_object, :clear_cart    

  def populate_order( order ); cart_items.each { |cart_item| order.populate_order_item( cart_item ) } end

# notices
  def set_destroy_notice; self.class.human_attribute_name( :update_notice ) end  

# links
  def link_to_cart( page ); page.image_tag( cart_image ) + self.class.model_name.human end

end
