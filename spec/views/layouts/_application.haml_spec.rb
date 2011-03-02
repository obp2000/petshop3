require 'spec_helper'

describe "layouts/_application" do
  
  before do
    @first_contact = contacts_proxy.first
    view.stub( :link_to_show ).with( @first_contact ).and_return( link_to @first_contact.name,
            @first_contact, :remote => true, :method => :get )    
    Contact.stub( :first ).and_return( @first_contact )
    view.stub( :link_to_index ).with( ForumPost ).and_return( link_to "Test", forum_posts_path, :remote => true, :method => :get )
    view.stub( :do_not_show_nav ).and_return( false )
#    CatalogItem.stub( :group_by_category ).and_return( [ catalog_items_proxy.first ] )
#    SummerCatalogItem.stub( :group_by_category ).and_return( [ summer_catalog_items_proxy.first ] )
#    WinterCatalogItem.stub( :group_by_category ).and_return( [ winter_catalog_items_proxy.first ] )     
    CatalogItem.stub( :find ).with( :all, :select => "category_id", :group => "category_id" ).and_return( [ catalog_items_proxy.first ] )
    SummerCatalogItem.stub( :all, :select => "category_id", :group => "category_id" ).and_return( [ summer_catalog_items_proxy.first ] )
    WinterCatalogItem.stub( :all, :select => "category_id", :group => "category_id" ).and_return( [ winter_catalog_items_proxy.first ] ) 
  end  
  
  it "renders main page" do
    view.should_receive( :link_to_season ).exactly( 3 ).times
    view.should_receive( :link_to_category ).exactly( 3 ).times
    view.should_receive( :set_drop_receiving_element ).with( "cart" ).once 
    render
    rendered.should have_selector( "form", :method => "post", :action => search_catalog_items_path ) do |form|
      form.should have_selector( "input", :type => "text" )        
      form.should have_image_input
    end
    rendered.should have_link_to_remote_get( forum_posts_path )
    rendered.should have_link_to_remote_get( contact_path( @first_contact ) )
    rendered.should have_selector( "a", :href => items_path )
    rendered.should have_selector( "a", :content => "Корзина" )    
  end

end
