require 'spec_helper'

describe "order_notice/order_notice" do

  before do
    @order = orders_proxy.first
    @order_item = @order.order_items.first
    assign( :order, @order )
  end
  
  it "renders order notice with one order item" do
    render
    rendered.should contain( @order.ship_to_first_name )
    rendered.should contain( @order.to_param )
    rendered.should contain( @order.total.to_s )
    rendered.should contain(@order_item.name)
    rendered.should contain(@order_item.size.name)
    rendered.should contain(@order_item.colour.name)    
    rendered.should contain(@order_item.price.to_s)
    rendered.should contain(@order_item.amount.to_s)     
  end

end
