RSpec::Matchers.define :have_link_to_remote_get do |href|
  match do |response|
    extend Webrat::Matchers
    response.should have_selector( "a", :href => href )
  end
end

RSpec::Matchers.define :have_link_to_remote_delete do |href|
  match do |response|
    extend Webrat::Matchers
    response.should have_selector( "a[href*=#{href[1, 99]}]", "data-method" => "delete" )    
  end
end

RSpec::Matchers.define :have_link_to_remote_close do |href|
  match do |response|
    extend Webrat::Matchers
    response.should have_selector( "a", :href => href )     
  end
end

RSpec::Matchers.define :have_colour do |html_code|
  match do |response|
    extend Webrat::Matchers
    response.should have_selector( "span[style*=#{html_code[1,6].html_safe}]" )  
  end
end


RSpec::Matchers.define :have_text_field do |obj, attr|
  match do |response|
    extend Webrat::Matchers
    response.should have_selector( "input##{obj.class.name.underscore}_#{attr}", :type => "text",
                  :name => "#{obj.class.name.underscore}[#{attr}]", :value => obj.send( attr ).to_s )    
  end
end

RSpec::Matchers.define :have_textarea do |obj, attr|
  match do |response|
    extend Webrat::Matchers
    response.should have_selector( "textarea##{obj.class.name.underscore}_#{attr}",
                  :name => "#{obj.class.name.underscore}[#{attr}]", :content => obj.send( attr ) )                  
  end
end

RSpec::Matchers.define :have_item_checkbox do |obj|
  match do |response|
    extend Webrat::Matchers
    response.should have_selector( "input#item_#{obj.class.name.underscore}_ids_", :type => "checkbox",
          :name => "item[#{obj.class.name.underscore}_ids][]", :value => obj.to_param )       
  end
end

RSpec::Matchers.define :have_item_hidden_field do |obj|
  match do |response|
    extend Webrat::Matchers
    response.should have_selector( "input#item_#{obj.class.name.underscore}_ids_", :type => "hidden",
          :name => "item[#{obj.class.name.underscore}_ids][]", :value => obj.to_param )       
  end
end

RSpec::Matchers.define :have_thumbnail do |obj|
  match do |response|
    extend Webrat::Matchers
    response.should have_selector( "a", :href => obj.photo.thumb.url ) do |a|
      a.should have_selector( "img", :src => obj.photo_url )
    end
#    response.should have_selector( "a" )           
  end
end

RSpec::Matchers.define :have_radio_button do |obj|
  match do |response|
    extend Webrat::Matchers
    response.should have_selector( "input##{obj.class.name.underscore}_id_#{obj.id}", :type => "radio",
          :name => "#{obj.class.name.underscore}_id", :value => obj.to_param )          
  end
end

RSpec::Matchers.define :have_image_input do
  match do |response|
    extend Webrat::Matchers
    response.should have_selector( "input", :type => "image" )             
  end
end

RSpec::Matchers.define :have_password_field do |obj, attr|
  match do |response|
    extend Webrat::Matchers
    response.should have_selector( "input##{obj.class.name.underscore}_#{attr}", :type => "password",
                  :name => "#{obj.class.name.underscore}[#{attr}]", :value => obj.send( attr ).to_s )    
  end
end


class HaveLinkToRemoteDelete1
  
  def initialize(expected)
    @expected = expected
  end
  
  def matches?(target)
    @target = target
#    (@target =~ /^.*delete.*$/i) == 0 ? true : false
    @target.include?("_method=delete")
  end
  
  def failure_message
    "Ошибка"
  end
  
end


def link_to_remote_get( url )
  "$.ajax({dataType:'script', type:'get', url:'#{url}'}); return false;" 
end

def regexp_for_remote_get( url )
  /dataType:'script', type:'get', url:'#{url}'/
end

def regexp_for_remote_delete( url )
  /data:'_method=delete', dataType:'script', type:'post', url:'#{url}'/
end

def regexp_for_remote_close( url )
  /#{url}/
end
