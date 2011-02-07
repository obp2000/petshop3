require 'spec_helper'

describe "catalog_items/_index" do

  before do
    assigns[:objects] = catalog_items_proxy
  end
  
  it "renders collection of only one existing catalog item" do
    view.should_receive( :index_page_title_for ).with( CatalogItem )         
    view.should_receive( :render ).with( :partial => "catalog_items/catalog_item", :collection => assigns[:objects] )
    view.should_receive( :will_paginate ).with( assigns[:objects] )    
    render
  end

end
