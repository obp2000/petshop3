require 'spec_helper'

describe "items/_index" do

  before do
    @items = items_proxy
    @item = items_proxy.first.as_new_record    
    view.stub( :will_paginate )
    @item.class.stub( :new_tag ).and_return( "edit_item" )
    @items.first.stub( :category_name ).and_return( @item.category.name )
    assign( :objects, @items )
    assign( :object, @item )
  end
  
  it "renders one existing item" do
    view.should_receive( :will_paginate ).with( @items )
    render
    rendered.should contain( @items.first.class.model_name.human.pluralize )
    rendered.should have_selector( :div, :id => Item.new_tag )    
    rendered.should have_link_to_remote_get( items_path( :sort_by => "name" ) )
    rendered.should have_link_to_remote_get( items_path( :sort_by => "sizes_name" ) )
    rendered.should have_link_to_remote_get( items_path( :sort_by => "colours_name" ) )
    rendered.should have_link_to_remote_get( items_path( :sort_by => "category_name" ) )
    rendered.should have_link_to_remote_get( items_path( :sort_by => "price" ) )    
    rendered.should have_link_to_remote_get( new_item_path )
  end

  it_should_behave_like "item"

end
