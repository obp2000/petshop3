module ColoursHelper

  def link_to_add_html_code_to( object )
    link_to_function image_tag( AddHtmlCodeToColourImage,
          :title => Colour.human_attribute_name( :add_html_code_to_colour_title ) ),
          "$(this).prev('input').val( $(this).prev('input').val() + ' ' + $(this).next('input').val() )"
  end  
  
end
