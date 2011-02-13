require 'spec_helper'

describe "items/_show" do

  before do
    assign( :object, @item = items_proxy.first )
    Item.stub( :season_name ).and_return( "Весна/Лето" )
  end
  
  it "shows only one existing item's details" do
#    view.should_receive(:render).with( :partial => "shared/photo", :collection => assigns[:object].photos )
    render
    rendered.should contain( @item.name  )
    rendered.should contain( @item.category.name )
    rendered.should contain( Item.season_name )
    rendered.should contain( @item.sizes.first.name )
    rendered.should have_colour( @item.colours.first.html_code )     
    rendered.should contain( @item.price.to_s )
    rendered.should contain( @item.blurb )
  end

end
