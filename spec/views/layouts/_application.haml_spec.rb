require 'spec_helper'

describe "layouts/_application" do
  
  before do
    Contact.stub( :first ).and_return( contacts_proxy.first )
    view.stub( :do_not_show_nav ).and_return( false )
    CatalogItem.stub( :season_name ).and_return( "Все сезоны" )
    SummerCatalogItem.stub( :season_name ).and_return( "Весна/Лето" )
    WinterCatalogItem.stub( :season_name ).and_return( "Осень/Зима" )    
    CatalogItem.stub( :group_by_category ).and_return( [ catalog_items_proxy.first ] )
    SummerCatalogItem.stub( :group_by_category ).and_return( [ summer_catalog_items_proxy.first ] )
    WinterCatalogItem.stub( :group_by_category ).and_return( [ winter_catalog_items_proxy.first ] )
    @session = {}
    @session.stub( :cart ).and_return( carts_proxy.first )
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
      a.should contain( SummerCatalogItem.season_name )
    end
    
    rendered.should have_selector( :a ) do |a|
      a.should contain( WinterCatalogItem.season_name )
    end
    rendered.should have_selector( :a ) do |a|
      a.should contain( CatalogItem.season_name )
    end    
    rendered.should have_selector( :a ) do |a|
      a.should contain( @session.cart.class.model_name.human )
    end    
  end

end
