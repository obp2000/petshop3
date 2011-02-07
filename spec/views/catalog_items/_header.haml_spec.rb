require 'spec_helper'

describe "catalog_items/_header" do
  
  before do
    @first_contact = contacts_proxy.first
    view.stub( :link_to_show ).with( @first_contact ).and_return( link_to_remote @first_contact.name,
            :url => contact_path( @first_contact ), :method => :get )    
    Contact.stub( :first ).and_return( @first_contact )
#    @forum_posts = forum_posts_proxy
    view.stub( :link_to_index ).with( ForumPost ).and_return( link_to_remote "Test",
            :url => forum_posts_path, :method => :get )       
  end
  
  it "renders search box and links" do
#    view.should_receive( :link_to_index ).with( @forum_posts.first.class )      
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
