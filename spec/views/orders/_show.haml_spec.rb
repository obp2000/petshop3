require 'spec_helper'

describe "orders/_show" do

  before do
    assign( :object, @order = orders_proxy.first )
  end
  
  it "renders existing order details" do
#    view.should_receive( :render ).with( :partial => "order_item", :collection => assigns[ :object ].order_items )    
    render "orders/show"
    rendered.should contain( @order.to_param )
    rendered.should contain( @order.ship_to_first_name )   
    rendered.should contain( @order.email )
    rendered.should contain( @order.phone_number )
    rendered.should contain( @order.ship_to_city )
    rendered.should contain( @order.ship_to_address )
    rendered.should contain( @order.comments )    
  end

end
