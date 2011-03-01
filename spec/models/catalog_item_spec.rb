require 'spec_helper'

describe CatalogItem do
  
  before do
#    @catalog_item1 = Item.create!( valid_item_attributes )
#    @catalog_item2 = Item.create!( valid_item_attributes )
    create_4_catalog_items_with_different_categories_and_seasons
    @params = {}
  end

  describe "#catalog_items" do

    it "lists all catalog items" do
      CatalogItem.index_scope( @params ).count.should == 4
    end
  
  end
 
  describe "#index_page_title_for" do 
  
    it "show proper page title" do
      CatalogItem.index_page_title_for( @params ).should == "Каталог товаров: #{CatalogItem.season_name}"
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
 
    it "show proper page title" do
      CatalogItem.index_page_title_for( @params ).should contain( @category1.name )
    end
  
  end

  context "when resuls is found" do  

    before do
      CatalogItem.stub( :search ).and_return( [ @catalog_item ] )
      @params[ :q ] = "Test"
      @flash = {}
      @flash.stub( :now ).and_return( @flash )         
    end  
  
    describe "#search_results" do
     
      it "lists search results and proper page title" do
        CatalogItem.search_results( @params, @flash ).count.should == 1
        CatalogItem.search_results( @params, @flash ).first.name.should == @catalog_item.name
        CatalogItem.index_page_title_for( @params ).should =~ /Test.*: 1/
        @flash.now[ :notice ].should be_blank           
      end  

    end

  end

  context "when resuls is not found" do
      
    before do
      CatalogItem.stub( :search ).and_return( [] )
      @params[ :q ] = "Test"
      @flash = {}
      @flash.stub( :now ).and_return( @flash )         
    end
      
    it "renders empty list of results" do
      CatalogItem.search_results( @params, @flash ).should be_empty
      @flash.now[ :notice ].should =~ /не найдены/       
    end  

  end

end
