# encoding: utf-8
class Category < ItemAttribute

  has_many :items, :include => [:sizes, :colours, :photos]
  has_many :catalog_items, :include => [:sizes, :colours, :photos]
  has_many :summer_catalog_items, :include => [:sizes, :colours, :photos]
  has_many :winter_catalog_items, :include => [:sizes, :colours, :photos]

  validates_presence_of :name 
  validates_uniqueness_of :name
  validates_length_of :name, :minimum => 2  

  self.change_image = ChangeCategoryImage
  self.attr_partial = "category"

  class_inheritable_accessor :hidden_field_name
  self.hidden_field_name = "item[category_id]"

  scope :index_scope, order( :name )

# JS
  def add_to_item( page )
    page.replace_html attrs_tag, :partial => "items/#{attr_partial}", :object => self
  end
   
end
