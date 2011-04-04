# encoding: utf-8
class Order < ActiveRecord1
  
  attr_protected :id, :status, :updated_at, :created_at
  attr_accessor :captcha_validated, :cart

  has_many :order_items
  has_many :items, :through => :order_items

  delegate :sum_amount, :to => :order_items, :prefix => true
  delegate :total, :to => :order_items

  set_inheritance_column "status"

  self.paginate_options = { :per_page => 14 }

  class_inheritable_accessor :status_nav, :status_, :blank, :show_tag
    
  self.status_nav = ""
  self.status_ = ""
  self.show_tag = Order.underscore

  cattr_accessor :partial_path
  self.partial_path = tableize

  scope :index_scope, order( "created_at desc" )

  extend ReplaceContent      

  def status_tag() "order_status_#{id}" end
  def updated_tag() "order_updated_#{id}" end
  def close_tag() "close_order_#{id}" end
  def row_tag() tag end
    
# notices
  def destroy_notice
    "#{Order.human} № #{id} #{Order.human_attribute_name( :destroy_notice )}."
  end

# renders
  def render_destroy( page, *args )
    super
    page.update_processed_orders_amount
  end 

  def delete_title() "#{I18n.t(:remove)} #{Order.human} № #{id}" end       
       
end
