require 'spec_helper'

describe "catalog_items/_photo" do

  before(:each) do
    @photo = photos_proxy.first
  end
  
  it "renders photo and comment of catalog item" do
    render :partial => "catalog_items/photo", :locals => { :photo => @photo }
    rendered.should have_selector( "img[src*=" + @photo.photo_url[0..-5] + "]" )
    rendered.should contain( @photo.comment )  
  end

end
