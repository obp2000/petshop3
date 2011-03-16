require 'spec_helper'

describe "processed_orders/_form" do

  before do
    assign( :object, @processed_order = processed_orders_proxy.first.as_new_record )
  end
  
  it "renders new order form" do
    view.should_receive( :new_page_title_for ).with( @processed_order ).and_return( "New page title" )    
    view.should_receive( :captcha_block )
    view.should_receive( :submit_to ).and_return( submit_tag )    
    render
    rendered.should contain( "New page title" )    
    rendered.should have_selector( "form#new_processed_order", :method => "post", :action => processed_orders_path ) do |form|
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
