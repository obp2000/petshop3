# encoding: utf-8
class Size < ItemAttribute
  has_many :items_sizes, :dependent => :delete_all
  has_many :items, :through => :items_sizes
  
  has_many :cart_items
  has_many :order_items

  validates_presence_of :name 
  validates_uniqueness_of :name

  self.change_image = ChangeSizeImage
  
  class_inheritable_accessor :style
  self.style = "margin-left: -2px; margin-right: -1px"

end
