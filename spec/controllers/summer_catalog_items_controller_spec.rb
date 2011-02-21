require 'spec_helper'

class SummerCatalogItem; end  
  
describe SummerCatalogItemsController do
  
  before do
    @object = summer_catalog_items_proxy.first
  end

  it_should_behave_like "object"

  describe "GET search" do
    it "assigns found catalog items as @objects index template" do
      SummerCatalogItem.should_receive( :search_results ).and_return( [ @object ] )
      xhr :get, :search
      assigns[ :objects ].should == [ @object ]
      response.should render_template( "shared/index" )      
    end
  end

end
