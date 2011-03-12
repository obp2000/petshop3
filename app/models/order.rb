# encoding: utf-8
class Order < ActiveRecord1
  attr_protected :id, :status, :updated_at, :created_at
  attr_accessor :captcha_validated, :cart

  has_many :order_items
  has_many :items, :through => :order_items

  delegate :sum_amount, :to => :order_items, :prefix => true
  delegate :total, :to => :order_items

  set_inheritance_column "status"

  self.class_name_rus = "заказ"  
  self.class_name_rus_cap = "Заказ"
  self.updated_at_rus = "Закрыт"
  self.paginate_options = { :per_page => 14 }

  class_inheritable_accessor :id_rus, :status_header_rus, :total_rus, :count_rus, :email_rus, :phone_number_rus,
    :ship_to_first_name_rus, :ship_to_city_rus, :ship_to_address_rus, :comments_rus, :details_title,
    :status_eng, :status_rus_nav, :status_rus, :blank
    
  self.id_rus = "№"
  self.status_header_rus = "Статус"
  self.total_rus = "Сумма"    
  self.count_rus = "Всего"    
  self.email_rus = "Адрес электронной почты"
  self.phone_number_rus = "Контактный телефон"    
  self.ship_to_first_name_rus = "Имя"    
  self.ship_to_city_rus = "Город"    
  self.ship_to_address_rus = "Адрес"    
  self.comments_rus = "Комментарии к #{class_name_rus}у"    
  self.details_title = "Детали #{class_name_rus}а"
  self.status_eng = ""
  self.status_rus_nav = ""
  self.status_rus = ""
  self.blank = ""

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
    
    def index_page_title_for( params ); "Список #{class_name_rus}ов" + params[ :controller ].classify.constantize.status_rus_nav end
  
    def headers
      [ "id_rus", "status_header_rus", "total_rus", "count_rus", "created_at_rus", "updated_at_rus", "blank" ]
    end

#tags and partials
    attr_accessor_with_default( :show_tag ) { "order_details" }
#    attr_accessor_with_default( :partial_path ) { "orders" }    
  
  end

# notices
  def set_destroy_notice( flash ); flash.now[ :notice ] = "#{class_name_rus_cap} № #{id} успешно удалён." end

# renders
  def render_destroy( page, session )
    super
    page.update_processed_orders_amount ProcessedOrder.update_amount
  end 

  def closed_at_or_link_to_close( page ); closed? ? page.date_time_rus( updated_at ) : page.link_to_close( self ) end
       
end
