require 'spec_helper'

describe "photos/_photo" do
  
  it "renders a form for edit photo" do
    @object = photos_proxy.first
    view.stub( :link_to_delete ).with( @object ).and_return( link_to "Test",
            photo_path( @object ), :remote => true, :method => :delete )
    view.stub( :link_to_show ).with( @object ).and_return( link_to image_tag( @object.photo.thumb.url ),
            @object.photo_url )
    view.should_receive( :link_to_add_to_item1 ).with( @object )
    render :partial => "photos/photo", :locals => { :photo => @object }
    rendered.should have_selector( "a", :href => @object.photo_url ) do |a|
      a.should have_selector( "img", :src => "/images/" + @object.photo.thumb.url )
    end    
    rendered.should have_selector("form", :method => "post", :action => photo_path(@object)) do |form|
      form.should have_textarea( @object, "comment" )      
      form.should have_image_input
    end
    rendered.should have_selector( "a", :href => send( "#{@object.class.name.underscore}_path", @object ),
            "data-method" => "delete" )
  end

end
