require 'spec_helper'

describe "order_notice/order_notice" do

  before do
    assigns[ :order ] = orders_proxy.first
  end
  
  it "renders order notice" do
    view.should_receive( :render ).with( :partial => "order_notice/order_item", :collection => assigns[ :order ].order_items )
    render
    rendered.should contain( assigns[ :order ].ship_to_first_name )
    rendered.should contain( assigns[ :order ].to_param )
    rendered.should contain( assigns[ :order ].total.to_s )  
  end

end
