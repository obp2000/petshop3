require 'spec_helper'

describe "orders/_order" do

  before do
    @order = orders_proxy.first
    @order.stub( :link_to_delete ).and_return( link_to "Test", @order, :remote => true, :method => :delete )
    @order.stub( :status_tag ).and_return( "order_status_#{@order.id}" )
    @order.stub( :updated_tag ).and_return( "order_updated_#{@order.id}" )    
  end
  
  it "renders order" do
    view.should_receive( :closed_at_or_link_to_close ).with( @order )
    render "orders/order", :order => @order
    rendered.should have_selector( "tr", :onclick => "$.get('#{order_path(@order)}')" )
    rendered.should contain(@order.to_param)
    rendered.should contain(@order.class.status_rus)
    rendered.should contain(@order.total.to_s)
    rendered.should contain(@order.items.size.to_s)
    rendered.should contain(@order.created_at.strftime("%d.%m.%y"))
    rendered.should contain(@order.created_at.strftime("%H:%M:%S"))
    rendered.should have_selector( "a", :href => send( "#{@order.class.name.underscore}_path", @order ),
            "data-method" => "delete" )    
  end

end
