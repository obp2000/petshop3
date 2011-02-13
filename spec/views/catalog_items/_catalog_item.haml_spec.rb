require 'spec_helper'

describe "catalog_items/_catalog_item" do

  before do
    @catalog_item = catalog_items_proxy.first
    view.stub( :link_to_show ).with( @catalog_item ).and_return( link_to @catalog_item.name,
            @catalog_item, :remote => true, :method => :get )    
    @size = sizes_proxy.first
    @colour = colours_proxy.first
  end
  
  it "renders only one existing catalog item" do
    render "catalog_items/catalog_item", :catalog_item => @catalog_item
    rendered.should have_link_to_remote_get( catalog_item_path( @catalog_item ) ) do |a|
      a.should contain( @catalog_item.name  )      
    end
    rendered.should contain( @catalog_item.price.to_s )
    rendered.should have_selector( "form", :method => "post", :action => cart_item_path(@catalog_item) ) do |form|
      form.should have_image_input
    end
    rendered.should contain( @catalog_item.sizes.first.name )
    rendered.should have_colour( @catalog_item.colours.first.html_code ) 
    rendered.should have_selector( "input", :type => "radio" )
    rendered.should contain( @catalog_item.blurb )
  end

end
