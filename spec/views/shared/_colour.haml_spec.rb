require 'spec_helper'

describe "shared/_colour" do

  before do
    @colour = items_proxy.first.colours.first
  end
  
  it "renders colour" do
    render :partial => "shared/colour", :locals => { :colour => @colour }
    rendered.should have_colour( @colour.html_code )    
  end

end
