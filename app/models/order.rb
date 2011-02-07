# encoding: utf-8
class Order < ActiveRecord1
  attr_protected :id, :status, :updated_at, :created_at
  attr_accessor :captcha_validated, :cart

  has_many :order_items 
  has_many :items, :through => :order_items

  delegate :total, :to => :order_items

  set_inheritance_column "status"

  self.class_name_rus = "заказ"  
  self.class_name_rus_cap = "Заказ"
  self.updated_at_rus = "Закрыт"
  self.index_partial = "orders/index"
  self.fade_tag = "item_content"
  self.appear_tag = "order_details"
  self.paginate_options = {  :order => 'created_at desc', :per_page => 14 }
  self.render_index_mode = "replace_index_partial"    

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
#  self.index_tag = "content"  

  attr_accessor_with_default( :status_tag ) { "order_status_#{id}" }
  attr_accessor_with_default( :updated_tag ) { "order_updated_#{id}" }
  attr_accessor_with_default( :close_tag ) { "close_order_#{id}" }
#  attr_accessor_with_default( :close_path ) { [ "close_#{to_underscore}_path", self ] }    

  class << self
  
# actions  
    def all_objects( params, * ); paginate_objects( params ) end

# tags
    attr_accessor_with_default( :index_tag ) { "content" }       
    
    def index_page_title_for( params ); "Список #{class_name_rus}ов" + params[ :controller ].classify.constantize.status_rus_nav end
  
    def headers
      [ "id_rus", "status_header_rus", "total_rus", "count_rus", "created_at_rus", "updated_at_rus", "blank" ]
    end
  
  end

# renders
  def render_destroy( page, session )
    super page, session
    page.update_processed_orders_amount ProcessedOrder.update_amount
  end 

  def updated_at_or_link_to_close( page ); closed? ? page.date_time_rus( updated_at ) : page.link_to_close( self ) end

# notices
  def destroy_notice( flash ); flash.now[ :notice ] = "#{class_name_rus_cap} № #{id} успешно удалён." end
       
end
