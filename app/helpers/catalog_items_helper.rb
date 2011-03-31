# coding: utf-8
module CatalogItemsHelper

  def set_drop_receiving_element( element )
    with = <<-EOF
      'id=' + ($(ui.draggable).attr('id')) +
      '&size_id=' + ($(ui.draggable).find('[name=size_id]:checked').val()) + 
      '&colour_id=' + ($(ui.draggable).find('[name=colour_id]:checked').val())      
      EOF
    drop_receiving_element element, :with => with, :accept => ".catalog_item",
        :url => { :controller => "cart_items", :action => "update" },
        :tolerance => "touch", :hoverClass => "cart_hover "
  end
    
  def submit_to_cart
    image_submit_tag AddToCartImage, :title => Cart.human_attribute_name( :add_this_catalog_item_to_cart ),
     :onmouseover => on_mouse( AddToCartOverImage ),
     :onmouseout => on_mouse( AddToCartImage ),
     :onclick => "$(this).fadeOut().fadeIn()"
  end

  def index_page_title_for( objects )
    if params[ :q ]
      "#{t( :query_results )} \"#{params[ :q ]}\"
       ( #{t( :all_found_items )}: #{objects.first.class.search( *params.search_args ).size} )"     
    else
      "#{objects.first.class.season_page_title}#{': ' +
            Category.find( params[ :category_id ] ).name rescue ''}"
    end
  end

  def render_catalog_items( session )
    delay( Duration ) { check_cart_links( session, false ) }
  end

  private
    def on_mouse( image )
      "$(this).attr('src', 'images/" + image + "')"
    end

end