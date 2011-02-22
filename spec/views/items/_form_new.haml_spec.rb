require 'spec_helper'

describe "items/_form" do
  before do
    assign( :object, @item = items_proxy.second.as_new_record )
  end
  
  context "when the item is a new record" do
    it_should_behave_like "a template that renders the items/form partial"
    it "renders the form for new item" do
      render
      rendered.should have_selector( "form", :method => "post", :action => items_path )
    end
  end

end