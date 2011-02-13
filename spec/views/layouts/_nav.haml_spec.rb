require 'spec_helper'

class CatalogItem; end

describe "layouts/_nav" do

  before do
    Category.stub( :all_of ).and_return( categories_proxy )    
  end
  
  it "renders nav with seasons and categories" do
    view.should_receive( :link_to_season ).exactly( 3 ).times
    Category.should_receive( :all_of ).exactly( 4 ).times   
    view.should_receive( :link_to_category ).exactly( Category.all_of.count * 3 ).times
    view.should_receive( :set_drop_receiving_element ).with( "cart" ).once    
    render
  end

  it "renders cart" do
    render
    rendered.should have_selector( "a", :content => "Корзина" )
  end

end
