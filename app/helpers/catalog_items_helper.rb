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
    image_submit_tag AddToCartImage,
      :title => Cart.human_attribute_name( :add_this_catalog_item_to_cart ),
      :onmouseover => on_mouse( AddToCartOverImage ),
      :onmouseout => on_mouse( AddToCartImage ),
      :onclick => "$(this).fadeOut().fadeIn()"
  end

  def catalog_items_page_title
    if params[ :q ]
      "#{t( :query_results )} \"#{params[ :q ]}\" ( #{t( :all_found_items )}: #{@objects.size} )"     
    else
      @objects.instance_exec( params[ :category_id ] ) {
          |with_category| "#{human}#{ ': ' + category.name if with_category }" }      
    end
  end

  def render_catalog_items( cart )
    delay( Duration ) { check_cart_links( cart, false ) }
  end

  private
    def on_mouse( image ) "$(this).attr('src', 'images/" + image + "')" end

end