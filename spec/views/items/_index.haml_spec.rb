require 'spec_helper'

describe "items/_index" do

  before do
    assign( :objects, @items = items_proxy )
    assign( :object, @item = items_proxy.first.as_new_record )
    view.stub( :will_paginate )
    @item.class.stub( :new_tag ).and_return( "edit_item" )    
  end
  
  it "renders one existing item" do
    view.should_receive( :will_paginate ).with( @items )
    render
    rendered.should contain( @items.first.class.model_name.human.pluralize )
    rendered.should have_selector( :div, :id => Item.new_tag )    
    rendered.should have_link_to_remote_get( items_path( :sort_by => "name" ) )
    rendered.should have_link_to_remote_get( items_path( :sort_by => "sizes.first.name" ) )
    rendered.should have_link_to_remote_get( items_path( :sort_by => "colours.first.name" ) )
    rendered.should have_link_to_remote_get( items_path( :sort_by => "category.name" ) )
    rendered.should have_link_to_remote_get( items_path( :sort_by => "price" ) )    
    rendered.should have_link_to_remote_get( new_item_path )
  end

  it_should_behave_like "item"

end
