require 'spec_helper'

class CatalogItem; end  
  
describe CatalogItemsController do
  
  before do
    @object = catalog_items_proxy.first
  end

  it_should_behave_like "object"

  it_should_behave_like "search"

end
