# encoding: utf-8
class OrderItem < ActiveRecord1
  belongs_to :order 
  belongs_to :item
  belongs_to :size
  belongs_to :colour
 
  delegate :name, :to => :item 
  
  self.class_name_rus = "товар"
  self.class_name_rus_cap = "Товар"

  cattr_accessor :removed_item_message
  self.removed_item_message = "Товар удален из каталога!"

  attr_accessor_with_default( :order_item_sum ) { price * amount }

end
