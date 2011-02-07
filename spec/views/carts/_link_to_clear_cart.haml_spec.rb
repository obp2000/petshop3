require 'spec_helper'

describe "carts/_link_to_clear_cart" do

  before do
    @cart = carts_proxy.first
    view.stub_chain( :session, :cart ).and_return( @cart )
    view.stub( :link_to_delete ).with( @cart ).and_return( link_to "Test", cart_path, :method => :delete, :remote => true )
  end

  context "when user can clear cart" do
    it "renders clear cart button" do
      view.stub( :do_not_show ).and_return( false )      
      render
      rendered.should have_link_to_remote_delete( cart_path )       
    end    
  end

  context "when user can not clear cart" do
    it "does not render clear cart button" do
      view.stub( :do_not_show ).and_return( true )      
      render
      rendered.should_not have_link_to_remote_delete( cart_path )       
    end    
  end

end
