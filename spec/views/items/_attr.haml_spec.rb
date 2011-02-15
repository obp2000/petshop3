require 'spec_helper'

describe "items/_attr" do

  before do
    @checked = true
    @visibility = "visible"
  end

  context "check sizes" do
    
    before do
      @attr = items_proxy.first.sizes.first
    end
    
    it "renders sizes with checkboxes" do
      view.should_receive( :link_to_remove_from_item ).with( @attr.class )      
      render :partial => "items/attr", :locals => { :attr => @attr }
      rendered.should =~ /#{@attr.name}/
      rendered.should have_item_hidden_field( @attr )
      rendered.should have_selector( "input#item_#{@attr.class.name.underscore}_ids_", :type => "hidden",
          :name => "item[#{@attr.class.name.underscore}_ids][]", :value => "0" )       
    end

  end

end