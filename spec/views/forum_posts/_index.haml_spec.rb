require 'spec_helper'

describe "forum_posts/_index" do

  before do
    @forum_posts = forum_posts_proxy
    @forum_posts.stub( :new_tag ).and_return( "post_new" )
    @forum_posts.stub( :show_tag ).and_return( "post" )     
    @forum_post = @forum_posts.first
    view.stub( :current_user ).and_return( true )
    assign( :objects,  @forum_posts )    
  end
  
  it "renders only one existing forum post" do
    view.should_receive( :will_paginate ).with( @forum_posts )     
    render
    rendered.should contain( @forum_post.class.model_name.human )
    rendered.should have_link_to_remote_get( new_forum_post_path )
    rendered.should have_link_to_remote_get( forum_post_path( @forum_post ) ) do |a|
      a.should contain( @forum_post.subject )      
    end
    rendered.should contain( @forum_post.name )
    rendered.should contain( l( @forum_post.created_at, :format => :long ) )
    rendered.should have_selector( "a", :href => send( "#{@forum_post.class.name.underscore}_path",
          @forum_post ), "data-method" => "delete" )    
    rendered.should have_selector( :div, :id => @forum_posts.new_tag )
    rendered.should have_selector( :div, :id => @forum_posts.show_tag )    
  end

end
