require 'spec_helper'

describe "catalog_items/_attr" do

  before do
    @checked = true
    @visibility = "visible"
  end

  context "check existing size" do
    
    before do
      @attr = catalog_items_proxy.first.sizes.first
    end
    
    it "renders sizes with radio buttons" do
      view.should_receive( :radio_button_tag_for ).with( @attr, @checked, @visibility )
#      view.should render_partial( "shared/size" )      
      render "catalog_items/attr", :attr => @attr, :checked => @checked, :visibility => @visibility
      rendered.should contain( @attr.name )
      rendered.should_not contain( "Любой" )      
    end

  end

  context "check new size" do
    
    before do
      @attr = catalog_items_proxy.first.sizes.first.class.new
    end
    
    it "renders sizes with radio buttons" do
      render "catalog_items/attr", :attr => @attr, :checked => @checked, :visibility => @visibility
      rendered.should contain( "Любой" )
    end

  end



end