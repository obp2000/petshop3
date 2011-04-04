class ForumPostsController < ApplicationController
  before_filter :login_required, :only => [ :destroy ]
  
  def reply
    @object = current_model.reply( params )
    render( :update ) { |page| @object.render_reply( page, cart ) }    
  end
  
end
