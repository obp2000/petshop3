# encoding: utf-8
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  [ :link_to_add_to_item, :link_to_show, :link_to_delete, :link_to_close, :link_to_new,
    :submit_to, :link_to_season, :link_to_show_with_comment, :link_to_reply_to,
    :link_to_logout, :link_to_add_html_code_to, :link_to_remove_from_item, :link_to_change,
    :link_to_index_local, :link_to_cart, :updated_at_or_link_to_close ].each do |method|
    define_method( method ) { |object| object.send( method, self ) }
  end

  [ :index_page_title_for, :show_page_title_for, :new_page_title_for ].each do |method|
    define_method( method ) { |object| object.send( method, params ) }
  end

  [ :render_attrs, :render_options ].each do |method|
    define_method( method ) { |object| Array( object ).send( method, self ) rescue nil }
  end

  def attach_js( js ); delay( DURATION + 0.1 ) { call( js ) } end

  def fade_appear( fade, appear ); fade_with_duration fade; appear_with_duration appear end

  def action( action1, *opts )
    fade_with_duration opts.first
    delay( DURATION ) { send( action1, *opts ); appear_with_duration opts.first unless action1 == :remove }       
  end
    
  def show_notice( opts = {} )
    appear_duration = 1
    fade_duration = opts[ :delay ] || appear_duration
    insert_html :top, :content, :partial => "shared/notice"
    self[ :notice ].hide
    appear_with_duration :notice, appear_duration    
    delay( appear_duration ) { fade_with_duration :notice, fade_duration; delay( fade_duration ) { self[ :notice ].remove } }
  end

  def check_cart_links; Cart.cart_links.each { |link| replace_html link, :partial => "carts/#{link}" } end

  def check_cart_totals( session ); session.cart.cart_totals.each { |args| replace_html *args } end

#  def red_star; render "shared/red_star" end
    
  def roubles( arg ); number_to_currency( arg, :unit => "", :precision => 0, :delimiter => " ") end

  def date_time_rus( arg ); arg.strftime( "%d.%m.%yг. %H:%M:%S" ) rescue "" end

  def do_not_show( cart ); controller_name == 'processed_orders' or cart.cart_items.empty? end
  
# links
  def link_to_index( class_const, params = nil ); class_const.link_to_index( self, params ) end    

  def link_to_category( category, season_class ); category.link_to_category( self, season_class.name.tableize ) end

  def link_to_close_window1( class_const )
    link_to_function( image_tag *class_const.close_window_image ) { |page| class_const.close_window( page ) }
  end

  def link_to_back1( class_const )
    link_to_function( image_tag *class_const.back_image ) { |page| class_const.back( page ) }
  end

  def link_to_add_to_item1( class_const )
    link_to_function( image_tag *class_const.add_to_item_image ) { |page| class_const.add_to_item1( page ) }
  end  
    
  def link_to_remote2( image = [], text = "", url = nil, opts = {} )
    link_to( ( image_tag( *image ) rescue "" ) + text.html_safe, url, { :remote => true }.merge( opts )  )
  end     


  def render_show( appear_tag, fade_tag, show_partial )
#    action :replace_html, appear_tag, :partial => show_partial
    self[ appear_tag ].replace_html :partial => show_partial
    fade_appear fade_tag, appear_tag          
  end

  def insert_index_partial( index_tag, index_partial, objects )
    remove_and_insert [ :remove, index_tag ], [ :after, "tabs", { :partial => index_partial, :locals => { :objects => objects } } ]       
  end

  def replace_index_partial( index_tag, index_partial, objects )
    page.action :replace_html, index_tag,  :partial => index_partial, :locals => { :objects => objects }    
  end
  
  def render_destroy( edit_tag, tag ); [ edit_tag, tag ].each { |tag1| action :remove, tag1 rescue nil } end
  
  def fade_with_duration( tag, duration = DURATION ); self[ tag ].fadeOut duration * 1000 end
  alias_method :fade, :fade_with_duration

  def appear_with_duration( tag, duration = DURATION );  self[ tag ].fadeIn duration * 1000 end  

  def render_create_or_update( remove_args, insert_args )
    remove_and_insert remove_args, insert_args    
    show_notice
    delay( DURATION ) { self[ remove_args[ 1 ] ].effect( "highlight", {}, HIGHLIGHT_DURATION * 1000 ) }
    fade_with_duration :errorExplanation        
  end

  def remove_and_insert( remove_args, insert_args )
    action *remove_args   
    delay( DURATION ) { insert_html *insert_args }
  end

  def colour_style( colour, index )
    "background-color: #{colour}; border: 1px solid black; margin-left: -#{index.zero? ? 0 : 6}px; margin-right: 0;"
  end

  def colour_render( colour ); ( "&nbsp;&nbsp;" ).html_safe * ( colour.html_code.split.second ? 1 : 2 ) end  
          
end

class Array
  
  def render_options( page )
    page.render :partial => "catalog_items/attr", :collection => self,
        :locals => { :checked => ( first.new_record? || !second ),
        :visibility => ( second || first.new_record? ) ? "visible" : "hidden" }
  end
 
#   def render_attrs( page )
#    return "Любой" if first.id.blank?     
#    page.render :partial => "shared/#{first.class.name.underscore}", :collection => self, :spacer_template => "shared/comma"
#    page.render self, :spacer_template => "shared/comma"
#  end 

  def render_destroy( page, session ); each { |object| object.render_destroy( page, session ) }; page.show_notice end   
  
  def render_index( page ); first.class.render_index( page, self ) rescue nil; page.show_notice end
 
  def update_object( params, session, flash )
    self[ 0 ].update_notice( flash ) if self[ 1 ] = self[ 0 ].update_object( params, session )
  end  
  
end

class Object
  
  attr_accessor_with_default( :colon ) { self + ":" }
#  def colon; self + ":" end

  attr_accessor_with_default( :total ) { inject(0) {|sum, n| n.price * n.amount + sum} }
#  def total; inject(0) {|sum, n| n.price * n.amount + sum} end

end

module ActionView::Helpers::PrototypeHelper::JavaScriptGenerator::GeneratorMethods 
  
#  def replace_html_with_delay( id, *options_for_render )
#    visual_effect :fade, opts.first
#    delay( DURATION ) { replace_html_without_delay( *opts ); visual_effect :appear, opts.first }
#    p "rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrreeeeeeeeeeeeee"
#    replace_html_without_delay( id, *options_for_render )
#  end
#  alias_method_chain :replace_html, :delay

end

class Hash

  attr_accessor_with_default( :cart ) { Cart.find_or_create self }
#  def cart; Cart.find_or_create self end
  
end

APPLICATION_TITLE = "Одежда для русских тоев BEST&C"
ADMIN_TITLE = "Администрирование магазина BEST&C"
RUB = "руб."
SHT = "шт."  
DEMO = "Демо"
REQUIRED_FIELDS = "обязательные поля"
ITOGO = "Итого"
VSE = "все"
DURATION = 0.5
HIGHLIGHT_DURATION = 2
SEASON = "Сезон"

WillPaginate::ViewHelpers.pagination_options[ :previous_label ] = 'Пред.'
WillPaginate::ViewHelpers.pagination_options[ :next_label ] = 'След.'
