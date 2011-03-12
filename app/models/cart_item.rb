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
  
  attr_accessor_with_default( :create_or_update_tag ) { tag }
  
  class << self

# actions
    def find_object_for_update( params, session )
      where( params.conditions_hash( session ) ).first ||
              create( params.conditions_hash( session ).merge :amount => 0 )
    end

    attr_accessor_with_default( :edit_partial ) { "#{partial_path}/#{row_partial}" }  

  end

# actions
  def destroy_object; tap { update_amount( -1 ); destroy if amount.zero? } end
    
  def update_object( params ); [ tap { update_amount( 1 ) }, true ] end

  def populate_order_item_hash
    {}.tap do |order_item_hash|
      [ :item_id, :price, :amount, :size_id, :colour_id ].each { |arg| order_item_hash[ arg ] = send( arg ) }
    end
  end

# notices
  def set_update_notice( flash ); flash.now[ :notice ] = "Добавлен товар<br /> <em>#{name}</em>".html_safe end

  def set_destroy_notice( flash ); flash.now[ :notice ] = "Удален товар <em>#{name}</em>".html_safe end  
  
# renders    
  def render_create_or_update( page, session )
    super
    page.after_create_or_update_cart_item tag, ( amount.zero? or session.cart.cart_items.empty? ), session
  end
  alias_method :render_destroy, :render_create_or_update
  
  private
    def update_amount( i ); update_attribute :amount, amount + i end     
    
end

class Hash
  
  def conditions_hash( session )
    { :item_id => self[ :id ].gsub(/\D/u, ""), :size_id => self[ :size_id ], :colour_id => self[ :colour_id ],
          :cart_id => session.cart.id }
  end  
  
end
