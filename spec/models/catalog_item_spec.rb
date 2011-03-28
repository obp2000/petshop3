require 'spec_helper'

describe CatalogItem do
  
  before do
    create_4_catalog_items_with_different_categories_and_seasons
    @params = {}
  end

  describe "#catalog_items" do

    it "lists all catalog items" do
      CatalogItem.index_scope( @params ).count.should == 4
    end
  
  end

  context "when catalog item has category" do

    before do
      @params = { :category_id => @category1.id }      
    end

    it "lists only catalog items of @category1" do
      CatalogItem.index_scope( @params ).count.should == 2
      CatalogItem.index_scope( @params ).each do |catalog_item|
        catalog_item.category.name.should == @category1.name
      end
    end
  
  end

  context "when resuls is found" do  

    before do
      CatalogItem.stub( :search ).and_return( [ @catalog_item ] )
      @params[ :q ] = "Test"
    end  
  
    describe "#search_results" do
     
      it "lists search results and proper page title" do
        CatalogItem.search_results( @params ).count.should == 1
        CatalogItem.search_results( @params ).first.name.should == @catalog_item.name
      end  

    end

  end

  context "when resuls is not found" do
      
    before do
      CatalogItem.stub( :search ).and_return( [] )
      @params[ :q ] = "Test"
    end
      
    it "renders empty list of results" do
      CatalogItem.search_results( @params ).should be_empty
    end  

  end

end
