require 'spec_helper'
  
describe PhotosController do
  
  before do
    @object = photos_proxy.first
    Photo.stub( :create_render_block ).and_return( lambda { render :template => "shared/create_or_update.rjs" } )
  end

  it_should_behave_like "object"

end
