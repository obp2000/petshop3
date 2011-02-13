require 'spec_helper'

describe "forum_posts/_new" do

  before do
    assign( :object, @forum_post = forum_posts_proxy.first.as_new_record )
  end
  
  it "renders new forum post form" do
    render
    rendered.should have_selector("form#new_forum_post", :method => "post", :action => forum_posts_path ) do |form|
      form.should have_selector( "input#forum_post_parent_id", :type => "hidden", :name => "forum_post[parent_id]", :value => "0" )
      form.should have_text_field( @forum_post, "name" )
      form.should have_text_field( @forum_post, "subject" )
      form.should have_textarea( @forum_post, "body" )          
      form.should have_selector( "input", :type => "submit" )
    end

  end

end
