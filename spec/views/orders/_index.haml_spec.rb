require 'spec_helper'

describe "orders/_index" do

  before do
    assigns[ :objects ] = orders_proxy
  end
  
  it "renders existing order" do
    view.should_receive(:render).with( :partial => "orders/navigation" )
    view.should_receive(:will_paginate).with( assigns[ :objects ] )      
    view.should_receive(:render).with( :partial => "orders/order", :collection => assigns[ :objects ] )
    render
  end

end
