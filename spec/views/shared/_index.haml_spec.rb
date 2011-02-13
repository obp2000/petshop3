require 'spec_helper'

describe "shared/_index" do

  before do
    @objects = sizes_proxy
    @objects.first.class.stub( :new ).and_return( sizes_proxy.first.as_new_record )
  end

  it "renders index template" do
    view.should_receive( :will_paginate ).with( @objects )
#    view.should_receive( :render ).with( :partial => @objects.first.class.new_partial, :object => @objects.first.class.new1 )
    view.should_receive( :link_to_close_window1 ).with( @objects.first.class )
    view.should_receive( :draggable_element ).with( @objects.first.class.name.tableize )
    render :partial => "shared/index", :locals => { :objects => @objects }
#    rendered.should =~ /\(&quot;##{@objects.first.class.name.tableize}&quot;\).remove/
  end

end
