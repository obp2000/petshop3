require 'spec_helper'

class CatalogItem; end

describe "catalog_items/_show" do

  before do
    assigns[:object] = catalog_items_proxy.first
  end
  
  it "shows only one existing catalog item's details" do
    view.should_receive( :link_to_back )            
    view.should_receive(:render).with( :partial => "catalog_items/photo",
              :collection => assigns[:object].photos )
    view.should_receive( :render ).with( :partial => "catalog_items/attr_with_any",
              :locals => { :object => assigns[:object], :attr => "size" } )
    view.should_receive( :render ).with( :partial => "catalog_items/attr_with_any",
              :locals => { :object => assigns[:object], :attr => "colour" } )                              
    render
    rendered.should contain( assigns[:object].name )
    rendered.should contain( assigns[:object].price.to_s )
    rendered.should contain( assigns[:object].category.name )
    rendered.should contain( assigns[:object].type.constantize.season_name )
    rendered.should have_selector( "form", :method => "post", :action => cart_item_path(assigns[:object]) ) do |form|
      form.should have_image_input
    end
    rendered.should contain( assigns[:object].blurb )
  end

end
