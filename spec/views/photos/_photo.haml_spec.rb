require 'spec_helper'

describe "photos/_photo" do
  
  it "renders a form for edit photo" do
    @object = photos_proxy.first
    view.stub( :link_to_delete ).with( @object ).and_return( link_to_remote "Test",
            :url => photo_path( @object ), :method => :delete )
    view.stub( :link_to_show ).with( @object ).and_return( link_to image_tag( @object.public_filename( :small ) ),
            @object.public_filename )
    render :locals => { :photo => @object }
    rendered.should have_thumbnail( @object )     
    rendered.should have_selector("form", :method => "post", :action => photo_path(@object)) do |form|
      form.should have_textarea( @object, "comment" )      
      form.should have_image_input
    end
    rendered.should have_text( regexp_for_remote_delete( photo_path( @object ) ) )       
  end

end
