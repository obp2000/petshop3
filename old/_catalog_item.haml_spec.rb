require 'spec_helper'

describe "catalog_items/_catalog_item" do

  before do
    @catalog_item = catalog_items_proxy.first
    @photo = @catalog_item.photos.first
  end
  
  context "when catalog item has more then one size and colour" do
    it "renders only one existing catalog item" do
      @catalog_item.should_receive( :link_to_show ).and_return( link_to @catalog_item.name,
              @catalog_item, :remote => true, :method => :get )
      @photo.should_receive( :link_to_show_with_comment ).and_return( link_to image_tag(
              @photo.photo.thumb.url ) + @photo.comment, @photo.photo_url )
      view.should_receive( :draggable_element ).with( dom_id( @catalog_item ), :revert => true )
      render "catalog_items/catalog_item", :catalog_item => @catalog_item
      rendered.should have_selector( "a[href*=" + @photo.photo_url[0..-5] + "]" ) do |a|
        a.should have_selector( "img[src*=" + @photo.photo.thumb.url + "]" )
      end
      rendered.should contain( @photo.comment )  
      rendered.should have_selector( "form", :method => "post", :action => cart_item_path(@catalog_item) ) do |form|
        form.should have_link_to_remote_get( catalog_item_path( @catalog_item ) ) do |a|
          a.should contain( @catalog_item.name  )      
        end
        form.should contain( @catalog_item.price.to_s )      
        form.should have_image_input
      end
      rendered.should contain( @catalog_item.sizes.first.name )
      rendered.should have_selector( "input", :type => "radio", :value => @catalog_item.sizes.first.to_param )    
      rendered.should contain( @catalog_item.sizes.second.name )
      rendered.should have_selector( "input", :type => "radio", :value => @catalog_item.sizes.second.to_param )    
      rendered.should have_colour( @catalog_item.colours.first.html_code )
      rendered.should have_selector( "input", :type => "radio", :value => @catalog_item.colours.first.to_param )    
      rendered.should have_colour( @catalog_item.colours.second.html_code )
      rendered.should have_selector( "input", :type => "radio", :value => @catalog_item.colours.second.to_param )    
      rendered.should contain( AnyAttr )     
      rendered.should have_selector( "input", :type => "radio", :id => "size_id_", :checked => "checked" )
      rendered.should have_selector( "input", :type => "radio", :id => "colour_id_", :checked => "checked" )      
      rendered.should contain( @catalog_item.blurb )
    end
  end

  context "when catalog item has only one size and only one colour" do
    it "do not renders 'any' size and color option" do
      @catalog_item.stub( :sizes ).and_return( [ sizes_proxy.first ] )
      @catalog_item.stub( :colours ).and_return( [ colours_proxy.first ] ) 
      render "catalog_items/catalog_item", :catalog_item => @catalog_item      
      rendered.should contain( @catalog_item.sizes.first.name )      
      rendered.should have_selector( "input", :type => "radio", :value => @catalog_item.sizes.first.to_param,
      :style => "visibility: hidden", :checked => "checked" ) 
      rendered.should have_colour( @catalog_item.colours.first.html_code )
      rendered.should have_selector( "input", :type => "radio", :value => @catalog_item.colours.first.to_param,
      :style => "visibility: hidden", :checked => "checked" )       
      rendered.should_not contain( AnyAttr )       
    end
  end

end
