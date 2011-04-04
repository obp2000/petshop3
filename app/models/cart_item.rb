# encoding: utf-8
class CartItem < ActiveRecord1
  
  belongs_to :cart
  belongs_to :item
  belongs_to :catalog_item, :foreign_key => :item_id  
  belongs_to :size
  belongs_to :colour
  
  delegate :name, :price, :to => :item
    
  class << self

# actions
    def find_object_for_update( params, cart )
      where( params.conditions_hash( cart ) ).first ||
              create( params.conditions_hash( cart ).merge :amount => 0 )
    end

    def edit_partial() "#{partial_path}/#{underscore}" end  

  end

  def row_tag() tag end

# actions
  def destroy_object
    update_amount( -1 )
    super if amount.zero?
  end
    
  def update_object( params )
    update_amount( 1 )
  end

  def populate_order_item_hash
    {}.tap do |order_item_hash|
      [ :item_id, :price, :amount, :size_id, :colour_id ].each {
          |arg| order_item_hash[ arg ] = send( arg ) }
    end
  end

# notices
  def update_notice
    "#{human_attribute_name( :update_notice )}<br/><em>#{name}</em>".html_safe
  end

  def destroy_notice
    "#{human_attribute_name( :destroy_notice )} <em>#{name}</em>".html_safe
  end  
  
# renders    
  def render_create_or_update( page, cart )
    super
    page.render_create_or_update_cart_item( self, cart )
  end
  alias_method :render_destroy, :render_create_or_update
  
  private
    def update_amount( i ) update_attribute( :amount, amount + i ) end     
    
end

class Hash
  
  def conditions_hash( cart )
    { :item_id => self[ :id ].gsub(/\D/u, ""), :size_id => self[ :size_id ],
      :colour_id => self[ :colour_id ], :cart_id => cart.id }
  end  
  
end
