module ItemsHelper

  [ Size, Colour, Photo, Season, Category ].each do |class_const|
    define_method( :"render_#{class_const.name.tableize}_choose_partial_of" ) do |*args|
      object = args[0]
      locals = args[1] || {}
      render "#{object.partial_path}/#{class_const.attr_choose_partial}",
      { :object => object, :attrs => class_const.name.tableize }.merge( locals )       
    end
  end

  def render_attrs_with_link_to_remove_of( object, attrs, locals = {} )
    render :partial => "#{object.partial_path}/#{object.send( attrs ).partial_for_attr_with_link_to_remove}",
          :collection => object.send( attrs ), :locals => locals    
  end

  [ "created", "updated" ].each do |time|
    define_method( :"render_#{time}_time_of" ) do |object|
      render "time_rus", { :object => object, :time => :"#{time}_at" } 
    end
  end

  [ "size", "colour" ].each do |attr|
    define_method( "render_#{attr.pluralize}_of" ) do |object|
      render :partial => "#{SharedPath}/#{attr}", :collection => object.send( attr.pluralize ),
        :locals => { :attrs => object.send( attr.pluralize ) } unless object.send( attr.pluralize ).empty?      
    end
  end   
  
  
end
