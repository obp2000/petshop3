# encoding: utf-8
class Contact < ActiveRecord1

  class_inheritable_accessor :change_image, :index_partial
  self.index_partial = "shared/index"
  self.show_tag = ContentTag
  self.new_attr = false

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_length_of :name, :minimum => 2
  validates_length_of :phone, :minimum => 7  

  extend InsertContent

# notices
  def update_notice() human_attribute_name( :update_notice ) end    

end
