require 'spec_helper'

require 'carrierwave/test/matchers'

describe Photo do
  
  before do
    PhotoUploader.enable_processing = true
    @uploader = PhotoUploader.new( @photo, :photo )
    @uploader.store!( File.open( "public/uploads/photo/photo/28/sv100962.jpg" ) )
        
    @updated_params = { "photo" => { :comment => "Photo of shirt" } }         
    @session = {}
    @flash = {}
    @flash.stub( :now ).and_return( @flash )         
  end

  after do
    PhotoUploader.enable_processing = false
  end

  it "is valid with valid attributes" do
    @photo.should be_valid
  end

  it "is not valid without a filename" do
    @photo.photo = nil
    @photo.should_not be_valid
  end

  describe "#new_object" do
  
    it "builds new photo" do
#      @photo = Photo.new_object( @params, @session )
      @photo.photo_url.should == "spec/fixtures/test.jpg"
    end
  
  end

  describe "#save_object" do
  
    it "saves new photo" do
#      create_photo
      @photo.reload
      @photo.photo_url.should == "spec/fixtures/test.jpg"
      @flash.now[ :notice ].should contain( "создан" )        
    end
  
  end  
  
  describe "#update_object" do
  
    it "updates existing photo comment" do
#      create_photo
      @photo = Photo.update_object( @updated_params.merge( :id => @photo.id ), @session, @flash ).first
      @photo.comment.should == @updated_params[ "photo" ][ :comment ]
      @flash.now[ :notice ].should contain( "обновлён" )      
    end
  
  end
  
  describe "#destroy_object" do
  
    it "destroys existing photo" do
#      create_photo
      @params_for_destroy = { :id => @photo.id }
      @photo = Photo.destroy_object( @params_for_destroy, @session, @flash )
      @photo.photo_url.should == "spec/fixtures/test.jpg"
      Photo.all.should_not include( @photo )
      @flash.now[ :notice ].should contain( "удалён" )                
    end
  
  end  

end
