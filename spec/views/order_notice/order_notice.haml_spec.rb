require 'spec_helper'

describe "order_notice/order_notice" do

  before do
    assign( :order, @order = orders_proxy.first )
  end
  
  it "renders order notice" do
#    view.should_receive( :render ).with( :partial => "order_notice/order_item", :collection => assigns[ :order ].order_items )
    render
    rendered.should contain( @order.ship_to_first_name )
    rendered.should contain( @order.to_param )
    rendered.should contain( @order.total.to_s )  
  end

end
