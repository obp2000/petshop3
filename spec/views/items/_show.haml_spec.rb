require 'spec_helper'

describe "items/_show" do

  before(:each) do
    assigns[:object] = items_proxy.first
    Item.stub( :season_name ).and_return( "Весна/Лето" )
  end
  
  it "shows only one existing item's details" do
    view.should_receive(:render_attrs).with( assigns[:object].sizes )
    view.should_receive(:render_attrs).with( assigns[:object].colours )      
    view.should_receive(:render).with( :partial => "shared/photo", :collection => assigns[:object].photos )
    render
    rendered.should contain( assigns[:object].name  )
    rendered.should contain( assigns[:object].category.name )
    rendered.should contain( Item.season_name )
    rendered.should contain( assigns[:object].price.to_s )
    rendered.should contain( assigns[:object].blurb )
  end

end
