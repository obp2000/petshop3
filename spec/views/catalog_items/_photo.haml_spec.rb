require 'spec_helper'

describe "catalog_items/_photo" do

  before(:each) do
    @photo = photos_proxy.first
  end
  
  it "renders photo and comment of catalog item" do
    render :locals => { :photo => @photo }
    rendered.should have_selector( "img", :src => "/images/" + @photo.public_filename )
    rendered.should contain( @photo.comment )  
  end

end
