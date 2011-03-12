# encoding: utf-8
class Cart < ActiveRecord1
  has_many :cart_items, :dependent => :delete_all do
    def clear_cart; dup.tap { clear } end
    def dom_id; name.tableize end
  end
  has_many :items, :through => :cart_items

  delegate :sum_amount, :to => :cart_items, :prefix => true
  delegate :total, :to => :cart_items

  self.class_name_rus = "корзина"
  self.class_name_rus_cap = "Корзина"
  self.delete_image = "basket_close.png"
  self.submit_with_options = [ "image_submit_tag", "basket_add.png",
    { :title => "Добавить этот #{CatalogItem.class_name_rus} в корзину",
     :onmouseover => "$(this).attr('src', 'images/basket_add_over.png')",
     :onmouseout => "$(this).attr('src', 'images/basket_add.png')",
     :onclick => "$(this).fadeOut().fadeIn()" } ]
  self.delete_text = "Очистить корзину"
  self.nav_image = "basket.png"
  self.nav_text = "Корзина"
          
  class_inheritable_accessor :cart, :link_to_new_order_form, :link_to_clear_cart,
        :total_items_dom_id, :total_sum_dom_id, :content_tag
  self.link_to_new_order_form = "link_to_new_order_form"
  self.link_to_clear_cart = "link_to_clear_cart"
  self.total_items_dom_id = "cart_total_items"
  self.total_sum_dom_id = "cart_total_sum"
  self.content_tag = "cart"

  attr_accessor_with_default( :delete_title ) { nil }
  attr_accessor_with_default( :cart_totals ) { [ [ Cart.total_items_dom_id, cart_items_sum_amount ],
        [ Cart.total_sum_dom_id, total ] ] }    

  class << self

# actions
    def find_or_create( session )
      find( session[ :cart_id ] ) rescue create.tap { |cart| session[ :cart_id ] = cart.id }
    end

    def find_current_object( params, session ); session.cart end
 
 # links
    def link_to_cart( page ); page.image_tag( nav_image ) + nav_text end
  
  end

# actions
  def clear_cart; cart_items.clear_cart end
  alias_method :destroy_object, :clear_cart    

  def populate_order( order ); cart_items.each { |cart_item| order.populate_order_item( cart_item ) } end

# notices
  def set_destroy_notice( flash ); flash.now[ :notice ] = "Корзина очищена" end  

end
