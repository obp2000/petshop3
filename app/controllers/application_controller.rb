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

  class_inheritable_accessor :render_index, :render_show, :render_new_or_edit, :render_create, :render_update
  self.render_index = lambda { render( :update ) { |page| @objects.render_index( page, session ) } }
  self.render_show = lambda { render( :update ) { |page| @object.class.render_show( page ) } }
  self.render_new_or_edit =
    lambda { render( :update ) { |page| @object.render_new_or_edit( page, session ) } }
  self.render_create = self.render_update =
    lambda { render( :update ) { |page| @object.render_create_or_update( page, session ) } }  
  
  def index
    @object = controller_name.classify.constantize.new_object( params, session )    
    @objects = controller_name.classify.constantize.all_objects( params ) rescue [ @object ]
    if request.xhr?
      render_index.bind( self )[]
    else
      render :partial => "index", :layout => @objects.first.class.index_layout
    end
  end

  def show
    @object = controller_name.classify.constantize.find( params[ :id ] )
    render_show.bind( self )[]    
  end

  def new
    @object = controller_name.classify.constantize.new1
    render_new_or_edit.bind( self )[]     
  end

  def edit
    @object = controller_name.classify.constantize.find( params[ :id ] )
    render_new_or_edit.bind( self )[]    
  end

  def create
    @object = controller_name.classify.constantize.new_object( params, session )
    if @object.save_object( session )
      flash.now[ :notice ] = @object.create_notice
      render_create.bind( self )[]      
    else
      render_new_or_edit.bind( self )[]
    end
  end

  def update
    @object = controller_name.classify.constantize.find_object_for_update( params, session )    
    if @object.update_object( params )
      flash.now[ :notice ] = @object.update_notice
      render_update.bind( self )[]
    else
      render_new_or_edit.bind( self )[]      
    end
  end

  def destroy
    @object = controller_name.classify.constantize.find_current_object( params, session )
    @object.destroy_object
    flash.now[ :notice ] = @object.destroy_notice
    render( :update ) { |page| @object.render_destroy( page, session ) }      
  end

  def close
    @object = controller_name.classify.constantize.find_current_object( params, session )
    @object.close_object
    flash.now[ :notice ] = @object.close_notice    
    render( :update ) { |page| @object.render_close( page ) }      
  end    

end
