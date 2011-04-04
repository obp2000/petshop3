# encoding: utf-8
class OrderItem < ActiveRecord1
  belongs_to :order 
  belongs_to :item
  belongs_to :size
  belongs_to :colour
 
  delegate :name, :to => :item 

  def order_item_sum() price * amount end
    
  def self.populate_order_item( cart_item )
    create( cart_item.populate_order_item_hash )
  end
  
end
