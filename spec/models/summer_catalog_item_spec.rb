require 'spec_helper'

describe SummerCatalogItem do
  
  before do
    create_4_catalog_items_with_different_categories_and_seasons
    @params = {}
  end

  describe "#catalog_items" do

    it "lists only summer catalog items" do
      SummerCatalogItem.catalog_items( @params ).count.should == 2
      SummerCatalogItem.catalog_items( @params ).first.type.should == "SummerCatalogItem"   
    end
 
    it "show proper page title" do
      SummerCatalogItem.index_page_title_for( @params ).should == "Каталог товаров: #{SummerCatalogItem.season_name}"
    end
  
  end

  context "when summer catalog item has category" do

    before do
      @params = { :category_id => @category1.id }      
    end

    it "lists only catalog items of @category1" do
      SummerCatalogItem.catalog_items( @params ).count.should == 1
      SummerCatalogItem.catalog_items( @params ).each do |catalog_item|
        catalog_item.category.name.should == @category1.name
      end
    end
 
    it "show proper page title" do
      SummerCatalogItem.index_page_title_for( @params ).should contain( SummerCatalogItem.season_name )      
      SummerCatalogItem.index_page_title_for( @params ).should contain( @category1.name )
    end
  
  end

end
