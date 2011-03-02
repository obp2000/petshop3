class ProcessedOrdersController < OrdersController

  validates_captcha

  def create
    super captcha_validated?
  end
  
end
