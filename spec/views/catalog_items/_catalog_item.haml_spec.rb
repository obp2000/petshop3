require 'spec_helper'

describe "catalog_items/_catalog_item" do

  before do
    @catalog_item = catalog_items_proxy.first
#    view.stub( :link_to_show ).with( @catalog_item ).and_return( link_to_remote @catalog_item.name,
#            :url => catalog_item_path( @catalog_item ), :method => :get )    
    @size = sizes_proxy.first
    @colour = colours_proxy.first
  end
  
  it "renders only one existing catalog item" do
    view.should_receive( :render ).with( :partial => "shared/photo", :collection => @catalog_item.photos )
    view.should_receive( :render ).with( :partial => "catalog_items/attr_with_any",
              :locals => { :object => @catalog_item, :attr => "size" } )
    view.should_receive( :render ).with( :partial => "catalog_items/attr_with_any",
              :locals => { :object => @catalog_item, :attr => "colour" } )
    view.should_receive( :link_to_show ).with( @catalog_item ).and_return( link_to_remote @catalog_item.name,
              :url => catalog_item_path( @catalog_item ), :method => :get )                
    render :locals => { :catalog_item => @catalog_item }
    rendered.should have_link_to_remote_get( catalog_item_path( @catalog_item ) ) do |a|
      a.should contain( @catalog_item.name  )      
    end
    rendered.should contain( @catalog_item.price.to_s )
#    rendered.should contain( @catalog_item.name )
    rendered.should have_selector( "form", :method => "post", :action => cart_item_path(@catalog_item) ) do |form|
      form.should have_image_input
    end
    rendered.should contain( @catalog_item.blurb )
  end

end
