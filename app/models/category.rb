# encoding: utf-8
class Category < ItemAttribute
  has_many :items, :include => [:sizes, :colours, :photos]
  has_many :catalog_items, :include => [:sizes, :colours, :photos]
  has_many :summer_catalog_items, :include => [:sizes, :colours, :photos]
  has_many :winter_catalog_items, :include => [:sizes, :colours, :photos]

  self.class_name_rus = "вид одежды"  
  self.class_name_rus_cap = "Вид одежды"
  self.change_image = "color_line.png"
  self.index_text = "Вид одежды"
  self.attr_partial = "category"
  self.attr_choose_partial = name.tableize
  self.hidden_field_name = "item[category_id]"
 
  validate :must_have_name, :must_have_unique_name

  scope :index_scope, order( :name )

# JS
  def add_to_item( page )
    page.replace_html "form_#{dom_id}", :partial => "items/#{attr_partial}", :object => self
#    page.replace_html "form_categories", :partial => "items/category", :object => self
  end
   
end
