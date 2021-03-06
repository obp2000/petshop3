require 'spec_helper'

describe "processed_orders/_form" do

  before do
    assign( :object, @processed_order = processed_orders_proxy.first.as_new_record )
    @processed_order.stub( :human_attribute_name ).and_return( "Test" )
  end
  
  it "renders new order form" do
    view.should_receive( :captcha_block )
    render
    rendered.should contain( @processed_order.human_attribute_name( :new_page_title ) )    
    rendered.should have_selector( "form#new_processed_order",
        :method => "post", :action => processed_orders_path ) do |form|
      form.should have_text_field( @processed_order, "email" )
      form.should have_text_field( @processed_order, "phone_number" )
      form.should have_text_field( @processed_order, "ship_to_first_name" )        
      form.should have_text_field( @processed_order, "ship_to_city" )
      form.should have_textarea( @processed_order, "ship_to_address" )      
      form.should have_textarea( @processed_order, "comments" )
      form.should have_selector( :input, :type => "submit" )
    end

  end

end
