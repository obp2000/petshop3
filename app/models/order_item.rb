# encoding: utf-8
class OrderItem < ActiveRecord1
  belongs_to :order 
  belongs_to :item
  belongs_to :size
  belongs_to :colour
 
  delegate :name, :to => :item 

  attr_accessor_with_default( :order_item_sum ) { price * amount }
  
end
