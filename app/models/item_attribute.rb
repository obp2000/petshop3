# encoding: utf-8
class ItemAttribute < ActiveRecord1
  
  self.abstract_class = true
  
  class_inheritable_accessor :insert_attr, :change_image, :attr_partial, :js_for_add_to_item,
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

  class << self

# actions
    def update_attr( item, ids )
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
    
    def hidden_field_name() "item[#{underscore}_ids][]" end 
     
  end
  
# renders  
  def render_create_or_update( page, cart )
    super
    page.replace new_tag, :partial => new_partial, :object => new
    page.replace tag, :partial => "items/" + attr_partial, :object => self
  end   
  
  def add_to_item( page )
    page.remove_and_insert [ :remove, tag ],
                           [ :bottom, attrs_tag, { :partial => "items/#{insert_attr}", :object => self } ]
    page.attach_chain( js_for_add_to_item )          
  end    
    
end