require 'spec_helper'

describe "orders/_show" do

  before(:each) do
    assigns[ :object ] = orders_proxy.first
  end
  
  it "renders existing order details" do
    view.should_receive( :render ).with( :partial => "order_item", :collection => assigns[ :object ].order_items )    
    render
    rendered.should contain( assigns[ :object ].to_param )
    rendered.should contain( assigns[ :object ].ship_to_first_name )   
    rendered.should contain( assigns[ :object ].email )
    rendered.should contain( assigns[ :object ].phone_number )
    rendered.should contain( assigns[ :object ].ship_to_city )
    rendered.should contain( assigns[ :object ].ship_to_address )
    rendered.should contain( assigns[ :object ].comments )    
  end

end
