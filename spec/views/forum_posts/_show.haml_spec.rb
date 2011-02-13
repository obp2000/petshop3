require 'spec_helper'

describe "forum_posts/_show" do

  before do
    assign( :object, @forum_post = forum_posts_proxy.first )
    view.stub( :link_to_reply_to ).with( @forum_post ).and_return( link_to "Test",
            reply_forum_post_path( @forum_post ), :remote => true, :method => :get )    
    
  end
  
  it "renders forum post details" do
    render
    rendered.should contain( @forum_post.subject )      
    rendered.should contain( @forum_post.name )
    rendered.should contain( @forum_post.body )
    rendered.should have_link_to_remote_get( reply_forum_post_path( @forum_post ) )    
  end

end
