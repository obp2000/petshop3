require 'spec_helper'

describe "catalog_items/_attrs" do

  before do
    @attrs = catalog_items_proxy.first.sizes
  end
  
  context "when catalog item has more then one size" do
    it "renders sizes and 'any' size option" do
      render "catalog_items/attrs", :attrs => @attrs
      rendered.should contain( @attrs.first.name )
      rendered.should have_selector( "input", :type => "radio", :id => "size_id_", :name => "size_id",
              :style => "visibility: visible", :checked => "checked" )
      rendered.should contain( @attrs.second.name )
      rendered.should contain( "Любой" )       
    end
  end
  
  context "when catalog item has only one size" do
    
    before do
      @attrs = [ catalog_items_proxy.first.sizes.first ]      
    end
    
    it "do not renders 'any' size option" do
      render "catalog_items/attrs", :attrs => @attrs
      rendered.should contain( @attrs.first.name )
      rendered.should_not contain( "Любой" )       
    end

  end  

end
