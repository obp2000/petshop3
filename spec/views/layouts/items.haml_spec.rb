require 'spec_helper'

describe "layouts/items" do
  
  it "renders main admin page" do
    render
    rendered.should have_link_to_remote_get( orders_path )    
    rendered.should have_link_to_remote_get( items_path )
    rendered.should have_link_to_remote_get( contacts_path )
    rendered.should have_selector( "a", :href => catalog_items_path )        
  end

end
