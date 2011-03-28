require 'spec_helper'

describe Colour do
  
  before do
    @valid_attributes = valid_colour_attributes
    @colour = Colour.new( @valid_attributes )
    @params = { "colour" => valid_colour_attributes }
    @updated_params = { "colour" => { :name => "Green", :html_code => "#00ff00" } }    
    @session = {}
  end

  it "is valid with valid attributes" do
    @colour.should be_valid
  end

  it "is not valid without a name" do
    @colour.name = nil
    @colour.should_not be_valid
  end

  it "is not valid without a html_code" do
    @colour.html_code = nil
    @colour.should_not be_valid
  end  
  
  it "should have unique name" do
    @colour = Colour.create(@valid_attributes)
    @colour.html_code = "#00FF00"
    @colour.save
    @colour = Colour.create(@valid_attributes)    
    @colour.errors.size.should == 1
  end

  it "should have unique html_code" do
    @colour = Colour.create(@valid_attributes)
    @colour.name = "Blue"
    @colour.save
    @colour = Colour.create(@valid_attributes)    
    @colour.errors.size.should == 1
  end

  describe "#new_object" do
  
    it "builds new colour" do
      @colour = Colour.new_object( @params, @session )
      @colour.name.should == valid_colour_attributes[ :name ]
    end
  
  end
 
  describe "#save_object" do
  
    it "saves new colour" do
      create_colour
      @colour.reload
      @colour.name.should == valid_colour_attributes[ :name ]
    end
  
  end  
  
  describe "#update_object" do
  
    it "updates existing colour" do
      create_colour
      @colour = Colour.find_current_object( { :id => @colour.id }, @session )
      @colour.update_object( @updated_params )
      @colour.name.should == @updated_params[ "colour" ][ :name ]
    end
  
  end
  
  describe "#destroy_object" do
  
    it "destroys existing colour" do
      create_colour
      @colour = Colour.find_current_object( { :id => @colour.id }, @session )
      @colour.destroy_object
      @colour.name.should == valid_colour_attributes[ :name ]
      Colour.all.should_not include( @colour )
    end
  
  end

end
