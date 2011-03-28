require 'spec_helper'

describe "forum_posts/_form" do

  before do
    assign( :object, @forum_post = forum_posts_proxy.first.as_new_record )
  end
  
  it "renders new forum post form" do
#    view.should_receive( :submit_to ).with( @forum_post ).and_return( submit_tag )      
    render
    rendered.should have_selector("form#new_forum_post", :method => "post", :action => forum_posts_path ) do |form|
      form.should have_selector( "input#forum_post_parent_id", :type => "hidden",
              :name => "forum_post[parent_id]", :value => "0" )
      form.should have_text_field( @forum_post, "name" )
      form.should have_text_field( @forum_post, "subject" )
      form.should have_textarea( @forum_post, "body" )          
      form.should have_selector( "input", :type => "submit" )
    end
  end
  
  context "when new forum post" do
  
    it "has hidden field with parent id = 0" do
      @forum_post.stub( :parent_id ).and_return( 0 )
      view.stub( :submit_to ) 
      render
      rendered.should have_selector( :input, :type => "hidden", :id => "forum_post_parent_id",
              :name => "forum_post[parent_id]", :value => '0' )
    end
    
  end

  context "when reply to forum post" do
  
    it "has hidden field with parent id != 0" do
      @forum_post.stub( :parent_id ).and_return( 2345 )      
      view.stub( :submit_to ) 
      render
      rendered.should have_selector( :input, :type => "hidden", :id => "forum_post_parent_id",
              :name => "forum_post[parent_id]", :value => "#{@forum_post.parent_id}" )
    end
    
  end

end
