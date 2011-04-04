require 'spec_helper'

class Cart; end  
  
describe CartsController do
  
  before do
    @cart = carts_proxy.first
  end

  describe "DELETE destroy" do
    it "clears the requested cart and renders destroy template" do
      @cart.class.should_receive( :current_object ).with(
        { "controller" => "carts", "action" => "destroy" }, session.cart ).and_return( @cart )      
      @cart.should_receive( :destroy_object )
      @cart.stub( :destroy_notice ).and_return( "Test" )      
      @cart.should_receive( :render_destroy )            
      xhr :delete, :destroy
      assigns[ :object ].should == @cart
      flash.now[ :notice ].should == @cart.destroy_notice       
    end
  end

end
