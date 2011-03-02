require 'spec_helper'

describe "shared/_index" do

  before do
    @objects = sizes_proxy
  end

  it "renders index template" do
    view.should_receive( :link_to_close_window ).with( @objects.first.class )
    view.should_receive( :will_paginate ).with( @objects )
    view.should_receive( :draggable_element ).with( @objects.first.class.name.tableize )
    render :partial => "shared/index", :locals => { :objects => @objects }
    @objects.each do |object|
      rendered.should contain( object.name )
    end
  end

end
