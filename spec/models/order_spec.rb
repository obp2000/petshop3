require 'spec_helper'

describe Order do

  describe "#destroy_object" do
  
    before do
      @params = { "order" => valid_order_attributes }
      @session = {}
    end
  
    it "destroys existing order" do
      @order = Order.new_object( @params )
      @order.save_object( @session ) 
      @params_for_destroy = { :id => @order.id }
      @order = Order.current_object( @params_for_destroy, @session.cart )
      @order.destroy_object
      @order.email.should == valid_order_attributes[ :email ]
      Order.all.should_not include( @order )
    end
  
  end

end
