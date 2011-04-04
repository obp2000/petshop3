require 'spec_helper'

describe ProcessedOrder do
  
  before do
    @valid_attributes = valid_order_attributes
    @order = ProcessedOrder.new( @valid_attributes )
    @cart = {}.cart
    @cart.cart_items.create
    @order.cart = @cart
    @session = {}
    @item = Item.create!( valid_item_attributes )
    @params = valid_item_attributes
    @params[ :id ] = "catalog_item_" + @item.id.to_s
    OrderNotice.stub( :deliver_order_notice ).and_return( true )
    @session[ :captcha_validated ] = true      
    @cart_item = CartItem.object_for_update( @params, @session.cart )
    @cart_item.update_object( @params )
  end

  it "is valid with valid attributes" do
    @order.should be_valid
  end

  it "is not valid without a valid name" do
    @order.ship_to_first_name = "N"
    @order.should_not be_valid
  end

  it "is not valid without a valid phone number" do
    @order.phone_number = "1"
    @order.should_not be_valid
  end  
  
  it "is not valid without a valid email" do
    @order.email = "info@m"
    @order.should_not be_valid
  end    
  
  it "is not valid without a valid captcha" do
    @order.captcha_validated = false
    @order.should_not be_valid
  end    

  it "is not valid with empty cart" do
    @order.cart.cart_items.clear
    @order.should_not be_valid
  end 

  describe "#new_object" do
  
    before do
      @params = { "processed_order" => valid_processed_order_attributes }
    end
  
    it "builds new processed order" do
      @order = ProcessedOrder.new_object( @params )
      @order.email.should == valid_processed_order_attributes[ :email ]
    end
  
  end

  describe "#save_object" do
  
    it "saves new processed order" do
      @params = { "processed_order" => valid_processed_order_attributes }
      @order = ProcessedOrder.new_object( @params )
      OrderNotice.should_receive( :deliver_order_notice ).with( @order )
      @order.save_object( @session )
      @order.email.should == valid_processed_order_attributes[ :email ]
      @order.order_items.first.price.should == @item.price
    end
  
  end 

  describe "#close_object" do
  
    it "closes processed order" do
      @params = { "processed_order" => valid_processed_order_attributes }
      @order = ProcessedOrder.new_object( @params )
      @order.save_object( @session )
      @params_for_close = { :id => @order.id }
      @order = ProcessedOrder.current_object( @params_for_close, @session.cart )
      @order.close_object
      @order.email.should == valid_processed_order_attributes[ :email ]
      ProcessedOrder.all.should_not include( @order )
      @order.status.should == "ClosedOrder"
    end
  
  end

end
