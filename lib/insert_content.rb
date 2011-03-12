module InsertContent

  attr_accessor_with_default( :replace ) { "replace" }  
  attr_accessor_with_default( :insert_or_replace ) { "insert_index_tag" }  
  attr_accessor_with_default( :index_tag ) { name.tableize }

end