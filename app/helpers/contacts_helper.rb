module ContactsHelper

  [ "address" ].each do |attr|
    define_method( "render_#{attr}_field_of" ) do |object, locals|
      render "#{object.partial_path}/text_area", { :object => object, :text_area => :"#{attr}" }.merge( locals )     
    end
  end  
  
  
end
