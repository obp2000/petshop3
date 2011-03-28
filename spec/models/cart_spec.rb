require 'spec_helper'

describe Cart do

  before do
    create_cart_item
  end

  describe "#destroy_object" do

    before do
      @cart_item = CartItem.find_current_object( @params, @session )
      @cart_item.update_object( @params )       
    end
    
    it "deletes all cart items" do
      @session.cart.cart_items.first.amount.should == 2
      @cart = Cart.find_current_object( @params, @session )
      @cart.destroy_object
      @session.cart.cart_items.count.should == 0
    end
  
  end

end
