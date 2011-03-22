# encoding: utf-8
class ProcessedOrder < Order

  self.new_image = [ "tick_16.png" ]
  self.new_text = human_attribute_name( :new_text )   
  self.edit_partial = "form"
  
  class_inheritable_accessor :close_image, :captcha_text, :fade_duration,
        :close_render_block, :update_amount, :processed_orders_amount_dom_id
  self.close_image = [ "page_table_close.png", { :title => human_attribute_name( :close_title ) } ]
  self.captcha_text = human_attribute_name( :captcha_text )
  self.fade_duration = 20
  self.close_render_block = lambda { render :template => "shared/close.rjs" }
  self.status_nav = human_attribute_name( :status_nav )
  self.status_ = human_attribute_name( :status_ )
  self.processed_orders_amount_dom_id = "processed_orders_amount"
  self.new_tag = ContentTag

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_length_of :ship_to_first_name, :minimum => 2 
  validates_length_of :phone_number, :minimum => 7     
    
  validate :must_have_valid_captcha, :cart_must_have_cart_items

  def must_have_valid_captcha
    errors.add :base, self.class.human_attribute_name( :must_have_valid_captcha ) unless captcha_validated    
  end
    
  def cart_must_have_cart_items
    errors.add :base,
      self.class.human_attribute_name( :cart_must_have_cart_items ) unless cart.cart_items.size > 0    
  end
    
  class << self

# actions    
    def close_object( params, session, flash )
      find_current_object( params, session ).tap do |result|
        result.close_object
        flash.now[ :notice ] = result.set_close_notice
      end
    end

# partials
    attr_accessor_with_default( :update_amount ) { [ :replace_html, "processed_orders_amount", count ] }
           
  end

  attr_accessor_with_default( :change_to_closed ) {
        [ :replace_html, status_tag, ClosedOrder.human_attribute_name( :status_ ) ] } 

# actions  
  def save_object( session, flash )
    self.captcha_validated = session[ :captcha_validated ]
    self.cart = session.cart
    if save && transaction { populate_order( self.cart ); self.cart.clear_cart }
      flash.now[ :notice ] = set_create_notice
      OrderNotice.deliver_order_notice( self )
    end
  end     
  
  def close_object; self.status = ClosedOrder.name; save( :validate => false ) end

  def populate_order( cart )
    cart.cart_items.each { |cart_item| order_items.build( cart_item.populate_order_item_hash ) }
    save
  end

# notices
  def set_close_notice
    "#{Order.model_name.human} № #{id} #{self.class.human_attribute_name( :close_notice )}."
  end

  def set_create_notice
    "<h3>Спасибо за заказ!</h3><br />В ближайшее время наши менеджеры свяжутся с Вами.<br />
     На адрес Вашей электронной почты отправлено информационное сообщение.<br />
     В случае необходимости используйте <b>номер заказа #{id}.</b>".html_safe
  end

# links
  def link_to_close( page )
      [ page.image_tag( *close_image ), page.send( "close_#{to_underscore}_path", self ),
      { :remote => true, :id => close_tag,
        :confirm => self.class.human_attribute_name( :close_confirm ) } ]            
  end

# renders
  def render_close( page )
    page.render_close change_to_closed, change_close_tag_to_updated_tag( page ), update_amount
  end

  def render_new_or_edit( page ); super; page.new_processed_order end

  def render_create_or_update( page, session ); page.create_processed_order fade_duration end 

  def change_close_tag_to_updated_tag( page )
    [ :replace_html, updated_tag, page.l( updated_at, :format => :long ) ]
  end
      
  def closed?; false end
      
end
