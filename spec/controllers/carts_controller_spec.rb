require 'spec_helper'

class Cart; end  
  
describe CartsController do
  
  before do
    @cart = carts_proxy.first
  end

  describe "DELETE destroy" do
    it "clears the requested cart and renders destroy template" do
      Cart.should_receive( :destroy_object ).and_return( @cart.cart_items )
      xhr :delete, :destroy
      assigns[ :object ].should == @cart.cart_items      
      response.should render_template( "shared/destroy" )
    end

  end

end
