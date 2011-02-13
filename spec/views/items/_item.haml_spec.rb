require 'spec_helper'

describe "items/_item" do

  before do
    @item = items_proxy.first
    view.stub( :link_to_delete ).with( @item ).and_return( link_to "Test", @item, :remote => true, :method => :delete )       
  end
  
  it "renders item" do
#    view.should_receive( :render_attrs ).with( @item.sizes )
#    view.should_receive( :render_attrs ).with( @item.colours )  
#    view.should_receive( :link_to_delete ).with( @item )    
    render :partial => "items/item", :locals => { :item => @item }
    rendered.should have_selector( "tr", :onclick => "$.get('#{edit_item_path(@item)}')" )
    rendered.should contain(@item.name)
    rendered.should contain(@item.category.name)
    rendered.should contain( @item.sizes.first.name )
    rendered.should have_colour( @item.colours.first.html_code )     
    rendered.should contain(@item.price.to_s)
#    rendered.should have_link_to_remote_delete( item_path( @item ) )
    rendered.should have_selector( "a", :href => send( "#{@item.class.name.underscore}_path", @item ), "data-method" => "delete" )    
  end

end
