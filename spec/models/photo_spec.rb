require 'spec_helper'

require 'carrierwave/test/matchers'

describe Photo do
  
  before do
    @params =  { "photo" => { "photo" => fixture_file_upload( fixture_path + "/test.jpg", "image/jpeg", :binary ),
             "comment" => "Photo of jacket" } }
    @updated_params = { "photo" => { :comment => "Photo of shirt" } }         
    @session = {}
  end

  it "is valid with valid attributes" do
      @photo = Photo.new_object( @params )
      @photo.should be_valid 
  end

  it "is not valid without a filename" do
    @params =  { "photo" => { "comment" => "Photo of jacket" } }    
    create_photo    
    @photo.should_not be_valid
  end

  describe "#new_object" do
  
    it "builds new photo" do
      @photo = Photo.new_object( @params )
      @photo.photo_url.should =~ /test.jpg/
    end
  
  end

  describe "#save_object" do
  
    it "saves new photo" do
      create_photo      
      @photo.photo_url.should =~ /test.jpg/
    end
  
  end  
  
  describe "#update_object" do
  
    it "updates existing photo comment" do
      create_photo      
      @photo = Photo.current_object( { :id => @photo.id }, @session.cart )
      @photo.update_object( @updated_params )
      @photo.comment.should == @updated_params[ "photo" ][ :comment ]
    end
  
  end
  
  describe "#destroy_object" do
  
    it "destroys existing photo" do
      create_photo
      @params_for_destroy = { :id => @photo.id }
      @photo = Photo.current_object( @params_for_destroy, @session.cart )
      @photo.destroy_object
      @photo.photo_url.should =~ /test.jpg/
      Photo.all.should_not include( @photo )
    end
  
  end  

end
