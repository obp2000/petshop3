shared_examples_for "catalog item" do
  
  it "renders one catalog item" do
    view.should_receive( :draggable_element ).with( dom_id( @object ), :revert => true )
    render
    rendered.should have_selector( "a[href*=" + @photo.photo_url[0..-5] + "]" ) do |a|
      a.should have_selector( "img[src*=" + @photo.photo.thumb.url + "]" )
    end
    rendered.should contain( @photo.comment )  
    rendered.should have_selector( "form", :method => "post", :action => cart_item_path( @object ) ) do |form|
      form.should have_link_to_remote_get( catalog_item_path( @object ) ) do |a|
        a.should contain( @object.name  )      
      end
      form.should contain( @object.price.to_s )      
      form.should have_image_input
    end    
  end

  it_should_behave_like "sizes and colours of catalog item"  
  
end

shared_examples_for "sizes and colours of catalog item" do

  context "when catalog item has more then one size and colour" do
    it "do renders 'any' size and color option" do
      render
      rendered.should contain( @object.sizes.first.name )
      rendered.should have_selector( "input", :type => "radio", :value => @object.sizes.first.to_param )    
      rendered.should contain( @object.sizes.second.name )
      rendered.should have_selector( "input", :type => "radio", :value => @object.sizes.second.to_param )    
      rendered.should have_colour( @object.colours.first.html_code )
      rendered.should have_selector( "input", :type => "radio", :value => @object.colours.first.to_param )    
      rendered.should have_colour( @object.colours.second.html_code )
      rendered.should have_selector( "input", :type => "radio", :value => @object.colours.second.to_param )    
      rendered.should contain( @object.class.human_attribute_name( :any_attr ) )     
      rendered.should have_selector( "input", :type => "radio", :id => "size_id_", :checked => "checked" )
      rendered.should have_selector( "input", :type => "radio", :id => "colour_id_", :checked => "checked" )      
      rendered.should contain( @object.blurb )
    end
  end

  context "when catalog item has only one size and only one colour" do
    it "do not renders 'any' size and color option" do
      @object.stub( :sizes ).and_return( [ sizes_proxy.first ] )
      @object.stub( :colours ).and_return( [ colours_proxy.first ] )
      @object.sizes.first.stub( :underscore ).and_return( "size" )
      @object.colours.first.stub( :underscore ).and_return( "colour" )      
      @object.stub_chain( :sizes, :class_name_rus_cap ).and_return( "Размер" )
      @object.stub_chain( :colours, :class_name_rus_cap ).and_return( "Цвет" )      
      render      
      rendered.should contain( @object.sizes.first.name )      
      rendered.should have_selector( "input", :type => "radio", :value => @object.sizes.first.to_param,
      :style => "visibility: hidden", :checked => "checked" ) 
      rendered.should have_colour( @object.colours.first.html_code )
      rendered.should have_selector( "input", :type => "radio", :value => @object.colours.first.to_param,
      :style => "visibility: hidden", :checked => "checked" )       
      rendered.should_not contain( @object.class.human_attribute_name( :any_attr ) )       
    end
  end   
  
end

shared_examples_for "item" do
  
  it "renders item" do
    view.should_receive( :link_to_delete ).with( @items.first ).and_return(
          link_to "Test", @items.first, :remote => true, :method => :delete )     
    render
    rendered.should have_selector( "tr", :onclick => "$.get('#{edit_item_path( @items.first )}')" )
    rendered.should contain(@items.first.name)
    rendered.should contain(@items.first.category_name)
    rendered.should contain( @items.first.sizes.first.name )
    rendered.should have_colour( @items.first.colours.first.html_code )     
    rendered.should contain(@items.first.price.to_s)
    rendered.should have_selector( "a", :href => send( "#{@items.first.class.name.underscore}_path",
          @items.first ), "data-method" => "delete" )    
  end
  
end

shared_examples_for "new or edit item form" do
  it "renders the items/form partial" do
    render
    rendered.should have_text_field( @item, "name" )
    rendered.should have_text_field( @item, "price" )    
    rendered.should have_link_to_remote_get( categories_path )    
    rendered.should have_selector( "input#item_type_summercatalogitem", :type => "radio",
            :name => "item[type]", :value => "SummerCatalogItem" )
    rendered.should have_selector( "input#item_type_wintercatalogitem", :type => "radio",
            :name => "item[type]", :value => "WinterCatalogItem" )              
    rendered.should have_link_to_remote_get( sizes_path )   
    rendered.should have_link_to_remote_get( colours_path )    
    rendered.should have_link_to_remote_get( photos_path )
    rendered.should have_textarea( @item, "blurb" )      
    rendered.should contain( l( @item.created_at, :format => :long ) )
    rendered.should contain( l( @item.updated_at, :format => :long ) )
    rendered.should have_selector( "input", :type => "image" )
    rendered.should contain( @category.name )
    rendered.should have_selector( "input#item_category_id", :type => "hidden", :name => "item[category_id]",
          :value => @category.to_param )

    rendered.should =~ /#{@size.name}/
    rendered.should have_item_hidden_field( @size )
    rendered.should have_selector( "input#item_#{@size.class.name.underscore}_ids_", :type => "hidden",
        :name => "item[#{@size.class.name.underscore}_ids][]", :value => "0" )
        
    rendered.should =~ /#{@colour.name}/
    rendered.should have_item_hidden_field( @colour )
    rendered.should have_selector( "input#item_#{@colour.class.name.underscore}_ids_", :type => "hidden",
        :name => "item[#{@colour.class.name.underscore}_ids][]", :value => "0" )
        
    rendered.should have_selector( "a", :href => @photo.photo_url ) do |a|
      a.should have_selector( "img", :src => "/images/" + @photo.photo.thumb.url )
    end    
    rendered.should have_selector( "textarea", :content => @photo.comment )
    rendered.should have_item_checkbox( @photo )        
        
  end
end

shared_examples_for "edit and new forms" do

  it "renders a form for edit object" do
    view.should_receive( :link_to_add_to_item ).with( @object )    
    render "#{@object.class.name.tableize}/#{@object.class.name.underscore}",
            @object.class.name.underscore.to_sym => @object
    rendered.should have_selector( "form", :method => "post", :action => send( "#{@object.class.name.underscore}_path", @object ) ) do |form|
      form.should have_text_field( @object, "name" )
      form.should have_image_input         
    end
    rendered.should have_selector( "a", :href => send( "#{@object.class.name.underscore}_path", @object ),
            "data-method" => "delete" )      
  end

  it "renders a form for a new object" do
    @object = @object.as_new_record
    render "#{@object.class.name.tableize}/#{@object.class.name.underscore}",
            @object.class.name.underscore.to_sym => @object
    rendered.should have_selector("form", :method => "post", :action => send( "#{@object.class.name.tableize}_path")) do |form|
      form.should have_text_field( @object, "name" )
      form.should have_image_input          
    end
  end

end





shared_examples_for "GET index" do
  it "assigns all objects as @objects, new object as @object and renders index template" do
      Colour.should_receive(:paginate).and_return([@colour_proxy])
      Colour.should_receive(:new).and_return(@colour_proxy)      
      xhr :get, :index
      assigns[:objects].should == [@colour_proxy]
      assigns[:object].should == @colour_proxy
      response.should render_template("shared/index")      
  end
end

shared_examples_for "new cart item with size_id == 0" do
  it "adds new cart item" do
    @cart_item, success = CartItem.update_object( @params, @session )
    @session.cart.cart_items.should include( @cart_item )
    @cart_item.amount.should == 1
    @cart_item.size_id.should == 0        
  end  
end

shared_examples_for "new cart item with size_id == single size_id" do
  it "adds new cart item" do
    @cart_item, success = CartItem.update_object( @params, @session )
    @session.cart.cart_items.should include( @cart_item )
    @cart_item.amount.should == 1
    @cart_item.size_id.should == @size.id        
  end  
end

shared_examples_for "when catalog item has one or some sizes" do
      context "when catalog item has some sizes" do
        it_should_behave_like "new cart item with size_id == 0"        
      end
      context "when catalog item has only one size" do
        before do
          @size = sizes_proxy.first           
        end
        it_should_behave_like "new cart item with size_id == single size_id"         
      end
end

shared_examples_for "form for more then one" do
  it "renders form for attr" do
    view.should_receive( :render_all_of_attr ).with( @attr, @catalog_item )
    @catalog_item.send( @attr.tableize ).size.should == 2
    view.should_receive( :render_any_of_attr ).with( @attr )    
    render :locals => { :attr => @attr, :catalog_item => @catalog_item }
#    response.should have_radio_button( @catalog_item.send( @attr.tableize ).first )
  end
end

shared_examples_for "form for only one" do
  it "renders form for attr" do
    view.should_receive(:render).with( :partial => "catalog_items/attr1", :collection => @catalog_item.send( @attr.tableize ),
                  :locals => { :checked => true, :visibility => "hidden" } )
    render :locals => { :attr => @attr, :catalog_item => @catalog_item }
  end
end

def create_cart_item
  @session = {}
  @item = Item.create!( valid_item_attributes )
  @params = { :id => "catalog_item_" + @item.id.to_s,
            :blurb => @item.blurb,
            :category_id => @item.category_id,
            :type => @item.type }
  @cart_item = CartItem.object_for_update( @params, @session.cart )
  @cart_item.update_object( @params )
end

def create_4_catalog_items_with_different_categories_and_seasons
  @category1 = Category.create!( valid_category_attributes )
  @size1 = Size.create!( valid_size_attributes )
  @colour1 = Colour.create!( valid_colour_attributes )  
  @category2 = Category.create!( valid_category_attributes2 )
  @size2 = Size.create!( valid_size_attributes2 )  
  @colour2 = Colour.create!( valid_colour_attributes2 )  
  
  @catalog_item = CatalogItem.create!( valid_item_attributes )
  @catalog_item.type = "SummerCatalogItem"
  @catalog_item.category = @category1
  @catalog_item.sizes = [ @size1 ]
  @catalog_item.colours = [ @colour1 ]  
  @catalog_item.save
  
  @catalog_item = CatalogItem.create!( valid_item_attributes )
  @catalog_item.type = "WinterCatalogItem"
  @catalog_item.category = @category1
  @catalog_item.sizes = [ @size2 ]
  @catalog_item.colours = [ @colour2 ]    
  @catalog_item.save
 
  @catalog_item = CatalogItem.create!( valid_item_attributes )
  @catalog_item.type = "SummerCatalogItem"
  @catalog_item.category = @category2
  @catalog_item.sizes = [ @size1 ]
  @catalog_item.colours = [ @colour1 ]    
  @catalog_item.save
  
  @catalog_item = CatalogItem.create!( valid_item_attributes )
  @catalog_item.type = "WinterCatalogItem"
  @catalog_item.name = "Jacket"  
  @catalog_item.price = "300"
  @catalog_item.category = @category2
  @catalog_item.sizes = [ @size2 ]
  @catalog_item.colours = [ @colour2 ]    
  @catalog_item.save 
  
end

def create_category
  @category = Category.new_object( @params )
  @category.save_object( @session )  
end

def create_colour
  @colour = Colour.new_object( @params )
  @colour.save_object( @session )
end

def create_photo
  @photo = Photo.new_object( @params )
  @photo.save_object( @session )
end

def create_size
  @size = Size.new_object( @params )
  @size.save_object( @session )
end

def create_item
  @item = Item.new_object( @params )
  @item.save_object( @session )  
end

def create_forum_post
  @forum_post = ForumPost.new_object( @params )
  @forum_post.save_object( @session )  
end

shared_examples_for "object" do

  before do
    controller.stub( :current_user ).and_return( users_proxy.first )
  end

  describe "GET index" do
    it "assigns all objects as @objects, new object as @object and renders index template" do
      @object.class.should_receive( :all_objects ).and_return( @objects = [ @object ] )
      @objects.should_receive( :render_index )
      xhr :get, :index
      assigns[:objects].should == [ @object ]
    end
  end

  describe "GET show" do
    it "assigns the requested object as @object and renders show template" do
      @object.class.should_receive( :find ).with( @object.to_param ).and_return( @object )
      @object.should_receive( :render_show )      
      xhr :get, :show, :id => @object.to_param
      assigns[ :object ].should equal( @object )
    end
  end

  describe "GET new" do
    it "assigns a new object as @object and renders new template" do
      @object.class.should_receive( :new ).and_return( @object )
      @object.should_receive( :render_new_or_edit )      
      xhr :get, :new
      assigns[ :object ].should equal( @object )
    end
  end

  describe "GET edit" do
    it "assigns the requested object as @object and renders new template" do
      @object.class.should_receive( :find ).with( @object.to_param ).and_return( @object )
      @object.should_receive( :render_new_or_edit )
      xhr :get, :edit, :id => @object.to_param
      assigns[ :object ].should equal( @object )
    end
  end

  describe "POST create" do
    it "creates a new object" do
      @object.class.should_receive( :new ).with( "name" => @object.name ).and_return( @object )            
      @object.should_receive( :save_object ).with( session )
      xhr :post, :create, @object.class.name.underscore => { "name" => @object.name }
    end

    context "with valid params" do
      it "assigns a newly created object as @object and renders create/update template" do
        controller.stub( :render_create ).and_return( ApplicationController.render_create )
        @object.class.should_receive( :new ).and_return( @object )
        @object.stub( :save_object ).and_return( true )
        @object.stub( :create_notice ).and_return( "Test" )
        @object.should_receive( :render_create_or_update )        
        xhr :post, :create, @object.class.name.underscore => { "name" => @object.name }
        assigns[ :object ].should equal( @object )
        flash.now[ :notice ].should == @object.create_notice 
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved object as @object and re-renders new/edit template" do
        @object.class.should_receive( :new_object ).and_return( @object )
        @object.stub( :save_object ).and_return( false )
        @object.should_receive( :render_new_or_edit )
        xhr :post, :create, @object.class.name.underscore => { "name" => @object.name }
        assigns[ :object ].should equal( @object )
      end
    end

  end

  describe "PUT update" do
    it "updates the requested object" do
      @object.class.should_receive( :find ).with( @object.to_param ).and_return( @object )
      @object.should_receive( :update_object ).with( 
            { @object.class.name.underscore => { "name" => "Test" },
            "action" => "update",
            "id" => @object.to_param,
            "controller" => @object.class.name.tableize }      
            ).and_return( [ @object, true ] )
      xhr :put, :update, :id => @object.to_param, @object.class.name.underscore => { "name" => "Test" }
    end

    context "with valid params" do
      it "assigns the requested object as @object and renders create/update template" do
        @object.class.stub( :find ).with( @object.to_param ).and_return( @object )
        @object.stub( :update_object ).and_return( true )
        @object.stub( :update_notice ).and_return( "Test" )        
        @object.should_receive( :render_create_or_update )
        xhr :put, :update, :id => @object.to_param
        assigns[ :object ].should == @object
        flash.now[ :notice ].should == @object.update_notice        
      end
    end

    context "with invalid params" do
      it "assigns the object as @object and re-renders new/edit template" do
        @object.class.stub( :find ).with( @object.to_param ).and_return( @object )        
        @object.stub( :update_object ).and_return( false )
        @object.should_receive( :render_new_or_edit )
        xhr :put, :update, :id => @object.to_param
        assigns[ :object ].should equal( @object )
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested object and renders destroy template" do
      @object.class.should_receive( :find ).with( @object.to_param ).and_return( @object )      
      @object.should_receive( :destroy_object )
      @object.stub( :destroy_notice ).and_return( "Test" )      
      @object.should_receive( :render_destroy )            
      xhr :delete, :destroy, :id => @object.to_param
      assigns[ :object ].should equal( @object )
      flash.now[ :notice ].should == @object.destroy_notice       
    end
  end  
    
end    
    
shared_examples_for "search" do
    
  describe "GET search" do
    
    it "assigns found catalog items as @objects index template" do
      @object.class.should_receive( :search_results ).and_return( @objects = [ @object ] )
      @objects.should_receive( :render_index )      
      xhr :get, :search
      assigns[ :objects ].should == [ @object ]
      flash.now[ :notice ].should be_blank       
    end
    
    context "when found nothing" do
      it "render not found notice" do
        @object.class.should_receive( :search_results ).and_return( [ ] )
        xhr :get, :search
        assigns[ :objects ].should == [ ]
        flash.now[ :notice ].should contain( @object.class.human_attribute_name( :not_found_notice ) )         
      end
    end
    
  end    
   
end
