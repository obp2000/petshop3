require 'spec_helper'

describe "catalog_items/_index" do

  before do
    assign( :objects, catalog_items_proxy )    
  end
  
  it "renders collection of only one existing catalog item" do
    view.should_receive( :index_page_title_for ).with( CatalogItem ).and_return( "Index page title" )         
#    view.should_receive( :render ).with( :partial => "catalog_items/catalog_item" )
    view.should_receive( :will_paginate )    
    render :partial => "catalog_items/index"
    rendered.should contain( "Index page title" )    
  end

end
