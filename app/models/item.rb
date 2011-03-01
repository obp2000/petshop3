# encoding: utf-8
class Item < ActiveRecord1
  has_many :items_sizes, :dependent => :delete_all
  has_many :sizes, :through => :items_sizes
  
  has_many :items_colours, :dependent => :delete_all
  has_many :colours, :through => :items_colours    
    
  belongs_to :category
  
  has_many :photos
  
  has_many :cart_items
  has_many :carts, :through => :cart_items

  set_inheritance_column nil  

  self.class_name_rus = "товар"
  self.class_name_rus_cap = "Товар"
  self.submit_with_options = [ "image_submit_tag", "document-save.png", { :title => "Сохранить изменения" } ]     
  self.index_partial = "index"
  self.replace = :replace_html
  self.fade_tag = "item_content"
  self.appear_tag = "item_content"
  self.new_image = [ "newdoc.png", { :title => "Добавить " } ]
  self.name_rus = "Название"
  self.index_render_block = lambda { render request.xhr? ? Index_template_hash : { :partial => "index", :layout => "items" } }
  self.paginate_options = { :per_page => 14 }
  self.insert_or_replace = "replace_index_tag"

  class_inheritable_accessor :price_rus, :headers
  self.price_rus = "Цена"

  attr_accessor_with_default( :new_or_edit_tag ) { "item_content" }
  attr_accessor_with_default( :create_or_update_tag ) { tag }
  attr_accessor_with_default( :deleted_notice ) { "#{class_name_rus_cap} удалён из каталога!" }       

  validate :must_have_long_name, :must_have_valid_price, :must_have_category, :must_have_type
  
  def must_have_valid_price
    errors.add :base, "#{price_rus} #{class_name_rus}а должна быть целым числом" unless
            price_before_type_cast && price_before_type_cast[/^[1-9][\d]*$/]      
  end

  def must_have_category
    errors.add :base, "Необходимо выбрать #{Category.class_name_rus}" if category_id.blank?      
  end

  def must_have_type
    errors.add :base, "Необходимо выбрать сезон одежды" if type.blank?     
  end

  class << self

# actions
    def index_scope( params ); all.sort_by { |item| eval( "item." + params[ :sort_by ] ) rescue "" } end

# tags and partials
    attr_accessor_with_default( :create_or_update_partial ) { edit_partial }
    attr_accessor_with_default( :new_or_edit_partial ) { "form" }
    attr_accessor_with_default( :index_tag ) { "content" }     

    attr_accessor_with_default( :index_page_title_for ) { "Список #{class_name_rus}ов" }

    def headers
      [ [ "name", "Название" ], [ "sizes.first.name", Size.class_name_rus_cap_first],
          [ "colours.first.name", Colour.class_name_rus_cap_first ], [ "category.name", Category.class_name_rus_cap_first ],
          [ "price", "Цена" ] ]
    end
  
  end

# actions
  after_update :save_photos
  
  def save_photos; photos.each { |photo| photo.save } end
  
  def update_object( params ); params[ "item" ][ :existing_photo_attributes ] ||= {}; super end
  
  def existing_photo_attributes=(photo_attributes)
    photos.reject( &:new_record? ).each do |photo|
      attributes = photo_attributes[ photo.id.to_s ]
      attributes ? photo.attributes = attributes : photos.delete( photo )
    end
  end

  [ "Size", "Colour" ].each do |class_name|
    define_method( "#{class_name.underscore}_ids=" ) { |ids| class_name.constantize.update_attr( self, ids ) }    
  end   
   
end
