require 'spec_helper'

describe "shared/_index" do

  context "test sizes" do
    before do
      @objects = sizes_proxy
      @objects.stub( :new_partial ).and_return( "shared/attr" )
      @objects.stub( :edit_partial ).and_return( "shared/attr" )    
      @objects.stub( :new1 ).and_return( sizes_proxy.first.class.new )
      @objects.first.stub( :underscore ).and_return( "size" )
      @objects.second.stub( :underscore ).and_return( "size" )
    end

    it "renders two existing objects and one new object" do
      view.should_receive( :link_to_close_window ).with( @objects )
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
        form.should have_selector( :input, :type => "text",
              :name => "#{@objects.first.class.name.underscore}[name]" )
        form.should have_image_input    
      end
    end
  end

  context "test colours" do
    before do
      @objects = colours_proxy
      @objects.stub( :new_partial ).and_return( "shared/attr" )
      @objects.stub( :edit_partial ).and_return( "shared/attr" )    
      @objects.stub( :new1 ).and_return( colours_proxy.first.class.new )
      @objects.first.stub( :underscore ).and_return( "colour" )
      @objects.second.stub( :underscore ).and_return( "colour" )
      view.stub( :link_to_add_html_code_to )      
    end

    it "renders two existing objects and one new object" do
      view.should_receive( :link_to_close_window ).with( @objects )
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
          form.should have_selector( :input, :type => "text",
              :name => "#{@objects.first.class.name.underscore}[name]" )
          form.should have_selector( :input, :type => "text",
              :name => "#{@objects.first.class.name.underscore}[html_code]" )               
          form.should have_selector("input", :type => "color")
        form.should have_image_input    
      end
    end
  end

  context "test categories" do
    before do
      @objects = categories_proxy
      @objects.stub( :new_partial ).and_return( "shared/attr" )
      @objects.stub( :edit_partial ).and_return( "shared/attr" )    
      @objects.stub( :new1 ).and_return( categories_proxy.first.class.new )
      @objects.first.stub( :underscore ).and_return( "category" )
      @objects.second.stub( :underscore ).and_return( "category" )      
    end

    it "renders two existing objects and one new object" do
      view.should_receive( :link_to_close_window ).with( @objects )
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
          form.should have_selector( :input, :type => "text",
              :name => "#{@objects.first.class.name.underscore}[name]" )         
        form.should have_image_input    
      end
    end
  end

  context "test photos" do
    before do
      @objects = photos_proxy
      @objects.stub( :new_partial ).and_return( "photos/upload_photo" )
      @objects.stub( :edit_partial ).and_return( "shared/attr" )    
      @objects.stub( :new1 ).and_return( photos_proxy.first.class.new )
      @objects.first.stub( :underscore ).and_return( "photo" )
    end

    it "renders one existing photo and one new photo" do
      view.should_receive( :link_to_close_window ).with( @objects )
      view.should_receive( :will_paginate ).with( @objects )
      view.should_receive( :link_to_add_to_item ).with( @objects.first ).once
      view.should_receive( :draggable_element ).with( @objects.first.class.name.tableize )
      render "shared/index", :objects => @objects
      @objects.each do |object|
        rendered.should have_selector( "a", :href => object.photo_url ) do |a|
          a.should have_selector( "img", :src => "/images/" + object.photo.thumb.url )
        end
        rendered.should have_selector( "form", :method => "post",
              :action => send( "#{object.class.name.underscore}_path", object ) ) do |form|
          form.should have_textarea( object, "comment" ) 
          form.should have_image_input         
        end
        rendered.should have_selector( "a", :href => send( "#{object.class.name.underscore}_path",
                object ), "data-method" => "delete" )
      end
      rendered.should have_selector( "form", :method => "post",
              :action => send( "#{@objects.first.class.name.tableize}_path"),
              :enctype => "multipart/form-data", :target => "upload_frame" ) do |form|
        form.should have_selector("input", :type => "file")
        form.should have_image_input
      end      

    end
  end

  context "test contacts" do
    before do
      @objects = contacts_proxy
      @objects.stub( :edit_partial ).and_return( "contacts/contact" )    
      @objects.stub( :new1 ).and_return( false )
      view.stub( :will_paginate )       
    end

    it "renders one existing contact" do
      view.should_receive( :link_to_close_window ).with( @objects )
      view.should_receive( :draggable_element ).with( @objects.first.class.name.tableize )
      render "shared/index", :objects => @objects
      @objects.each do |object|
        rendered.should have_selector( "form", :method => "post",
              :action => send( "#{object.class.name.underscore}_path", object ) ) do |form|
          form.should have_text_field( object, "name" )
          form.should have_text_field( object, "email" )
          form.should have_text_field( object, "phone" )
          form.should have_text_field( object, "icq" )
          form.should have_textarea( object, "address" )           
          form.should have_image_input         
        end
      end

    end
  end

end
