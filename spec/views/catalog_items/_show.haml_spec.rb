require 'spec_helper'

class CatalogItem; end

describe "catalog_items/_show" do

  before do
    @object = catalog_items_proxy.first     
    @photo = @object.photos.first
    @photo.stub( :underscore ).and_return( "photo" )    
    @object.stub_chain( :sizes, :class_name_rus_cap ).and_return( "Размер" )
    @object.stub_chain( :colours, :class_name_rus_cap ).and_return( "Цвет" )
    @object.stub_chain( :season, :name ).and_return( "Весна/Лето" )
    @object.sizes.first.stub( :underscore ).and_return( "size" )
    @object.sizes.second.stub( :underscore ).and_return( "size" )
    @object.colours.first.stub( :underscore ).and_return( "colour" )
    @object.colours.second.stub( :underscore ).and_return( "colour" )    
    assign( :object, @object )
  end
  
  it "shows only one existing catalog item's details" do
    view.should_receive( :link_to_back )            
    render
    rendered.should contain( @object.name )
    rendered.should contain( @object.price.to_s )
    rendered.should contain( @object.category.name )
    rendered.should contain( @object.season.name )    
    rendered.should have_selector( "form", :method => "post", :action => cart_item_path( @object ) ) do |form|
      form.should have_image_input
    end
    rendered.should contain( @object.blurb )
    rendered.should have_selector( "img[src*=" + @object.photos.first.photo_url[0..-5] + "]" )
    rendered.should contain( @object.photos.first.comment )      
  end

  it_should_behave_like "sizes and colours of catalog item"

end
