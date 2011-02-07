require 'spec_helper'

class Item; end

describe "items/_index" do

  before do
    assigns[ :objects ] = items_proxy
    assigns[ :object ] = items_proxy.second.as_new_record
  end
  
  it "renders one existing item" do
    view.should_receive( :index_page_title_for ).with( Item )
    view.should_receive( :will_paginate ).with( assigns[:objects] )    
    view.should_receive( :render ).with( :partial => "item", :collection => assigns[ :objects ] )
    view.should_receive(:render).with( :partial => assigns[ :object ].class.new_or_edit_partial )      
    render :locals => { :objects => assigns[ :objects ], :object => assigns[ :object ] }
    rendered.should have_link_to_remote_get( items_path( :sort_by => "name", :index_text => "Название" ) )
    rendered.should have_link_to_remote_get( items_path( :sort_by => "sizes.first.name", :index_text => "Размер" ) )
    rendered.should have_link_to_remote_get( items_path( :sort_by => "colours.first.name", :index_text => "Цвет" ) )
    rendered.should have_link_to_remote_get( items_path( :sort_by => "category.name", :index_text => "Вид" ) )
    rendered.should have_link_to_remote_get( items_path( :sort_by => "price", :index_text => "Цена" ) )    
    rendered.should have_link_to_remote_get( new_item_path )
  end

end
