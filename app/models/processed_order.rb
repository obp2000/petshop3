# encoding: utf-8
class ProcessedOrder < Order
  
  class_inheritable_accessor :fade_duration, :edit_partial, :new_tag
  self.fade_duration = 20
  self.status_nav = human_attribute_name( :status_nav )
  self.status_ = human_attribute_name( :status_ )
  self.new_tag = ContentTag
  self.edit_partial = "form"

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_length_of :ship_to_first_name, :minimum => 2 
  validates_length_of :phone_number, :minimum => 7     
    
  validate :must_have_valid_captcha, :cart_must_have_cart_items

  def must_have_valid_captcha
    errors.add :base, human_attribute_name( :must_have_valid_captcha ) unless captcha_validated    
  end
    
  def cart_must_have_cart_items
    errors.add :base,
      human_attribute_name( :cart_must_have_cart_items ) unless cart.cart_items.size > 0    
  end

  def closed?() false end

# actions  
  def save_object( session )
    self.captcha_validated = session[ :captcha_validated ]
    self.cart = session.cart
    if save && self.cart.populate_order_and_clear_cart( self )
      OrderNotice.deliver_order_notice( self )
    end
  end     
  
  def close_object
    self.status = ClosedOrder.name
    save( :validate => false )
  end

  def populate_order_item( cart_item )
    order_items.populate_order_item( cart_item )
  end

# notices
  def close_notice() "#{Order.human} № #{id} #{human_attribute_name( :close_notice )}." end

  def create_notice() human_attribute_name( :create_notice ).html_safe + " #{id}." end

# renders
  def render_close( page ) page.render_close( self ) end

  def render_new_or_edit( page, cart )
    super
    page.new_processed_order( cart )
  end

  def render_create_or_update( page, cart )
    page.render_create_processed_order( fade_duration )
  end 
      
end
