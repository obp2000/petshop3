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

  self.submit_image = [ "document-save.png", { :title => human_attribute_name( :submit_title ) } ]     
  self.new_image = [ "newdoc.png", { :title => human_attribute_name( :new_title ) } ]
  self.index_render_block = lambda { render request.xhr? ? Index_template_hash :
        { :partial => "index", :layout => "items" } }
  self.paginate_options = { :per_page => 14 }
  self.js_for_new_or_edit = self.js_for_show = [ "attach_yoxview" ]
  self.new_tag = "item_content"
  self.edit_partial = "form"
  self.show_tag = new_tag  

  class_inheritable_accessor :style, :edit_tag
  self.style = "margin-left: 10px;"
  self.edit_tag = new_tag

  validates_length_of :name, :minimum => 2
  validates_presence_of :category, :type
  validates_numericality_of :price, :only_integer => true

  def season; Season.new( self ) end

  class << self

# actions
    def index_scope( params ); all.sort_by { |item| eval( "item." + params[ :sort_by ] ) rescue "" } end

# tags and partials
    attr_accessor_with_default( :index_page_title_for ) { human_attribute_name( :index_page_title ) }
    
    include ReplaceContent      

    def headers
      [ [ "name", human_attribute_name( :name ) ],
        [ "sizes.first.name", Size.model_name.human.pluralize ],
        [ "colours.first.name", Colour.model_name.human.pluralize ],
        [ "category.name", Category.model_name.human ],
        [ "price", human_attribute_name( :price ) ] ]
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

  attr_accessor_with_default( :create_or_update_tag ) { tag }
  attr_accessor_with_default( :create_or_update_partial ) { row_partial } 

  [ "Size", "Colour" ].each do |class_name|
    define_method( "#{class_name.underscore}_ids=" ) { |ids| class_name.constantize.update_attr( self, ids ) }    
  end   
   
end
