# encoding: utf-8
class Contact < ActiveRecord1

  self.class_name_rus = "контакт"
  self.class_name_rus_cap = "Контакт"
  self.change_text = "Изменить контакты"  

  class_inheritable_accessor :name_rus, :name_image, :email_rus, :email_image, :phone_rus, :phone_image,
    :address_rus, :address_image, :icq_rus, :icq_image, :email_subject     

  self.name_rus = "Имя"
  self.name_image = "loginmanager.png"
  self.email_rus = "E-mail"
  self.email_image = "mail_generic.png"
  self.phone_rus = "Телефон"
  self.phone_image = "kcall.png"  
  self.address_rus = "Адрес"
  self.address_image = "kfm_home.png"
  self.icq_rus = "ICQ"
  self.icq_image = "icq_protocol.png"
  self.email_subject = "Сообщение от пользователя интернет-магазина BEST&C"
  self.show_image = "contacts.png"  

  attr_accessor_with_default( :show_text ) { class_name_rus_cap.pluralize }  

  validate :must_have_long_name, :must_have_valid_email, :must_have_long_phone

  def must_have_long_phone
    errors.add :base, "В номере телефона должно быть не менее семи символов" if phone.size < 7      
  end

  class << self

    include InsertContent

    attr_accessor_with_default( :show_page_title_for ) { class_name_rus_cap.pluralize }       
    attr_accessor_with_default( :new1 ) { }
    attr_accessor_with_default( :show_tag ) { ContentTag }
    attr_accessor_with_default( :index_partial ) { "shared/index" }
    attr_accessor_with_default( :edit_partial ) { row_partial }    
  
  end

# notices
  def set_update_notice( flash ); flash.now[ :notice ] = "#{class_name_rus_cap} успешно обновлены." end

end
