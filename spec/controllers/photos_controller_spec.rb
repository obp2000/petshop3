require 'spec_helper'
  
describe PhotosController do
  
  before do
    @object = photos_proxy.first
  end

  it_should_behave_like "object"

end
