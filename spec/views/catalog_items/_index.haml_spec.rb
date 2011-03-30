require 'spec_helper'

describe "catalog_items/_index" do

  before do
    assign( :objects, @objects = catalog_items_proxy )
    @object = @objects.first
    @photo = @object.photos.first
    @photo.stub( :underscore ).and_return( "photo" )
    @object.sizes.first.stub( :underscore ).and_return( "size" )
    @object.sizes.second.stub( :underscore ).and_return( "size" )
    @object.colours.first.stub( :underscore ).and_return( "colour" )
    @object.colours.second.stub( :underscore ).and_return( "colour" )
    @object.class.stub( :season_page_title ).and_return( "Все сезоны" )
    Category.stub( :find ).and_return( @object.category )
    view.stub( :will_paginate )
    @objects.stub( :show_tag ).and_return( "catalog_item" )     
  end
  
  it "renders collection of only one existing catalog item" do
    view.should_receive( :will_paginate ).with( @objects )
    render
    rendered.should contain( @object.class.season_page_title )
    rendered.should contain( @object.category.name )
    rendered.should have_selector( :div, :id => @objects.show_tag )    
  end
  
  it_should_behave_like "catalog item"

  context "when successfull search committed" do
    
    it "renders search page title" do
      @object.class.stub_chain( :search, :size ).and_return( 347 )
      view.stub( :params ).and_return( @params = { :q => "Jacket" } )
      render
      rendered.should contain( @params[ :q ] )      
      rendered.should contain( @object.class.search.size.to_s )
    end
    
  end

end
