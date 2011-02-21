require 'spec_helper'

class WinterCatalogItem; end  
  
describe WinterCatalogItemsController do
  
  before do
    @object = winter_catalog_items_proxy.first
  end

  it_should_behave_like "object"

  describe "GET search" do
    it "assigns found catalog items as @objects index template" do
      WinterCatalogItem.should_receive( :search_results ).and_return( [ @object ] )
      xhr :get, :search
      assigns[ :objects ].should == [ @object ]
      response.should render_template( "shared/index" )      
    end
  end

end
