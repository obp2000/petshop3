class ForumPostsController < ApplicationController
  before_filter :login_required, :only => [ :destroy ]
  
  def reply
    @object = controller_name.classify.constantize.reply( params )
    render( :update ) { |page| @object.render_reply( page, session ) }    
  end
  
end
