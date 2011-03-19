require 'spec_helper'

describe "items/_form" do

    before do
      @item = items_proxy.first
      @item.sizes.stub( :partial_for_attr_with_link_to_remove ).and_return( "attr" )
      @item.colours.stub( :partial_for_attr_with_link_to_remove ).and_return( "attr" )
      @item.photos.stub( :partial_for_attr_with_link_to_remove ).and_return( "photo" )    
      @category = @item.category    
      @size = @item.sizes.first
      @colour = @item.colours.first
      @photo = @item.photos.first
      @photo.stub( :link_to_show ).and_return( link_to image_tag( @photo.photo.thumb.url ), @photo.photo_url )
      view.stub( :submit_to ).and_return( image_submit_tag "test.png" )
      view.stub( :link_to_remove_from_item )      
    end    

  describe "when the item is an existing record" do
    
    before do
      assign( :object, @item )
    end    
        
    it_should_behave_like "new or edit item form"
    
    it "renders the form for edit item" do
      view.should_receive( :link_to_remove_from_item ).with( @item.sizes.first ).once
      view.should_receive( :link_to_remove_from_item ).with( @item.sizes.second ).once      
      view.should_receive( :link_to_remove_from_item ).with( @item.colours.first ).once
      view.should_receive( :link_to_remove_from_item ).with( @item.colours.second ).once      
      view.should_receive( :link_to_remove_from_item ).with( @item.photos.first ).once       
      render
      rendered.should have_selector( "form", :method => "post", :action => item_path( @item ) )
    end
  end

  context "when the item is a new record" do

    before do
      assign( :object, @item.as_new_record )
    end    

    it "renders the form for new item" do
      render
      rendered.should have_selector( "form", :method => "post", :action => items_path )
    end
  end

end