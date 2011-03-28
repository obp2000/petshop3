require 'spec_helper'

class WinterCatalogItem; end  
  
describe WinterCatalogItemsController do
  
  before do
    @object = winter_catalog_items_proxy.first
  end

  it_should_behave_like "object"

  it_should_behave_like "search"

end
