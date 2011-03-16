require 'spec_helper'

describe "shared/_index" do

  context "test sizes" do
    before do
      @objects = sizes_proxy
      @object = sizes_proxy.first.as_new_record    
      @objects.stub( :new_partial ).and_return( "shared/attr" )
      @objects.stub( :edit_partial ).and_return( "shared/attr" )    
      view.stub( :link_to_add_to_item )
      @objects.first.stub( :link_to_delete ).and_return( link_to "Test", @objects.first, :remote => true,
            :method => :delete )
      @objects.second.stub( :link_to_delete ).and_return( link_to "Test", @objects.second, :remote => true,
            :method => :delete )           
      @objects.first.class.stub( :new1 ).and_return( sizes_proxy.first.as_new_record )
      view.stub( :submit_to ).and_return( image_submit_tag "test.png" )     
    end

    it "renders two existing objects and one new object" do
      view.should_receive( :link_to_close_window ).with( @objects.first )
      view.should_receive( :will_paginate ).with( @objects )
      view.should_receive( :link_to_add_to_item ).with( @objects.first ).once
      view.should_receive( :link_to_add_to_item ).with( @objects.second ).once        
      view.should_receive( :draggable_element ).with( @objects.first.class.name.tableize )
      render "shared/index", :objects => @objects
      @objects.each do |object|
        rendered.should have_selector( "form", :method => "post",
              :action => send( "#{object.class.name.underscore}_path", object ) ) do |form|
          form.should have_text_field( object, "name" )
          form.should have_image_input         
        end
        rendered.should have_selector( "a", :href => send( "#{object.class.name.underscore}_path",
                object ), "data-method" => "delete" )
      end
      rendered.should have_selector("form", :method => "post",
            :action => send( "#{@objects.first.class.name.tableize}_path")) do |form|
        form.should have_text_field( @objects.first, "name" )
        form.should have_image_input    
      end
    end
  end

  context "test colours" do
    before do
      @objects = colours_proxy
      @object = colours_proxy.first.as_new_record    
      @objects.stub( :new_partial ).and_return( "shared/attr" )
      @objects.stub( :edit_partial ).and_return( "shared/attr" )    
      view.stub( :link_to_add_to_item )
      view.stub( :link_to_add_html_code_to )      
      @objects.first.stub( :link_to_delete ).and_return( link_to "Test", @objects.first, :remote => true,
            :method => :delete )
      @objects.second.stub( :link_to_delete ).and_return( link_to "Test", @objects.second, :remote => true,
            :method => :delete )           
      @objects.first.class.stub( :new1 ).and_return( colours_proxy.first.as_new_record )
      view.stub( :submit_to ).and_return( image_submit_tag "test.png" )     
    end

    it "renders two existing objects and one new object" do
      view.should_receive( :link_to_close_window ).with( @objects.first )
      view.should_receive( :will_paginate ).with( @objects )
      view.should_receive( :link_to_add_html_code_to ).with( @objects.first ).once
      view.should_receive( :link_to_add_html_code_to ).with( @objects.second ).once      
      view.should_receive( :link_to_add_to_item ).with( @objects.first ).once
      view.should_receive( :link_to_add_to_item ).with( @objects.second ).once        
      view.should_receive( :draggable_element ).with( @objects.first.class.name.tableize )
      render "shared/index", :objects => @objects
      @objects.each do |object|
        rendered.should have_selector( "form", :method => "post",
              :action => send( "#{object.class.name.underscore}_path", object ) ) do |form|
          form.should have_text_field( object, "name" )                  
          form.should have_text_field( object, "html_code" )               
          form.should have_selector("input", :type => "color")
          form.should have_image_input         
        end
        rendered.should have_selector( "a", :href => send( "#{object.class.name.underscore}_path",
                object ), "data-method" => "delete" )
      end
      rendered.should have_selector("form", :method => "post",
            :action => send( "#{@objects.first.class.name.tableize}_path")) do |form|
          form.should have_text_field( @objects.first, "name" )                  
          form.should have_text_field( @objects.first, "html_code" )               
          form.should have_selector("input", :type => "color")
        form.should have_image_input    
      end
    end
  end

  context "test categories" do
    before do
      @objects = categories_proxy
      @object = categories_proxy.first.as_new_record    
      @objects.stub( :new_partial ).and_return( "shared/attr" )
      @objects.stub( :edit_partial ).and_return( "shared/attr" )    
      view.stub( :link_to_add_to_item )
      @objects.first.stub( :link_to_delete ).and_return( link_to "Test", @objects.first, :remote => true,
            :method => :delete )
      @objects.second.stub( :link_to_delete ).and_return( link_to "Test", @objects.second, :remote => true,
            :method => :delete )           
      @objects.first.class.stub( :new1 ).and_return( categories_proxy.first.as_new_record )
      view.stub( :submit_to ).and_return( image_submit_tag "test.png" )     
    end

    it "renders two existing objects and one new object" do
      view.should_receive( :link_to_close_window ).with( @objects.first )
      view.should_receive( :will_paginate ).with( @objects )
      view.should_receive( :link_to_add_to_item ).with( @objects.first ).once
      view.should_receive( :link_to_add_to_item ).with( @objects.second ).once        
      view.should_receive( :draggable_element ).with( @objects.first.class.name.tableize )
      render "shared/index", :objects => @objects
      @objects.each do |object|
        rendered.should have_selector( "form", :method => "post",
              :action => send( "#{object.class.name.underscore}_path", object ) ) do |form|
          form.should have_text_field( object, "name" )
          form.should have_image_input         
        end
        rendered.should have_selector( "a", :href => send( "#{object.class.name.underscore}_path",
                object ), "data-method" => "delete" )
      end
      rendered.should have_selector("form", :method => "post",
            :action => send( "#{@objects.first.class.name.tableize}_path")) do |form|
        form.should have_text_field( @objects.first, "name" )
        form.should have_image_input    
      end
    end
  end





end
