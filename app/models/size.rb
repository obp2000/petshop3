# encoding: utf-8
class Size < ItemAttribute
  has_many :items_sizes, :dependent => :delete_all
  has_many :items, :through => :items_sizes
  
  has_many :cart_items
  has_many :order_items

  self.change_image = "pencil-ruler.png"
  
  class_inheritable_accessor :style
  self.style = "margin-left: -2px; margin-right: -1px"

end
