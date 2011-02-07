require 'spec_helper'

describe "shared/_size" do

  before do
    @size = items_proxy.first.sizes.first
  end
  
  it "renders size name" do
    render :locals => { :size => @size }
    rendered.should contain( @size.name )   
  end

end
