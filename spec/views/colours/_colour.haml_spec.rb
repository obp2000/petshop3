require 'spec_helper'

describe "colours/_colour" do
  
  before do
    @object = colours_proxy.first
    view.stub( :link_to_delete ).with( @object ).and_return( link_to "Test",  @object, :method => :delete, :remote => true )         
  end
  
  it_should_behave_like "edit and new forms"    
  
  it "renders a form for edit colour" do
    view.should_receive( :render_attrs ).with( @object )
    view.should_receive( :link_to_add_to_item1 ).with( @object )      
    render :partial => "colours/colour", :locals => { :colour => @object }
    rendered.should have_selector("form", :method => "post", :action => colour_path(@object)) do |form|
      form.should have_text_field( @object, "html_code" )               
      form.should have_selector("input", :type => "color")
      form.should have_image_input
    end
    rendered.should have_link_to_remote_delete( colour_path( @object ) )   
  end

  it "renders a form for a new colour" do
    @object = colours_proxy.first.as_new_record
    render :partial => "colours/colour", :locals => { :colour => @object }
    rendered.should have_selector("form", :method => "post", :action => colours_path) do |form|
      form.should have_text_field( @object, "html_code" )               
      form.should have_selector("input", :type => "color")       
      form.should have_image_input
    end
  end

end
