# encoding: utf-8
class Photo < ItemAttribute
  belongs_to :item

  mount_uploader :photo, PhotoUploader

  self.change_image = "insert-image.png"
  self.delete_from_item_js_string =
    "$(this).siblings(':checkbox').removeAttr('checked');$(this).siblings(':not(:checkbox)').remove();$(this).remove();"  
  self.insert_attr = "photo"
  self.create_render_block = lambda { responds_to_parent { render Create_or_update_template_hash } }
  self.paginate_options = { :per_page => 5  }
  self.js_for_add_to_item = self.js_for_create_or_update = [ "attach_mColorPicker" ]
  self.partial_for_attr_with_link_to_remove = "photo"  
  self.new_partial = "photos/upload_photo"
  
  class_inheritable_accessor :upload_frame
  self.upload_frame = "upload_frame"

  validates_presence_of :photo_url
 
  scope :index_scope, where( :item_id => nil ).order( :id ) 

# links
  def link_to_show( page, comment = "" ); [ page.image_tag( photo.thumb.url ) + comment, photo_url ] end

  def link_to_show_with_comment( page ); link_to_show page, comment end
  
end
