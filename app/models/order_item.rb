# encoding: utf-8
class OrderItem < ActiveRecord1
  belongs_to :order 
  belongs_to :item
  belongs_to :size
  belongs_to :colour
 
  delegate :name, :to => :item 
  
  self.class_name_rus = "товар"
  self.class_name_rus_cap = "Товар"    

  attr_accessor_with_default( :order_item_sum ) { price * amount }
   
  attr_accessor_with_default( :notice ) { 
          "#{name} #{size.name rescue ""} #{colour.name rescue ""} (#{ price.to_i } #{RUB}) - #{amount} #{SHT}".html_safe }
  
end
