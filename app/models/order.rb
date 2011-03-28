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

  class_inheritable_accessor :status_nav, :status_, :blank, :headers
    
  self.status_nav = ""
  self.status_ = ""
  self.show_tag = "order_details"

  cattr_accessor :partial_path
  self.partial_path = name.tableize

  scope :index_scope, order( "created_at desc" )

  class << self

    include ReplaceContent      

  end

  attr_accessor_with_default( :status_tag ) { "order_status_#{id}" }
  attr_accessor_with_default( :updated_tag ) { "order_updated_#{id}" }
  attr_accessor_with_default( :close_tag ) { "close_order_#{id}" }

# notices
  def destroy_notice
    "#{self.class.model_name.human} № #{id} #{Order.human_attribute_name( :destroy_notice )}."
  end

# renders
  def render_destroy( page, session, controller_name )
    super
    page.update_processed_orders_amount ProcessedOrder.update_amount
  end 
       
end
