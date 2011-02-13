require 'spec_helper'

describe "layouts/_header" do
  
  before do
    @first_contact = contacts_proxy.first
    view.stub( :link_to_show ).with( @first_contact ).and_return( link_to @first_contact.name,
            @first_contact, :remote => true, :method => :get )    
    Contact.stub( :first ).and_return( @first_contact )
    view.stub( :link_to_index ).with( ForumPost ).and_return( link_to "Test", forum_posts_path, :remote => true, :method => :get )       
  end
  
  it "renders search box and links" do
    render
    rendered.should have_selector( "form", :method => "post", :action => search_catalog_items_path ) do |form|
      form.should have_selector( "input", :type => "text" )        
      form.should have_image_input
    end
    rendered.should have_link_to_remote_get( forum_posts_path )
    rendered.should have_link_to_remote_get( contact_path( @first_contact ) )
    rendered.should have_selector( "a", :href => items_path )        
  end

end
