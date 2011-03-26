require 'spec_helper'

describe "carts/_index" do

  before do
    @session = {}
    @session.stub( :cart ).and_return( carts_proxy.first )
    @cart = @session.cart
    @cart_item = @cart.cart_items.first
  end
  
  it "renders cart with one cart item" do
    render "carts/index", :cart => @cart
    rendered.should have_link_to_remote_get( new_processed_order_path )    
    rendered.should contain( @cart.total_items.to_s )
    rendered.should contain( @cart.total.to_s )
    rendered.should have_link_to_remote_get( catalog_item_path( @cart_item.catalog_item ) ) do |a|
      a.should contain( @cart_item.name )
    end
    rendered.should contain( @cart_item.size.name )
    rendered.should have_colour( @cart_item.colour.html_code )    
    rendered.should contain( @cart_item.price.to_s )
    rendered.should contain( @cart_item.amount.to_s )
    rendered.should have_selector( "a", :href => cart_item_path( @cart_item ), "data-method" => "delete" )    
    rendered.should have_link_to_remote_delete( cart_path )    
  end

#  context "when user can make order, delete cart item and clear cart" do
#    it "renders link to new order form" do
#      view.stub( :do_not_show ).and_return( false )      
#      render "carts/index", :cart => @cart      
#      rendered.should have_link_to_remote_get( new_processed_order_path )
#      rendered.should have_link_to_remote_delete( cart_path )
#      rendered.should have_selector( "a", :href => cart_item_path( @cart_item ), "data-method" => "delete" )      
#    end    
#  end
#
#  context "when user can not make order, delete cart item and clear cart" do
#    it "does not render link to new order form" do
#      view.stub( :do_not_show ).and_return( true )      
#      render "carts/index", :cart => @cart
#      rendered.should_not have_link_to_remote_get( new_processed_order_path )
#      rendered.should_not have_link_to_remote_delete( cart_path )
#      rendered.should_not have_selector( "a", :href => cart_item_path( @cart_item ), "data-method" => "delete" )       
#    end    
#  end

end
