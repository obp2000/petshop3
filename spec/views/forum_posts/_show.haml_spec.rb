require 'spec_helper'

describe "forum_posts/_show" do

  before do
    assign( :object, @forum_post = forum_posts_proxy.first )
  end
  
  it "renders forum post details" do
    render
    rendered.should contain( @forum_post.subject )      
    rendered.should contain( @forum_post.name )
    rendered.should contain( @forum_post.body )
    rendered.should have_link_to_remote_get( reply_forum_post_path( @forum_post ) )    
  end

end
