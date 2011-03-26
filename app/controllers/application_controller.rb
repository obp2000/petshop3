# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
#  attr_accessor :cart
  helper :all # include all helpers, all the time
    
  #layout proc{ |c| c.request.xhr? ? false : "application" }

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery
  # :secret => 'd5ebb0195fbf794c1cf10debdde5e21c'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  include AuthenticatedSystem

  RenderIndex = lambda { render( :update ) { |page| @objects.render_index( page ) } }
  RenderShow = lambda { render( :update ) { |page| @object.class.render_show( page ) } }
  RenderNewOrEdit =
      lambda { render( :update ) { |page| @object.render_new_or_edit( page, session, controller_name ) } }  
  RenderCreateOrUpdate =
      lambda { render( :update ) { |page| @object.render_create_or_update( page, session, controller_name ) } }
  
  def index
    @object = controller_name.classify.constantize.new_object( params, session )    
    @objects = controller_name.classify.constantize.all_objects( params, flash )
    @objects = [ @object ] if @objects.empty?
    if request.xhr?
      RenderIndex.bind( self )[]
    else
      render :partial => "index", :layout => @objects.first.class.index_layout
    end
  end

  def show
    @object = controller_name.classify.constantize.find( params[ :id ] )
    RenderShow.bind( self )[]    
  end

  def new
    @object = controller_name.classify.constantize.new1
    RenderNewOrEdit.bind( self )[]     
  end

  def edit
    @object = controller_name.classify.constantize.find( params[ :id ] )
    RenderNewOrEdit.bind( self )[]    
  end

  def create( captcha_validated = nil )
    @object = controller_name.classify.constantize.new_object( params, session )
    session[ :captcha_validated ] = captcha_validated
    if @object.save_object( session, flash )
      flash.now[ :notice ] = @object.create_notice
      controller_name.classify.constantize.create_render_block.bind( self )[]      
    else
      RenderNewOrEdit.bind( self )[]
    end
  end

  def update
    @object, success = controller_name.classify.constantize.update_object( params, session, flash )
    if success
      flash.now[ :notice ] = @object.update_notice
      RenderCreateOrUpdate.bind( self ).call
    else
      RenderNewOrEdit.bind( self ).call      
    end
  end

  def destroy
    @objects = @object = controller_name.classify.constantize.destroy_object( params, session, flash )
    flash.now[ :notice ] = Array( @objects ).first.destroy_notice    
    render( :update ) { |page| Array( @objects ).render_destroy( page, session, controller_name ) }    
  end

  def close
    @object = controller_name.classify.constantize.close_object( params, session, flash )
    flash.now[ :notice ] = @object.close_notice    
    render( :update ) { |page| @object.render_close( page ) }      
  end    

end
