require 'spec_helper'

describe "forum_posts/_forum_post" do

  before(:each) do
    @forum_post = forum_posts_proxy.first
    view.stub( :link_to_show ).with( @forum_post ).and_return( link_to @forum_post.subject,
             @forum_post, :remote => true, :method => :get )
    view.stub( :link_to_delete ).with( @forum_post ).and_return( link_to "Test",
            @forum_post, :remote => true, :method => :delete )                  
    view.stub(:current_user).and_return(true)
  end
  
  it "renders forum post" do
    render :partial => "forum_posts/forum_post", :locals => { :forum_post => @forum_post }
    rendered.should have_link_to_remote_get( forum_post_path( @forum_post ) ) do |a|
      a.should contain( @forum_post.subject )      
    end
    rendered.should contain( @forum_post.name )
    rendered.should contain( @forum_post.created_at.strftime("%d.%m.%y") )
    rendered.should contain( @forum_post.created_at.strftime("%H:%M:%S") )
#    rendered.should have_link_to_remote_delete( forum_post_path( @forum_post ) )
    rendered.should have_selector( "a", :href => send( "#{@forum_post.class.name.underscore}_path", @forum_post ),
            "data-method" => "delete" )    
  end

end
