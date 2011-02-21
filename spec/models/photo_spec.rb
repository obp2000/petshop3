require 'spec_helper'

require 'carrierwave/test/matchers'

describe Photo do
  
  before do
    @params =  { "photo" => { "photo" => fixture_file_upload( fixture_path + "/test.jpg", "image/jpeg", :binary ),
             "comment" => "Photo of jacket" } }
    @updated_params = { "photo" => { :comment => "Photo of shirt" } }         
    @session = {}
    @flash = {}
    @flash.stub( :now ).and_return( @flash )      
  end

  it "is valid with valid attributes" do
      @photo = Photo.new_object( @params, @session )
      @photo.should be_valid 
  end

  it "is not valid without a filename" do
    @params =  { "photo" => { "comment" => "Photo of jacket" } }    
    create_photo    
    @photo.should_not be_valid
  end

  describe "#new_object" do
  
    it "builds new photo" do
      @photo = Photo.new_object( @params, @session )
      @photo.photo_url.should =~ /test.jpg/
    end
  
  end

  describe "#save_object" do
  
    it "saves new photo" do
      create_photo      
      @photo.photo_url.should =~ /test.jpg/
      @flash.now[ :notice ].should contain( "создан" )        
    end
  
  end  
  
  describe "#update_object" do
  
    it "updates existing photo comment" do
      create_photo      
      @photo = Photo.update_object( @updated_params.merge( :id => @photo.id ), @session, @flash ).first
      @photo.comment.should == @updated_params[ "photo" ][ :comment ]
      @flash.now[ :notice ].should contain( "обновлён" )      
    end
  
  end
  
  describe "#destroy_object" do
  
    it "destroys existing photo" do
      create_photo
      @params_for_destroy = { :id => @photo.id }
      @photo = Photo.destroy_object( @params_for_destroy, @session, @flash )
      @photo.photo_url.should =~ /test.jpg/
      Photo.all.should_not include( @photo )
      @flash.now[ :notice ].should contain( "удалён" )                
    end
  
  end  

end
