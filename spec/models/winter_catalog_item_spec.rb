require 'spec_helper'

describe WinterCatalogItem do
  before do
    create_4_catalog_items_with_different_categories_and_seasons
    @params = {}
  end

  describe "#catalog_items" do

    it "lists only winter catalog items" do
      WinterCatalogItem.catalog_items( @params ).count.should == 2
      WinterCatalogItem.catalog_items( @params ).first.type.should == "WinterCatalogItem"   
    end
 
    it "show proper page title" do
      WinterCatalogItem.index_page_title_for( @params ).should == "Каталог товаров: #{WinterCatalogItem.season_name}"
    end
  
  end

  context "when winter catalog item has category" do

    before do
      @params = { :category_id => @category1.id }      
    end

    it "lists only catalog items of @category1" do
      WinterCatalogItem.catalog_items( @params ).count.should == 1
      WinterCatalogItem.catalog_items( @params ).each do |catalog_item|
        catalog_item.category.name.should == @category1.name
      end
    end
 
    it "show proper page title" do
      WinterCatalogItem.index_page_title_for( @params ).should contain( WinterCatalogItem.season_name )      
      WinterCatalogItem.index_page_title_for( @params ).should contain( @category1.name )
    end
  
  end



end
