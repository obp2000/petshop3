require 'spec_helper'

describe "catalog_items/_attr" do

  before do
    @attr = catalog_items_proxy.first.sizes.first
  end
    
    it "renders sizes with radio buttons" do
      view.should_receive( :radio_button_tag_for ).with( @attr, false, "visible" )
      render "catalog_items/attr", :attr => @attr, :checked => false, :visibility => "visible"
      rendered.should contain( @attr.name )
    end

end