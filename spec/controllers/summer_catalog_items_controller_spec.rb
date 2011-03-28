require 'spec_helper'

class SummerCatalogItem; end  
  
describe SummerCatalogItemsController do
  
  before do
    @object = summer_catalog_items_proxy.first
  end

  it_should_behave_like "object"

  it_should_behave_like "search"

end
