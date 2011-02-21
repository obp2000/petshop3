# encoding: utf-8
class Photo < ItemAttribute
  belongs_to :item

  mount_uploader :photo, PhotoUploader

  self.class_name_rus = "фотография"  
  self.class_name_rus_cap = "Фотография"
  self.change_image = "insert-image.png"
  self.delete_from_item_js_string =
    "$(this).siblings(':checkbox').removeAttr('checked');$(this).siblings(':not(:checkbox)').remove();$(this).remove();"  
  self.insert_attr = "photo"
  self.create_render_block = lambda { responds_to_parent { render Create_or_update_template_hash } }
  self.paginate_options = { :order => "id desc", :per_page => 5  }

  class_inheritable_accessor :new_partial
  self.new_partial = self.new_or_edit_partial = "upload_photo"  
  
#  validates_integrity_of( :photo )
#  validates_processing_of( :photo )
#  validates_presence_of :photo_url 
  validate :must_have_photo
  
  def must_have_photo
    errors.add :base, "Не выбрана #{class_name_rus} для загрузки" unless photo_url
  end
 
# actions
  def all_objects( params, * ); where( :item_id => nil ).paginate_objects( params ) end

  def add_to_item1( page ); super; page.attach_js( "attach_yoxview" ) end 

# links
  def link_to_show( page, comment = "" ); page.link_to page.image_tag( photo.thumb.url ) + comment, photo_url rescue nil end

  def link_to_show_with_comment( page ); link_to_show page, comment end

# renders
  def render_create_or_update( page, session ); super; page.attach_js( "attach_yoxview" ) end
  
#  def new_notice( flash ); flash.now[ :notice ] = "ошибка" end  
  
end
