require 'spec_helper'
  
class ForumPost; end  
  
describe ForumPostsController do
  
  before do
    @object = forum_posts_proxy.first
    @reply_post = forum_posts_proxy.first
    @reply_post.stub( :parent_id ).and_return( @object.id )
  end
  
  it_should_behave_like "object"  
 
  describe "GET reply" do
    it "assigns a new forum post as @object and renders reply template" do
      @object.class.should_receive( :new ).with( :parent_id => @object.to_param ).and_return( @object )
      @object.should_receive( :render_reply )
      xhr :get, :reply, :id => @object.to_param
      assigns[ :object ].should equal( @object )
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested forum posts chain and renders destroy template" do
      controller.stub( :current_user ).and_return( users_proxy.first )  
      @object.class.should_receive( :find ).with( @object.to_param ).and_return( @object )      
      @object.should_receive( :destroy_object ).and_return( @destroyed_objects = [ @object, @reply_post ] )
      @object.stub( :destroy_notice ).and_return( "Test" )
      @destroyed_objects.should_receive( :render_destroy )            
      xhr :delete, :destroy, :id => @object.to_param
      assigns[ :destroyed_objects ].should == @destroyed_objects
      flash.now[ :notice ].should == @object.destroy_notice       
    end
  end

end
