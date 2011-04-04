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
    @object.stub( :category_name ).and_return( @object.category.name )    
    view.stub( :params ).and_return( { :category_id => 124 } )
    view.stub( :will_paginate )
    @objects.stub( :show_tag ).and_return( "catalog_item" )     
  end
  
  it "renders collection of only one existing catalog item" do
    view.should_receive( :will_paginate ).with( @objects )
    render
    rendered.should contain( @objects.human )
    rendered.should contain( @objects.category_name )
    rendered.should have_selector( :div, :id => @objects.show_tag )    
  end
  
  it_should_behave_like "catalog item"

  context "when successfull search committed" do
    
    it "renders search page title" do
      view.stub( :params ).and_return( @params = { :q => "Jacket" } )
      render
      rendered.should contain( @params[ :q ] )      
      rendered.should contain( @objects.size.to_s )
    end
    
  end

end
