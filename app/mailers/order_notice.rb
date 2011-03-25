# encoding: utf-8
class OrderNotice < ActionMailer::Base
  
  def order_notice( order )
    setup_email( order )
    subject      Order.human_attribute_name( :subject ).html_safe + " #{order.id}"
  end 
  
  protected
  
  def setup_email( order )
    recipients   order.email
    from         "obp2000@mail.ru"
    body         :order => order
  end

end
