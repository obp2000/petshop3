# encoding: utf-8
class ProcessedOrder < Order

  self.class_name_rus_cap = "Заказ для исполнения"
  self.replace = :replace_html
  self.new_image = [ "tick_16.png" ]
  self.new_text = "Оформить #{class_name_rus}"   
  self.submit_with_options = [ "submit_tag", "Разместить #{class_name_rus}", { :onclick => "$(this).fadeOut().fadeIn()" } ]
  
  class_inheritable_accessor :close_image, :close_confirm, :captcha_text, :fade_duration,
        :close_render_block, :update_amount

  self.close_image = [ "page_table_close.png", { :title => "Закрыть #{class_name_rus}" } ]
  self.close_confirm = "Закрыть #{class_name_rus}?"
  self.captcha_text = "Введите, пожалуйста, проверочный код:"
  self.fade_duration = 20
  self.close_render_block = lambda { render :template => "shared/close.rjs" }
  self.status_eng = "ProcessedOrder"
  self.status_rus_nav = " со статусом \"для исполнения\""
  self.status_rus = "для исп."

  attr_accessor_with_default( :new_or_edit_tag ) { "content" }
  attr_accessor_with_default( :change_to_closed ) { [ :replace_html, status_tag, ClosedOrder.status_rus ] }  
    
  validate :must_have_ship_to_first_name, :must_have_long_phone_number, :must_have_valid_email, :must_have_valid_captcha,
        :cart_must_have_cart_items
  
  def must_have_ship_to_first_name
    errors.add :base, "#{ship_to_first_name_rus} слишком короткое (минимум 2 буквы)" if ship_to_first_name.size < 2     
  end
    
  def must_have_long_phone_number
    errors.add :base, "Номер телефона слишком короткий (минимум 7 цифр)" if phone_number.size < 7     
  end

  def must_have_valid_captcha
    errors.add :base, "Проверочный код неверен" unless captcha_validated    
  end
    
  def cart_must_have_cart_items
    errors.add :base, "#{Cart.class_name_rus_cap} пустая" unless cart.cart_items.size > 0    
  end
    
  class << self

# actions    
    def close_object( params, session, flash )
      find_current_object( params, session ).tap { |result| result.set_close_notice( flash ); result.close_object }
    end

# partials
    attr_accessor_with_default( :new_or_edit_partial ) { "new" }   

    attr_accessor_with_default( :update_amount ) { [ :replace_html, "processed_orders_amount", count ] }

    attr_accessor_with_default( :new_page_title_for ) { "Оформление #{class_name_rus}а" }
           
  end

# actions  
  def save_object( session, flash )
    self.captcha_validated = session[ :captcha_validated ]
    self.cart = session.cart
    save && populate_order( self.cart ) && self.cart.clear_cart && set_create_notice( flash ) &&
            OrderNotice.deliver_order_notice( self )
  end     
  
  def close_object; self.status = ClosedOrder.status_eng; save( :validate => false ) end

  def populate_order( cart )
    cart.cart_items.each { |cart_item| order_items.build( cart_item.populate_order_item_hash ) }
    save
  end

# notices
  def set_close_notice( flash ); flash.now[ :notice ] = "#{Order.class_name_rus_cap} № #{id} успешно закрыт." end

  def set_create_notice( flash )
    flash.now[ :notice ] =
            "<h3>Спасибо за заказ!</h3><br />В ближайшее время наши менеджеры свяжутся с Вами.<br />
            На адрес Вашей электронной почты отправлено информационное сообщение.<br />
            В случае необходимости используйте <b>номер #{class_name_rus}а #{id}.</b>".html_safe
  end

# links
  def link_to_close( page )
    page.link_to_remote2 close_image, "", page.send( "close_#{to_underscore}_path", self ), :id => close_tag,
            :confirm => close_confirm
  end

# renders
  def render_close( page )
    page.render_close change_to_closed, change_close_tag_to_updated_tag( page ), update_amount
  end

  def render_new_or_edit( page ); super; page.new_processed_order end

  def render_create_or_update( page, session ); page.create_processed_order fade_duration end 

  def change_close_tag_to_updated_tag( page ); [ :replace_html, updated_tag, page.date_time_rus( updated_at ) ] end
      
  def closed?; false end
      
end
