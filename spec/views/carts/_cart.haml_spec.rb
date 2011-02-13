require 'spec_helper'

def Cart; end

describe "carts/_cart" do

  before do
    @session = {}
    @session.stub( :cart ).and_return( carts_proxy.first )
  end
  
  it "renders cart totals" do
    render :partial => "carts/cart", :locals => { :session => @session }
    rendered.should contain( @session.cart.total_items.to_s )
    rendered.should contain( @session.cart.total.to_s )
  end

  context "when user can make order and clear cart" do
    it "renders link to new order form" do
      view.stub( :do_not_show ).and_return( false )      
      render :partial => "carts/cart", :locals => { :session => @session }      
      rendered.should have_link_to_remote_get( new_processed_order_path )
      rendered.should have_link_to_remote_delete( cart_path )
    end    
  end

  context "when user can not make order and clear cart" do
    it "does not render link to new order form" do
      view.stub( :do_not_show ).and_return( true )      
      render :partial => "carts/cart", :locals => { :session => @session }
      rendered.should_not have_link_to_remote_get( new_processed_order_path )
      rendered.should_not have_link_to_remote_delete( cart_path )
    end    
  end

end
