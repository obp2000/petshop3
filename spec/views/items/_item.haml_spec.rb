require 'spec_helper'

describe "items/_item" do

  before do
    @items = items_proxy
  end
  
  it "renders item" do
    render "items/item", :item => @items.first
    rendered.should have_selector( "tr", :onclick => "$.get('#{edit_item_path( @items.first )}')" )
    rendered.should contain(@items.first.name)
    rendered.should contain(@items.first.category.name)
    rendered.should contain( @items.first.sizes.first.name )
    rendered.should have_colour( @items.first.colours.first.html_code )     
    rendered.should contain(@items.first.price.to_s)
    rendered.should have_selector( "a", :href => send( "#{@items.first.class.name.underscore}_path",
          @items.first ), "data-method" => "delete" )    
  end

end
