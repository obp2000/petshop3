require 'spec_helper'

describe "carts/_link_to_new_order_form" do

  context "when user can make order" do
    it "renders link to new order form" do
      view.stub( :do_not_show ).and_return( false )      
      render
      rendered.should have_link_to_remote_get( new_processed_order_path )         
    end    
  end

  context "when user can not make order" do
    it "does not render link to new order form" do
      view.stub( :do_not_show ).and_return( true )      
      render
      rendered.should_not have_link_to_remote_get( new_processed_order_path )          
    end    
  end

end
