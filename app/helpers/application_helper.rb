# encoding: utf-8
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def link_to_enlarge( object )
    link_to image_tag( object.photo.thumb.url ), object.photo_url    
  end

  def link_to_close( object )
    link_to image_tag( CloseProcessedOrderImage, :title => object.human_attribute_name( :close_title ) ),
        close_processed_order_path( object ), :remote => true, :id => object.close_tag,
        :confirm => object.human_attribute_name( :close_title ) + "?"   
  end

  def link_to_remove_from_item( object )
    link_to_function image_tag( DeleteImage, :title => Item.human_attribute_name( :delete_from_item_title ) ),
        object.delete_from_item_js    
  end

  def link_to_change( object )
    link_to image_tag( object.change_image,
      { :title => "#{t(:change)} #{object.human.pluralize}" } ), object, :remote => true    
  end

  def link_to_delete( object )
    link_to image_tag( DeleteImage, { :title => object.delete_title } ), object,
          :remote => true, :method => :delete, :confirm => object.delete_title + "?",
          :class => "link_to_delete"
  end

  def small_submit_button
    image_submit_tag SaveImageSmall, :title => ItemAttribute.human_attribute_name( :save )
  end

  def attach_js( js )
    delay( Duration + 0.2 ) { call( js ) }
  end

  def attach_chain( jses )
    delay( Duration + 0.2 ) { jses.each { |js| call js if js } }
  end

  def fade_appear( fade, appear )
    fade_with_duration fade
    appear_with_duration appear
  end

  def action( action1, *opts )
    fade_with_duration opts.first
    delay( Duration ) { send( action1, *opts )
    appear_with_duration opts.first unless action1 == :remove }       
  end
    
  def show_notice( opts = {} )
    appear_duration = 1
    fade_duration = opts[ :delay ] || appear_duration
    insert_html :top, :content, :partial => "shared/notice"
    self[ :notice ].hide
    appear_with_duration :notice, appear_duration    
    delay( appear_duration ) do
      fade_with_duration :notice, fade_duration
      delay( fade_duration ) { self[ :notice ].remove }
    end
  end

  def check_cart_links( cart, force_hide )
    select( "#cart > a, #cart .link_to_delete" ).send(
       ( force_hide or cart.cart_items.empty? ) ?
       "fadeOut().attr('style','visibility: hidden')" : "attr('style','visibility: visible').fadeIn()" )
  end
    
  def do_not_show_nav
    controller_name == "sessions" or controller_name == "users"
  end

  def link_to_category( category, season_catalog_items )
    link_to category.name + " (#{category.send( season_catalog_items ).size})",
      send( "category_#{season_catalog_items}_path", category ), :remote => true, :class => "category"
  end

  def link_to_close_window
    link_to_function( image_tag CloseWindowImage, :title => t( :close_window ) ) {
        |page| page.action :remove, @objects.tableize }
  end

  def link_to_back
    link_to_function( image_tag BackImage, :title => t( :back ) ) { |page| @object.back( page ) }
  end

  def link_to_add_to_item( object )
    link_to_function( image_tag AddToItemImage,
      :title => Item.human_attribute_name( :add_to_item_title ) ) { |page| object.add_to_item( page ) }
  end  

  def render_show( appear_tag, fade_tag, show_partial )
    action :replace_html, appear_tag, :partial => show_partial
#    self[ appear_tag ].replace_html :partial => show_partial
    fade_appear fade_tag, appear_tag          
  end

  def insert_index_tag( index_tag, index_partial )
    remove_and_insert [ :remove, index_tag ], [ :after, "tabs",
          { :partial => index_partial } ]       
  end

  def replace_index_tag( index_tag, index_partial )
    action :replace_html, index_tag, :partial => index_partial
  end
  
  def render_destroy( row_tag )
    action :remove, row_tag
    show_notice
  end
  
  def fade_with_duration( tag, duration = Duration )
    self[ tag ].fadeOut duration * 1000
  end
  alias_method :fade, :fade_with_duration

  def appear_with_duration( tag, duration = Duration )
    self[ tag ].fadeIn duration * 1000
  end  

  def render_create_or_update( remove_args, insert_args )
    remove_and_insert remove_args, insert_args    
    show_notice
    delay( Duration ) { self[ remove_args[ 1 ] ].effect( "highlight", {}, HighlightDuration * 1000 ) }
    fade_with_duration :errorExplanation        
  end

  def remove_and_insert( remove_args, insert_args )
    action *remove_args
    delay( Duration ) { insert_html *insert_args }
  end

  def colour_style( colour, index )
    "background-color: #{colour}; border: 1px solid black; margin-left: -#{index.zero? ? 0 : 6}px; margin-right: 0;"
  end

  def colour_render( colour )
    ( "&nbsp;&nbsp;" ).html_safe * ( colour.html_code.split.many? ? 1 : 2 )
  end
      
  def update_processed_orders_amount
    action :replace_html, :processed_orders_amount, :partial => "orders/processed_orders_amount"
  end
          
end

class Array

  def paginate_objects( params ) paginate paginate_hash( params ) end 

  delegate :show_tag, :new_tag, :new_partial, :edit_partial, :partial_path, :new,
    :destroy_notice, :new_record?, :new_attr, :category_name, :name,
    :render_index, :category, :to => :first 

  delegate :tableize, :new, :index_layout, :paginate_hash,
    :search, :grouped_category_name, :to => "first.class"
  
  delegate :human, :to => "first.class.model_name"

end

class Object
  
  def colon() self + ":" end

  def total() inject(0) { |sum, n| n.price * n.amount + sum } end
  
  def sum_amount() sum( :amount ) end

end

class Hash

  def cart() Cart.find_or_create self end
  
end

WillPaginate::ViewHelpers.pagination_options[ :previous_label ] = 'Пред.'
WillPaginate::ViewHelpers.pagination_options[ :next_label ] = 'След.'
