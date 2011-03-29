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

  DeleteFromItemJS = "$(this).prev().remove();
                      $(this).next(':hidden').remove();
                      $(this).next(':checked').remove();
                      $(this).next('textarea').remove();
                      $(this).remove()"

  self.paginate_options = { :per_page => 14 }
  self.js_for_new_or_edit = self.js_for_show = [ "attach_yoxview" ]
  self.edit_partial = "form"
  self.index_layout = "items"

  class_inheritable_accessor :style, :edit_tag
  self.style = "margin-left: 10px;"
  self.edit_tag = self.new_tag = "edit_item"

  validates_length_of :name, :minimum => 2
  validates_presence_of :category, :type
  validates_numericality_of :price, :only_integer => true

  def season
    Season.new( self )
  end

  class << self

# actions
    def index_scope( params )
      all.sort_by { |item| eval( "item." + params[ :sort_by ] ) rescue "" }
    end
    
    include ReplaceContent      
  
  end

# actions
  after_update :save_photos
  
  def save_photos
    photos.each { |photo| photo.save }
  end
  
  def update_object( params )
    params[ "item" ][ :existing_photo_attributes ] ||= {}
    super
  end
  
  def existing_photo_attributes=(photo_attributes)
    photos.reject( &:new_record? ).each do |photo|
      attributes = photo_attributes[ photo.id.to_s ]
      attributes ? photo.attributes = attributes : photos.delete( photo )
    end
  end

  attr_accessor_with_default( :row_tag ) { tag }
  attr_accessor_with_default( :row_partial ) { underscore } 

  [ "Size", "Colour" ].each do |class_name|
    define_method( "#{class_name.underscore}_ids=" ) { |ids| class_name.constantize.update_attr( self, ids ) }    
  end   
   
end
