require 'spec_helper'

class CartItem; end

describe "cart_items/_cart_item" do

  before do
    @cart_item = cart_items_proxy.first
    @cart_item.catalog_item.stub( :link_to_show ).and_return( link_to @cart_item.name,
            catalog_item_path( @cart_item.catalog_item ), :method => :get, :remote => true )
    @cart_item.stub( :link_to_delete ).and_return( link_to "Test", @cart_item,
            :method => :delete, :remote => true )             
  end
  
  it "renders cart item" do
    render "cart_items/cart_item",  :cart_item => @cart_item
    rendered.should have_link_to_remote_get( catalog_item_path(@cart_item.catalog_item) ) do |a|
      a.should contain( @cart_item.name )
    end
    rendered.should contain( @cart_item.size.name )
    rendered.should have_colour( @cart_item.colour.html_code )    
    rendered.should contain( @cart_item.price.to_s )
    rendered.should contain( @cart_item.amount.to_s )
  end

  context "when user can delete cart item" do
    it "renders delete button" do
      view.stub( :do_not_show ).and_return( false )      
      render "cart_items/cart_item", :cart_item => @cart_item
      rendered.should have_selector( "a", :href => cart_item_path( @cart_item ), "data-method" => "delete" )       
    end    
  end
  
  context "when user can not delete cart item" do
    it "does not render delete button" do
      view.stub( :do_not_show ).and_return( true )      
      render "cart_items/cart_item", :cart_item => @cart_item
      rendered.should_not have_selector( "a", :href => cart_item_path( @cart_item ), "data-method" => "delete" )         
    end    
  end  

end
