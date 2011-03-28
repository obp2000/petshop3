require 'spec_helper'

class Cart; end  
  
describe CartsController do
  
  before do
    @cart = carts_proxy.first
  end

  describe "DELETE destroy" do
    it "clears the requested cart and renders destroy template" do
      @cart.class.should_receive( :find_current_object ).with(
        { "controller" => "carts", "action" => "destroy" }, session ).and_return( @cart )      
      @cart.should_receive( :destroy_object ).and_return( @destroyed_objects = @cart.cart_items )
      @cart.stub( :destroy_notice ).and_return( "Test" )      
      @destroyed_objects.should_receive( :render_destroy )            
      xhr :delete, :destroy
      assigns[ :destroyed_objects ].should == @destroyed_objects
      flash.now[ :notice ].should == @cart.destroy_notice       
    end
  end

end
