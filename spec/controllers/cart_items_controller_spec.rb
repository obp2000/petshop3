require 'spec_helper'

class CartItem; end
  
describe CartItemsController do
  
  before do
    @cart_item = cart_items_proxy.first
  end

  describe "PUT update" do
    it "adds the requested cart item to cart and renders create_or_update template" do
      @cart_item.class.should_receive( :object_for_update ).with(
        { "controller" => "cart_items", "action" => "update",
        "id" => @cart_item.id }, session.cart ).and_return( @cart_item )      
      @cart_item.should_receive( :update_object ).and_return( true )
      @cart_item.stub( :update_notice ).and_return( "Test" )       
      @cart_item.should_receive( :render_create_or_update )      
      xhr :put, :update, :id => @cart_item.id
      assigns[ :object ].should == @cart_item      
      flash.now[ :notice ].should == @cart_item.update_notice 
    end
  end

  describe "DELETE destroy" do
    it "deletes the requested cart item from cart and renders create_or_update template" do
      @cart_item.class.should_receive( :current_object ).with(
        { "controller" => "cart_items", "action" => "destroy",
        "id" => @cart_item.id }, session.cart ).and_return( @cart_item )
      @cart_item.should_receive( :destroy_object )
      @cart_item.stub( :destroy_notice ).and_return( "Test" )      
      @cart_item.should_receive( :render_destroy )         
      xhr :delete, :destroy, :id => @cart_item.id
      assigns[:object].should == @cart_item      
      flash.now[ :notice ].should == @cart_item.destroy_notice
    end
  end

end
