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
  self.headers = [ "№", I18n.t( :status ), I18n.t( :sum ), I18n.t( :count ),
          I18n.t( :created_at ), I18n.t( :updated_at ), "" ]

  cattr_accessor :row_partial, :partial_path
  self.row_partial = name.underscore  
  self.partial_path = name.tableize

  attr_accessor_with_default( :status_tag ) { "order_status_#{id}" }
  attr_accessor_with_default( :updated_tag ) { "order_updated_#{id}" }
  attr_accessor_with_default( :close_tag ) { "close_order_#{id}" }

  scope :index_scope, order( "created_at desc" )

  class << self
# tags
    include ReplaceContent      
    
    def index_page_title_for( params )
      "#{human_attribute_name(:index_page_title)}" + params[ :controller ].classify.constantize.status_nav
    end

  end

# notices
  def set_destroy_notice
    "#{self.class.model_name.human} № #{id} #{Order.human_attribute_name( :destroy_notice )}."
  end

# renders
  def render_destroy( page, session )
    super
    page.update_processed_orders_amount ProcessedOrder.update_amount
  end 

#  def closed_at_or_link_to_close( page ); closed? ? page.date_time_rus( updated_at ) : page.link_to_close( self ) end
       
end
