# encoding: utf-8
class ItemAttribute < ActiveRecord1
  
  self.abstract_class = true
  
  class_inheritable_accessor :insert_attr,
    :change_image, :attr_partial, :options_for_replace_new_tag, :js_for_add_to_item,
    :hidden_field_name, :index_partial, :edit_partial, :delete_from_item_js
  
  self.delete_from_item_js = "$(this).prev().remove();
                              $(this).next(':hidden').remove();
                              $(this).next(':checked').remove();
                              $(this).next('textarea').remove();
                              $(this).remove()"
  self.insert_attr = "attr"      
  self.change_image = []
  self.attr_partial = "attr"
  self.js_for_add_to_item = []
  self.index_partial = "shared/index"
  self.edit_partial = "shared/attr"    
  
  attr_accessor_with_default( :options_for_replace_item_attributes ) {
          [ tag, { :partial => "items/" + attr_partial, :object => self } ] }

  class << self

# actions
    def update_attr( item, ids )
#      item.send( tableize ).clear
#      ids.each { |id1| item.send( tableize ) << find( id1 ) rescue nil }
      item.send( tableize ).reject( &:new_record? ).each do |attr|
        unless ids.include?( attr.id )
          item.send( tableize ).delete( attr )
        end
      end
      ids.each do |id1|
        unless item.send( tableize ).include?( id1 ) or id1 == "0"
          item.send( tableize ) << find( id1 )
        end        
      end
    end
    
    include InsertContent
    
    attr_accessor_with_default( :options_for_replace_new_tag ) {
        [ new_tag, { :partial => new_partial, :object => new1 } ] }
    attr_accessor_with_default( :hidden_field_name ) { "item[#{underscore}_ids][]" } 
     
  end
  
# renders  
  def render_create_or_update( page, session )
    super
    [ options_for_replace_new_tag, options_for_replace_item_attributes ].each do |replace_args|
      page.replace *replace_args rescue nil
    end  
  end   
  
  def add_to_item( page )
    page.remove_and_insert [ :remove, tag ],
                           [ :bottom, attrs_tag, { :partial => "items/#{insert_attr}", :object => self } ]
    page.attach_chain( js_for_add_to_item )          
  end    
    
end