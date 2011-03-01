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
  self.paginate_options = { :per_page => 5  }
  self.attach_js = [ "attach_yoxview" ] 

  class_inheritable_accessor :new_partial
  self.new_partial = "upload_photo"  
  
#  validates_integrity_of( :photo )
#  validates_processing_of( :photo )
#  validates_presence_of :photo_url 
  validate :must_have_photo
  
  def must_have_photo; errors.add :base, "Не выбрана #{class_name_rus} для загрузки" unless photo_url end
 
  scope :index_scope, where( :item_id => nil ).order( :id ) 

# links
  def link_to_show( page, comment = "" ); page.link_to page.image_tag( photo.thumb.url ) + comment, photo_url rescue nil end

  def link_to_show_with_comment( page ); link_to_show page, comment end
  
end
