require 'spec_helper'

describe "forum_posts/_index" do

  before(:each) do
    assigns[:objects] = forum_posts_proxy
#    view.stub(:will_paginate)
  end
  
  it "renders only one existing forum post" do
#    view.should_receive( :page_title )
    view.should_receive( :index_page_title_for ).with( ForumPost )      
    view.should_receive(:render).with( :partial => "forum_post", :collection => assigns[:objects] )
    view.should_receive( :will_paginate ).with( assigns[:objects] )     
    render
    rendered.should have_link_to_remote_get( new_forum_post_path )    
  end

end
