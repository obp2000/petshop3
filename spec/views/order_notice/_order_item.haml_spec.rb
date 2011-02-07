require 'spec_helper'

describe "order_notice/_order_item" do

  before(:each) do
    @object = order_items_proxy.first
  end
  
  it "renders order notice" do
    render :locals => { :order_item => @object }
    rendered.should contain(@object.name)
    rendered.should contain(@object.size.name)
    rendered.should contain(@object.colour.name)    
    rendered.should contain(@object.price.to_s)
    rendered.should contain(@object.amount.to_s)    
  end

end
