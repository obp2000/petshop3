require 'spec_helper'

describe "orders/_show" do

  before do
    assign( :object, @order = orders_proxy.first )
    @order_item = @order.order_items.first
    @order_item.stub( :link_to_show ).and_return( link_to @order_item.name,
            item_path( @order_item.item ), :remote => true, :method => :get )      
  end
  
  it "renders existing order details with one order item" do
    render
    rendered.should contain( @order.to_param )
    rendered.should contain( @order.ship_to_first_name )   
    rendered.should contain( @order.email )
    rendered.should contain( @order.phone_number )
    rendered.should contain( @order.ship_to_city )
    rendered.should contain( @order.ship_to_address )
    rendered.should contain( @order.comments )
    rendered.should have_link_to_remote_get( item_path( @order_item.item ) ) do |a|
      a.should contain( @order_item.name )      
    end
    rendered.should contain(@order_item.size.name)
    rendered.should have_colour(@order_item.colour.html_code)    
    rendered.should contain(@order_item.amount.to_s)
    rendered.should contain( roubles @order_item.order_item_sum.to_s )    
  end

end
