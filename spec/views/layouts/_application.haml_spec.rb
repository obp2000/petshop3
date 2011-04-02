require 'spec_helper'

describe "layouts/_application" do
  
  before do
    Contact.stub( :first ).and_return( contacts_proxy.first )
    view.stub( :do_not_show_nav ).and_return( false )
    CatalogItem.stub( :human ).and_return( "Все сезоны" )
    SummerCatalogItem.stub( :human ).and_return( "Весна/Лето" )
    WinterCatalogItem.stub( :human ).and_return( "Осень/Зима" )
    CatalogItem.stub( :find ).and_return( [ catalog_items_proxy.first ] )
    SummerCatalogItem.stub( :find ).and_return( [ summer_catalog_items_proxy.first ] )
    WinterCatalogItem.stub( :find ).and_return( [ winter_catalog_items_proxy.first ] )    
    CatalogItem.stub( :group_by_category ).and_return( [ catalog_items_proxy.first ] )
    SummerCatalogItem.stub( :group_by_category ).and_return( [ summer_catalog_items_proxy.first ] )
    WinterCatalogItem.stub( :group_by_category ).and_return( [ winter_catalog_items_proxy.first ] )
    @session = {}
    @cart = carts_proxy.first
    @cart.stub( :human ).and_return( "Корзина" )
    @cart.stub( :content_tag ).and_return( "cart" )
    view.stub( :cart ).and_return( @cart )
  end  
  
  it "renders main page" do
    view.should_receive( :link_to_category ).exactly( 3 ).times
    view.should_receive( :set_drop_receiving_element ).with( "cart" ).once 
    render
    rendered.should have_selector( "form", :method => "post", :action => search_catalog_items_path ) do |form|
      form.should have_selector( "input", :type => "search" )        
      form.should have_image_input
    end
    rendered.should have_link_to_remote_get( forum_posts_path )
    rendered.should have_link_to_remote_get( contact_path( Contact.first ) )
    rendered.should have_selector( "a", :href => items_path )
    rendered.should have_selector( :a ) do |a|
      a.should contain( SummerCatalogItem.human )
    end
    rendered.should have_selector( :a ) do |a|
      a.should contain( WinterCatalogItem.human )
    end
    rendered.should have_selector( :a ) do |a|
      a.should contain( CatalogItem.human )
    end    
    rendered.should have_selector( :a ) do |a|
      a.should contain( @cart.human )
    end    
  end

end
