require 'spec_helper'

describe CartItem do
  
  before do
    create_cart_item
  end

  describe "#update_object" do
    
    context "when cart has no such cart item" do
      it "adds new cart item" do
        @session.cart.cart_items.should include( @cart_item )
        @cart_item.amount.should == 1
        @cart_item.name.should == @item.name
        @cart_item.price.should == @item.price             
      end
    end
    
    context "when cart has such cart item already" do
      it "increments cart item amount" do
        @cart_item = CartItem.object_for_update( @params, @session.cart )
        @cart_item.update_object( @params )        
        @session.cart.cart_items.first.amount.should == 2
      end
    end
 
  end

  describe "#destroy_object" do
    
    context "when cart has some such cart items" do
      it "deletes cart item" do
        @cart_item = CartItem.object_for_update( @params, @session.cart )
        @cart_item.update_object( @params )
        @cart_item.destroy_object
        @session.cart.cart_items.count.should == 1
        @session.cart.cart_items.first.amount.should == 1
      end
    end

    context "when cart has last such cart item" do
      it "deletes cart item" do
        @cart_item.destroy_object
        @session.cart.cart_items.count.should == 0
      end
    end  
  end

end
