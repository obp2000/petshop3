require 'spec_helper'

describe "items/_form" do
  before do
    assign( :object, @item = items_proxy.first )
    @item.sizes.stub( :partial_for_attr_with_link_to_remove ).and_return( "attr" )
    @item.colours.stub( :partial_for_attr_with_link_to_remove ).and_return( "attr" )
    @item.photos.stub( :partial_for_attr_with_link_to_remove ).and_return( "photo" )      
  end
  
  describe "when the item is an existing record" do
    it_should_behave_like "new or edit item form"
    it "renders the form for edit item" do
      render
      rendered.should have_selector( "form", :method => "post", :action => item_path( @item ) )
    end
  end
end