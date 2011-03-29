require 'spec_helper'
  
describe ProcessedOrdersController do
  
  before do
    @object = processed_orders_proxy.first
    controller.stub(:current_user).and_return( users_proxy.first )    
  end

  it_should_behave_like "object"  
 
  describe "GET close" do
    it "closes the requested order and renders close template" do
      @object.class.should_receive( :find ).with( @object.to_param ).and_return( @object )      
      @object.should_receive( :close_object )      
      @object.stub( :close_notice ).and_return( "Test" )
      @object.should_receive( :render_close )       
      xhr :get, :close, :id => @object.to_param
      assigns[ :object ].should equal( @object )      
      flash.now[ :notice ].should == @object.close_notice 
    end
  end 
 
end
