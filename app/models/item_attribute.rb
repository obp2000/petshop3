# encoding: utf-8
class ItemAttribute < ActiveRecord1
  
  self.abstract_class = true
  
  class_inheritable_accessor :delete_from_item_js_string, :insert_attr,
    :change_image, :add_to_item_image, :attr_partial, :options_for_replace_new_tag, :js_for_add_to_item,
    :partial_for_attr_with_link_to_remove, :attr_choose_partial, :hidden_field_index, :hidden_field_name,
    :delete_from_item_image, :index_partial, :edit_partial
  
  self.delete_from_item_js_string =
    "$(this).prev().remove();$(this).next(':hidden').remove();$(this).next(':checked').remove();$(this).next('textarea').remove();$(this).remove()"
  self.delete_from_item_image = [ delete_image,
        { :title => Item.human_attribute_name( :delete_from_item_title ) } ]     
  self.insert_attr = "attr"      
  self.change_image = []
  self.add_to_item_image = [ "arrow_large_right.png",
        { :title => Item.human_attribute_name( :add_to_item_title ) } ]
  self.attr_partial = "attr"
  self.js_for_add_to_item = []
  self.partial_for_attr_with_link_to_remove = "attr"
  self.attr_choose_partial = "attrs"
  self.index_partial = "shared/index"
  self.edit_partial = "shared/attr"    
  
  attr_accessor_with_default( :options_for_replace_item_attributes ) {
          [ tag, { :partial => "items/" + attr_partial, :object => self } ] }

  validates_presence_of :name 
  validates_uniqueness_of :name

  class << self

# actions
    def update_attr( item, ids )
      item.send( name.tableize ).clear
      ids.each { |id1| item.send( name.tableize ) << find( id1 ) rescue nil }
    end
    
    include InsertContent
    
    attr_accessor_with_default( :options_for_replace_new_tag ) {
        [ new_tag, { :partial => new_partial, :object => new1 } ] }
    attr_accessor_with_default( :hidden_field_index ) { name.underscore + "_ids" } 
    attr_accessor_with_default( :hidden_field_name ) { "item[#{name.underscore}_ids][]" } 
     
  end
  
# renders  
  def render_create_or_update( page, session )
    super
    [ options_for_replace_new_tag, options_for_replace_item_attributes ].each do |replace_args|
      page.replace *replace_args rescue nil
    end  
  end   
  
  def add_to_item( page )
    page.remove_and_insert [ :remove, tag ], [ :bottom, "form_#{dom_id}",
            { :partial => "items/#{insert_attr}", :object => self } ]
    page.attach_chain( js_for_add_to_item )          
  end    
    
end