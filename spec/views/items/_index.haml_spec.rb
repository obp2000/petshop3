require 'spec_helper'

class Item; end

describe "items/_index" do

  before do
    assign( :objects, @items = items_proxy )
    assign( :object, @item = items_proxy.first.as_new_record )
    view.stub( :will_paginate )
    @item.stub( :new_tag ).and_return( "item_content" )    
  end
  
  it "renders one existing item" do
    view.should_receive( :index_page_title_for ).with( @items ).and_return( "Index page title" )
    view.should_receive( :will_paginate ).with( @items )
    @items.should_receive( :headers ).and_return( [ [ "name", "Название" ],
          [ "sizes.first.name", "Размер" ], [ "colours.first.name", "Цвет" ],
          [ "category.name", "Вид" ], [ "price", "Цена" ] ] )
    render
    rendered.should contain( "Index page title" )
    rendered.should have_selector( :div, :id => @item.new_tag )    
    rendered.should have_link_to_remote_get( items_path( :sort_by => "name", :index_text => "Название" ) )
    rendered.should have_link_to_remote_get( items_path( :sort_by => "sizes.first.name", :index_text => "Размер" ) )
    rendered.should have_link_to_remote_get( items_path( :sort_by => "colours.first.name", :index_text => "Цвет" ) )
    rendered.should have_link_to_remote_get( items_path( :sort_by => "category.name", :index_text => "Вид" ) )
    rendered.should have_link_to_remote_get( items_path( :sort_by => "price", :index_text => "Цена" ) )    
    rendered.should have_link_to_remote_get( new_item_path )
  end

  it_should_behave_like "item"

end
