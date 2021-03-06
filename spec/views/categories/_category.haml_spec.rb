require 'spec_helper'

class Category; end

describe "categories/_category" do
  
  before do
    @object = categories_proxy.first
    view.stub( :link_to_delete ).with( @object ).and_return( link_to "Test", @object, :remote => true, :method => :delete )        
  end
  
  it_should_behave_like "edit and new forms"  

end
