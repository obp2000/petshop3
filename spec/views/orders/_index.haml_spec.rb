require 'spec_helper'

describe "orders/_index" do

  before do
    assign( :objects, @orders = orders_proxy )
    ProcessedOrder.stub( :count ).and_return( 10 )    
  end
  
  it "renders navigation links" do
    view.should_receive( :index_page_title_for ).with( Order )
    view.should_receive( :will_paginate ).with( @orders )
#    view.should_receive(:render).with( :partial => "orders/order", :collection => assigns[ :objects ] )
    render
    rendered.should have_link_to_remote_get( orders_path )
    rendered.should have_link_to_remote_get( processed_orders_path )
    rendered.should have_link_to_remote_get( closed_orders_path )        
    rendered.should contain( ProcessedOrder.count.to_s )    
  end

end
