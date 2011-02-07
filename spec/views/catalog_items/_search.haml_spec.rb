require 'spec_helper'

describe "catalog_items/_search" do
  
  it "renders photo and comment of catalog item" do
    view.should_receive( :render ).with( :partial => "index" )     
    render
   end

end
