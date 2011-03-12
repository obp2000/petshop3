module ReplaceContent

  attr_accessor_with_default( :replace ) { "replace_html" }  
  attr_accessor_with_default( :insert_or_replace ) { "replace_index_tag" }  
  attr_accessor_with_default( :index_tag ) { ContentTag }

end