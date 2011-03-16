require 'spec_helper'

describe "layouts/_application" do
  
  before do
    @first_contact = contacts_proxy.first
    view.stub( :link_to_show ).with( @first_contact ).and_return( link_to @first_contact.name,
            @first_contact, :remote => true, :method => :get )    
    Contact.stub( :first ).and_return( @first_contact )
    view.stub( :do_not_show_nav ).and_return( false )
#    @catalog_items = catalog_items_proxy
    CatalogItem.stub( :find ).with( :all, :select => "category_id", :group => "category_id" ).and_return( [ catalog_items_proxy.first ] )
    SummerCatalogItem.stub( :find ).with( :all, :select => "category_id", :group => "category_id" ).and_return( [ summer_catalog_items_proxy.first ] )
    WinterCatalogItem.stub( :find ).with( :all, :select => "category_id", :group => "category_id" ).and_return( [ winter_catalog_items_proxy.first ] )
#    assign( :objects, @catalog_items )
  end  
  
  it "renders main page" do
    view.should_receive( :submit_to ).and_return( image_submit_tag "test.png" )      
    view.should_receive( :link_to_season ).exactly( 3 ).times
    view.should_receive( :link_to_category ).exactly( 3 ).times
    view.should_receive( :set_drop_receiving_element ).with( "cart" ).once 
    render
    rendered.should have_selector( "form", :method => "post", :action => search_catalog_items_path ) do |form|
      form.should have_selector( "input", :type => "search" )        
      form.should have_image_input
    end
    rendered.should have_link_to_remote_get( forum_posts_path )
    rendered.should have_link_to_remote_get( contact_path( @first_contact ) )
    rendered.should have_selector( "a", :href => items_path )
    rendered.should have_selector( :a ) do |a|
      a.should contain( "Весна/Лето" )
    end
    
    rendered.should have_selector( :a ) do |a|
      a.should contain( "Осень/Зима" )
    end
    rendered.should have_selector( :a ) do |a|
      a.should contain( "Все" )
    end    
    rendered.should have_selector( :a ) do |a|
      a.should contain( "Корзина" )
    end    
  end

end
