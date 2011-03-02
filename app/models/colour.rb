# encoding: utf-8
class Colour < ItemAttribute
  has_many :items_colours, :dependent => :delete_all
  has_many :items, :through => :items_colours
  has_many :cart_items
  has_many :order_items

  self.class_name_rus = "цвет"   
  self.class_name_rus_cap = "Цвет"
  self.change_image = "kcoloredit.png"
  self.index_text = "Цвета"
  self.paginate_options = { :per_page => 10 }
  self.attach_js = [ "attach_mColorPicker" ]   

  class_inheritable_accessor :add_html_code_to_colour_image, :add_html_code_to_colour_js_string
    
  self.add_html_code_to_colour_image = [ "arrow-180.png", { :title => "Добавить в #{class_name_rus}" } ]
  self.add_html_code_to_colour_js_string = "$(this).prev('input').val( $(this).prev('input').val() + ' ' + $(this).next('input').val() )"  

  validate :must_have_name, :must_have_unique_name, :must_have_html_code, :must_have_unique_html_code
  
  def must_have_html_code
    errors.add :base, "Код #{class_name_rus}а не может быть пустым" if html_code.blank?      
  end

  def must_have_unique_html_code
    errors.add :base, "#{class_name_rus_cap} с такими кодами уже есть" if new_record? &&
                  ( self.class.where( :html_code => html_code ) ).first       
  end

  scope :index_scope, order( :name )

  class << self
     
# links     
    def link_to_add_html_code_to( page )
      page.link_to_function page.image_tag( *add_html_code_to_colour_image ), add_html_code_to_colour_js_string
    end
     
  end
    
end
