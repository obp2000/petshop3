require 'spec_helper'

describe "shared/_photo" do

  before do
    @photo = photos_proxy.first
    view.stub( :link_to_show_with_comment ).with( @photo ).and_return( link_to image_tag( @photo.photo.thumb.url ) +
            @photo.comment, @photo.photo_url )              
  end
  
  it "renders thumbnail and comment of photo" do
    render :partial => "shared/photo", :locals => { :photo => @photo }
    rendered.should have_selector( "a", :href => @photo.photo_url ) do |a|
      a.should have_selector( "img", :src => "/images/" + @photo.photo.thumb.url )
    end      
    rendered.should contain( @photo.comment )     
  end

end
