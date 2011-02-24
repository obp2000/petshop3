# encoding: utf-8
class ItemAttribute < ActiveRecord1
  
  self.abstract_class = true
  
  class_inheritable_accessor :delete_from_item_title, :delete_from_item_js_string, :insert_attr,
    :change_image, :add_to_item_image, :attr_partial, :options_for_replace_new_tag
  
  self.delete_from_item_title = "Удалить из #{Item.class_name_rus}а"
  self.delete_from_item_js_string =
    "$(this).prev().remove();$(this).next(':hidden').remove();$(this).next(':checked').remove();$(this).next('textarea').remove();$(this).remove()"
  self.insert_attr = "attr"      
  self.change_image = []
  self.add_to_item_image = [ "arrow_large_right.png", { :title =>"Добавить к #{Item.class_name_rus}у" } ]
  self.attr_partial = "attr"

  attr_accessor_with_default( :options_for_replace_item_attributes ) { [ tag, { :partial => "items/" + 
          attr_partial, :object => self } ] }
#  attr_accessor_with_default( :add_to_item_block1 ) { lambda { |page| add_to_item1( page ) } }

  def must_have_unique_name
    errors.add :base, "Такой #{class_name_rus} уже есть" if new_record? && self.class.where( :name => name ).first     
  end

  class << self

# actions
    def update_attr( item, ids )
      item.send( name.tableize ).clear
      ids.each { |id1| item.send( name.tableize ) << find( id1 ) rescue nil }
    end

# links   
    def link_to_change( page )
      page.link_to_remote2 [ change_image,  { :title => "Изменить #{class_name_rus.pluralize}" } ], "", self
    end
 
    def link_to_remove_from_item( page )
      page.link_to_function page.image_tag( delete_image, { :title => delete_from_item_title } ), delete_from_item_js_string
    end
    
    attr_accessor_with_default( :options_for_replace_new_tag ) { [ new_tag, { :partial => new_partial, :object => new1 } ] }      
     
  end
  
# renders  
  def render_create_or_update( page, session )
    super
    [ options_for_replace_new_tag, options_for_replace_item_attributes ].each do |replace_args|
      page.replace *replace_args rescue nil
    end  
  end   
  
  def add_to_item1( page )
    page.remove_and_insert [ :remove, tag ],
            [ :bottom, "form_#{self.class.name.tableize}", { :partial => "items/#{insert_attr}", :object => self } ]
  end    

  def radio_button_tag1( page, checked, visibility )
    page.radio_button_tag "#{to_underscore}_id", id, checked, :style => "visibility: " + visibility
  end
    
end