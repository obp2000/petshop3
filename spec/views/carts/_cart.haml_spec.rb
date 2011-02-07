require 'spec_helper'

def Cart; end

describe "carts/_cart" do

  before do
#    view.stub( :do_not_show ).and_return( false )
    @session = { :cart => carts_proxy.first }
  end
  
  it "renders cart with only one cart item" do
#    view.should_receive( :render ).with( "carts/link_to_new_order_form" )    
#    view.should_receive( :render ).with( @session.cart.cart_items )
#    view.should_receive( :render ).with( "carts/link_to_clear_cart" )        
    render :partial => "carts/cart", :locals => { :session => @session }
    rendered.should contain( @session.cart.total_items.to_s )
    rendered.should contain( @session.cart.total.to_s )
  end

end
