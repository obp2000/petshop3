require 'spec_helper'

describe "items/_show" do

  before do
    assign( :object, @item = items_proxy.first )
    @photo = @item.photos.first
  end
  
  it "shows only one existing item's details" do
    render
    rendered.should contain( @item.name  )
    rendered.should contain( @item.category.name )
    rendered.should contain( @item.season.name )
    rendered.should contain( @item.sizes.first.name )
    rendered.should have_colour( @item.colours.first.html_code )     
    rendered.should contain( @item.price.to_s )
    rendered.should contain( @item.blurb )
    rendered.should have_selector( "a[href*=" + @photo.photo_url[0..-5] + "]" ) do |a|
      a.should have_selector( "img[src*=" + @photo.photo.thumb.url + "]" )
    end
    rendered.should contain( @photo.comment )   
  end

end
