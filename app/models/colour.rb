# encoding: utf-8
class Colour < ItemAttribute
  has_many :items_colours, :dependent => :delete_all
  has_many :items, :through => :items_colours
  has_many :cart_items
  has_many :order_items

  self.change_image = ChangeColourImage
  self.paginate_options = { :per_page => 10 }
  self.js_for_index = self.js_for_new_or_edit = self.js_for_create_or_update = [ "attach_mColorPicker" ]   

  class_inheritable_accessor :style
  self.style = "margin-left: -2px"
  
  validates_presence_of :name 
  validates_uniqueness_of :name  
  validates_presence_of :html_code
  validates_uniqueness_of :html_code

  scope :index_scope, order( :name )
    
end
