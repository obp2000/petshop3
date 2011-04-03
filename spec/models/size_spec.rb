require 'spec_helper'

describe Size do
  
  before do
    @valid_attributes = valid_size_attributes
    @size = Size.new( @valid_attributes )
    @params = { "size" => valid_size_attributes }
    @updated_params = { "size" => { :name => "S" } }      
    @session = {}
  end

  it "is valid with valid attributes" do
    @size.should be_valid
  end

  it "is not valid without a name" do
    @size.name = nil
    @size.should_not be_valid
  end
  
  it "should have unique name" do
    @size = Size.create(@valid_attributes)
    @size = Size.create(@valid_attributes)    
    @size.errors.size.should == 1
  end

  describe "#new_object" do
  
    it "builds new size" do
      @size = Size.new_object( @params )
      @size.name.should == valid_size_attributes[ :name ]
    end
  
  end
 
  describe "#save_object" do
  
    it "saves new size" do
      create_size
      @size.reload
      @size.name.should == valid_size_attributes[ :name ]
    end
  
  end  
  
  describe "#update_object" do
  
    it "updates existing size" do
      create_size
      @size = Size.find_current_object( { :id => @size.id }, @session.cart )
      @size.update_object( @updated_params )
      @size.name.should == @updated_params[ "size" ][ :name ]
    end
  
  end
  
  describe "#destroy_object" do
  
    it "destroys existing size" do
      create_size
      @params_for_destroy = { :id => @size.id }
      @size = Size.find_current_object( @params_for_destroy, @session.cart )
      @size.destroy_object
      @size.name.should == valid_size_attributes[ :name ]
      Size.all.should_not include( @size )
    end
  
  end

end
