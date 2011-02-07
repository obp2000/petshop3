require 'spec_helper'

describe "shared/_photo" do

  before do
    @photo = photos_proxy.first
    view.stub( :link_to_show_with_comment ).with( @photo ).and_return( link_to image_tag( 
              @photo.public_filename( :small ) ) + @photo.comment, @photo.public_filename  )
  end
  
  it "renders thumbnail and comment of photo" do
    render :locals => { :photo => @photo }
    rendered.should have_thumbnail( @photo )
    rendered.should contain( @photo.comment )     
  end

end
