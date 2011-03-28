class PhotosController < Admin::BaseController

  self.render_create =
      lambda {  responds_to_parent {
          render( :update ) { |page| @object.render_create_or_update( page, session, controller_name ) } }      
     }

end
