require 'spec_helper'

#class ProcessedOrder; end  
  
describe ProcessedOrdersController do
  
  before do
    @object = processed_orders_proxy.first
    controller.stub(:current_user).and_return( users_proxy.first )    
  end

  it_should_behave_like "object"  
 
  describe "GET close" do
    it "closes the requested order and renders close template" do
      @object.class.should_receive( :close_object ).with( { "action" => "close", "id" => @object.to_param,
                          "controller" => @object.class.name.tableize }, { "flash" => {} }, {} ).and_return( @object )
      xhr :get, :close, :id => @object.to_param
      assigns[ :object ].should equal( @object )
      response.should render_template( "shared/close" )
    end
  end 
 
end
