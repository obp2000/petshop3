require 'spec_helper'

describe "layouts/application" do
  
  it "renders main page" do
    view.should_receive( :render ).with( :partial => "catalog_items/header" )
    view.should_receive( :render ).with( :partial => "catalog_items/nav" )
    render
  end

end
