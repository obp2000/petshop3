# encoding: utf-8
class Contact < ActiveRecord1

  class_inheritable_accessor :name_image, :email_image, :phone_image,
    :address_image, :icq_image, :change_image, :show_text
  self.name_image = "loginmanager.png"
  self.email_image = "mail_generic.png"
  self.phone_image = "kcall.png"  
  self.address_image = "kfm_home.png"
  self.icq_image = "icq_protocol.png"
  self.show_image = "contacts.png"
  self.index_partial = "shared/index"
  self.show_tag = ContentTag
  self.show_text = model_name.human.pluralize

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_length_of :name, :minimum => 2
  validates_length_of :phone, :minimum => 7  

  class << self

    include InsertContent
     
    attr_accessor_with_default( :new1 ) { }
  
  end

# notices
  def set_update_notice; self.class.human_attribute_name( :update_notice ) end    

end
