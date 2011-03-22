# encoding: utf-8
class Colour < ItemAttribute
  has_many :items_colours, :dependent => :delete_all
  has_many :items, :through => :items_colours
  has_many :cart_items
  has_many :order_items

  self.change_image = "kcoloredit.png"
  self.paginate_options = { :per_page => 10 }
  self.js_for_index = self.js_for_new_or_edit = self.js_for_create_or_update = [ "attach_mColorPicker" ]   

  class_inheritable_accessor :add_html_code_to_colour_image, :add_html_code_to_colour_js_string, :style
  self.add_html_code_to_colour_image = [ "arrow-180.png",
        { :title => Colour.human_attribute_name( :add_html_code_to_colour_title ) } ]
  self.add_html_code_to_colour_js_string =
        "$(this).prev('input').val( $(this).prev('input').val() + ' ' + $(this).next('input').val() )"  
  self.style = "margin-left: -2px"
  
  validates_presence_of :html_code
  validates_uniqueness_of :html_code

  scope :index_scope, order( :name )

  class << self
     
# links     
#    def link_to_add_html_code_to( page )
#      page.link_to_function page.image_tag( *add_html_code_to_colour_image ), add_html_code_to_colour_js_string
#    end
     
  end
    
end
