require 'spec_helper'

class CatalogItem; end

describe "catalog_items/_show" do

  before do
    @catalog_item = catalog_items_proxy.first
    assign( :object, @catalog_item )    
  end
  
  it "shows only one existing catalog item's details" do
    view.should_receive( :link_to_back1 )            
    render
    rendered.should contain( @catalog_item.name )
    rendered.should contain( @catalog_item.price.to_s )
    rendered.should contain( @catalog_item.category.name )
    rendered.should contain( @catalog_item.type.constantize.season_name )
    rendered.should have_selector( "form", :method => "post", :action => cart_item_path(@catalog_item) ) do |form|
      form.should have_image_input
    end
    rendered.should contain( @catalog_item.sizes.first.name )
    rendered.should have_colour( @catalog_item.colours.first.html_code ) 
    rendered.should have_selector( "input", :type => "radio" )    
    rendered.should contain( @catalog_item.blurb )
    rendered.should have_selector( "img[src*=" + @catalog_item.photos.first.photo_url[0..-5] + "]" )
    rendered.should contain( @catalog_item.photos.first.comment )      
  end

end
