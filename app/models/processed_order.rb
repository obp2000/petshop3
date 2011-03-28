# encoding: utf-8
class ProcessedOrder < Order
  
  self.edit_partial = "form"
  
  class_inheritable_accessor :fade_duration, :processed_orders_amount_dom_id, :update_amount
  self.fade_duration = 20
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

# partials
    def update_amount
      [ :replace_html, "processed_orders_amount", count ]
    end
           
  end

  def closed?; false end

# actions  
  def save_object( session )
    self.captcha_validated = session[ :captcha_validated ]
    self.cart = session.cart
    if save && transaction { populate_order( self.cart ); self.cart.clear_cart }
      OrderNotice.deliver_order_notice( self )
    end
  end     
  
  def close_object
    self.status = ClosedOrder.name
    save( :validate => false )
  end

  def populate_order( cart )
    cart.cart_items.each { |cart_item| order_items.build( cart_item.populate_order_item_hash ) }
    save
  end

# notices
  def close_notice
    "#{Order.model_name.human} № #{id} #{self.class.human_attribute_name( :close_notice )}."
  end

  def create_notice
    self.class.human_attribute_name( :create_notice ).html_safe + " #{id}."
  end

# renders
  def render_close( page )
    page.render_close( change_to_closed, change_close_tag_to_updated_tag, update_amount )
  end

  def render_new_or_edit( page, session, controller_name )
    super
    page.new_processed_order( session, controller_name )
  end

  def render_create_or_update( page, session, controller_name )
    page.create_processed_order( fade_duration )
  end 

  def change_to_closed
    [ :replace_html, status_tag, ClosedOrder.human_attribute_name( :status_ ) ]
  end

  def change_close_tag_to_updated_tag
    [ :replace_html, updated_tag, I18n.l( updated_at, :format => :long ) ]
  end
      
end
