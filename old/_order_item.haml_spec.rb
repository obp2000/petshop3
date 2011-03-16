require 'spec_helper'

describe "order_items/_order_item" do

  before do
    @order_item = order_items_proxy.first
    @order_item.stub( :link_to_show ).and_return( link_to @order_item.name,
            item_path( @order_item.item ), :remote => true, :method => :get )       
  end
  
  it "renders order" do
    render "order_items/order_item", :order_item => @order_item
    rendered.should have_link_to_remote_get( item_path( @order_item.item ) ) do |a|
      a.should contain( @order_item.name )      
    end
    rendered.should contain(@order_item.size.name)
    rendered.should have_colour(@order_item.colour.html_code)    
    rendered.should contain(@order_item.amount.to_s)
    rendered.should contain( roubles @order_item.order_item_sum.to_s )
  end

end
