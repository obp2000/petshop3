# encoding: utf-8
class CartItem < ActiveRecord1
  belongs_to :cart
  belongs_to :item
  belongs_to :catalog_item, :foreign_key => :item_id  
  belongs_to :size
  belongs_to :colour
  
  delegate :name, :price, :to => :item
  
  self.class_name_rus = "товар"
  self.class_name_rus_cap = "Товар"
  self.index_partial = "carts/cart"
  self.create_or_update_partial = "cart_items/cart_item"     
  
#  class_inheritable_accessor :create_or_update_partial
  
  attr_accessor_with_default( :create_or_update_tag ) { tag }     
  
  class << self

# actions
    def update_object( params, session, flash ); [ update_cart_item( params.conditions_hash( session ), flash ), true ] end

    def destroy_object( params, session, flash ); find( params[ :id ] ).tap { |cart_item| cart_item.delete_cart_item( flash ) } end

  end

# actions
  def delete_cart_item( flash ); update_amount( -1 ); destroy if amount.zero?; destroy_notice( flash ) end   
  
  def update_amount( i ); update_attribute :amount, amount + i end     

  attr_accessor_with_default( :populate_order_item_hash ) { { :item_id => item_id, :price => price,
          :amount => amount,  :size_id => size_id, :colour_id => colour_id } }  
#  def populate_order_item_hash
#    { :item_id => item_id, :price => price, :amount => amount,  :size_id => size_id, :colour_id => colour_id } end  
  
# renders    
  def render_create_or_update( page, session )
    super; page.after_create_or_update_cart_item tag, ( amount.zero? or session.cart.cart_items.empty? ), session
  end  
  alias_method :render_destroy, :render_create_or_update

# notices
  def update_notice( flash ); flash.now[ :notice ] = "Добавлен товар<br /> <em>#{name}</em>".html_safe end

  def destroy_notice( flash ); flash.now[ :notice ] = "Удален товар <em>#{name}</em>".html_safe end

  private
  
    def self.update_cart_item( conditions, flash )
      ( first( :conditions => conditions ).tap { |cart_item| cart_item.update_amount( 1 ) } rescue
              create( conditions.merge :amount => 1 ) ).tap { |cart_item| cart_item.update_notice( flash ) } end
    
end

class Hash
  
  def conditions_hash( session )
    { :item_id => self[ :id ].gsub(/\D/u, ""), :size_id => self[ :size_id ], :colour_id => self[ :colour_id ], :cart_id => session.cart.id }
  end  
  
end
