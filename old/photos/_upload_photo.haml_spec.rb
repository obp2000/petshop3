require 'spec_helper'

describe "photos/_upload_photo" do

  it "renders a form for uploading a new photo" do
    @object = photos_proxy.first.class.new
    view.stub( :submit_to ).and_return( image_submit_tag "test.png" )    
    render "photos/upload_photo", :upload_photo => @object
    rendered.should have_selector( "form", :method => "post", :action => photos_path,
                  :enctype => "multipart/form-data", :target => "upload_frame" ) do |form|
      form.should have_selector("input", :type => "file")
      form.should have_image_input
    end
  end

end
