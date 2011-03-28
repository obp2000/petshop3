require 'spec_helper'

describe "orders/_index" do

  before do
    assign( :objects, @orders = orders_proxy )
    ProcessedOrder.stub( :count ).and_return( 1023 )
    @orders.stub( :show_tag ).and_return( "order_details" )
    @order = @orders.first
    @order.stub( :status_tag ).and_return( "order_status_#{@order.id}" )
    @order.stub( :updated_tag ).and_return( "order_updated_#{@order.id}" )    
    @params_controller = params[ :controller ] = "processed_orders"
  end
  
  it "renders table with one order" do
#    view.should_receive( :index_page_title_for ).with( @orders )
    view.should_receive( :will_paginate ).with( @orders )
    view.should_receive( :closed_at_or_link_to_close ).with( @order )    
    render
    rendered.should contain( @order.class.model_name.human.pluralize )
    rendered.should contain( @params_controller.classify.constantize.status_nav )    
    rendered.should have_link_to_remote_get( orders_path )
    rendered.should have_link_to_remote_get( processed_orders_path )
    rendered.should have_link_to_remote_get( closed_orders_path )        
    rendered.should contain( ProcessedOrder.count.to_s )
    rendered.should have_selector( "tr", :onclick => "$.get('#{order_path(@order)}')" )
    rendered.should contain(@order.to_param)
    rendered.should contain(@order.class.status_)
    rendered.should contain(@order.total.to_s)
    rendered.should contain(@order.items.size.to_s)
    rendered.should contain( l( @order.created_at, :format => :long ))
    rendered.should have_selector( "a", :href => send( "#{@order.class.name.underscore}_path", @order ),
            "data-method" => "delete" )     
  end

end
