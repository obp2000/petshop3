# coding: utf-8
module CatalogItemsHelper

  def set_drop_receiving_element( element )
    with = <<-EOF
      'id=' + ($(ui.draggable).attr('id')) +
      '&size_id=' + ($(ui.draggable).find('[name=size_id]:checked').val()) + 
      '&colour_id=' + ($(ui.draggable).find('[name=colour_id]:checked').val())      
      EOF
    drop_receiving_element element, :with => with, :accept => ".catalog_item",
        :url => { :controller => "cart_items", :action => "update" }, :tolerance => "touch", :hoverClass => "cart_hover "
  end

#  def radio_button_tag_for( attr, checked, visibility ); attr.radio_button_tag1( self, checked, visibility ) end

##########

  [ "sizes", "colours" ].each do |attrs|
    define_method( :"render_#{attrs}_with_options_of" ) do |object|
      render :partial => "#{object.partial_path}/attr", :collection => object.send( attrs ),
        :locals => { :many => object.send( attrs ).many? }        
    end    
  end

  [ "price", "season" ].each do |attr|
    define_method( :"render_#{attr}_of" ) do |object|    
      render "#{object.partial_path}/#{attr}", :object => object
    end
  end

  def render_category_of( object, locals = {} )
    render *object.instance_exec { [ :partial => "#{partial_path}/category", :object => category,
        :locals => locals ] } unless object.category.blank?      
  end

  def render_photos_of( object )
    render *object.instance_exec { [ :partial => "#{partial_path}/photo", :collection => photos,
        :locals => { :attrs => photos } ] } unless object.photos.empty?     
  end

end