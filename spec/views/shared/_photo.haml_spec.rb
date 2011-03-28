require 'spec_helper'

describe "shared/_photo" do

  before do
    @photo = photos_proxy.first
  end
  
  it "renders thumbnail and comment of photo" do
    render :partial => "shared/photo", :locals => { :photo => @photo }
    rendered.should have_selector( "a", :href => @photo.photo_url ) do |a|
      a.should have_selector( "img", :src => "/images/" + @photo.photo.thumb.url )
    end      
    rendered.should contain( @photo.comment )     
  end

end
