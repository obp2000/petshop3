require 'spec_helper'

describe "catalog_items/_index" do

  before do
    assign( :objects, @objects = catalog_items_proxy )
    @object = @objects.first
    @photo = @object.photos.first
    view.stub( :index_page_title_for ).and_return( "Index page title" )         
    view.stub( :will_paginate )
    @objects.stub( :show_tag ).and_return( "details" )     
  end
  
  it "renders collection of only one existing catalog item" do
    view.should_receive( :will_paginate ).with( @objects )
    render
    rendered.should contain( "Index page title" )
    rendered.should have_selector( :div, :id => @objects.show_tag )    
  end
  
  it_should_behave_like "catalog item"

end
