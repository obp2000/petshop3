require 'spec_helper'

describe "items/_category" do

  before do
    @category = items_proxy.first.category
  end
  
  it "renders category in form for item" do
    render :partial => "items/category", :locals => { :category => @category }
    rendered.should have_selector( "input#item_category_id", :type => "hidden", :name => "item[category_id]",
          :value => @category.to_param )
    rendered.should contain( @category.name )          
  end

end
