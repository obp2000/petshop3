# encoding: utf-8
class Cart < ActiveRecord1
  has_many :cart_items, :dependent => :delete_all do
    def clear_cart; dup.tap { clear } end
  end
  has_many :items, :through => :cart_items

  delegate :total, :to => :cart_items

  self.class_name_rus = "корзина"
  self.class_name_rus_cap = "Корзина"
  self.delete_image = "basket_close.png"
  self.submit_with_options = [ "image_submit_tag", "basket_add.png",
    { :title => "Добавить этот #{CatalogItem.class_name_rus} в корзину",
     :onmouseover => "$(this).attr('src', 'images/basket_add_over.png')",
     :onmouseout => "$(this).attr('src', 'images/basket_add.png')",
     :onclick => "$(this).fadeOut().fadeIn()" } ]
  self.index_partial = "carts/cart"
  self.delete_text = "Очистить корзину"
  self.nav_image = "basket.png"
  self.nav_text = "Корзина"
          
  class_inheritable_accessor :cart, :cart_links
  self.cart_links = [ "link_to_new_order_form", "link_to_clear_cart" ]

  attr_accessor_with_default( :delete_title ) { nil }
  attr_accessor_with_default( :total_items ) { cart_items.sum( :amount ) }
  attr_accessor_with_default( :cart_totals ) { [ [ "cart_total_items", total_items ], [ "cart_total_sum", total ] ] }    

  class << self

# actions
    def find_or_create( session )
      find( session[ :cart_id ] ) rescue create.tap { |cart| session[ :cart_id ] = cart.id } end

    def find_current_object( params, session ); session.cart end
 
 # links
    def link_to_cart( page ); page.image_tag( nav_image ) + nav_text end
  
  end

# actions
  def destroy_object; clear_cart end

  def clear_cart; cart_items.clear_cart end    

  def populate_order( order ); cart_items.each { |cart_item| order.populate_order_item( cart_item ) } end

# notices
  def set_destroy_notice( flash ); flash.now[ :notice ] = "Корзина очищена" end  

end
