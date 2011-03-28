class ProcessedOrdersController < OrdersController
before_filter :set_captcha, :only => :create

  validates_captcha
  
  private
    def set_captcha
      session[ :captcha_validated ] = captcha_validated?       
    end
  
end
