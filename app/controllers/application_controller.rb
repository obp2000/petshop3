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
  
  helper_method :cart
  
  def cart
    session.cart
  end

#  before_filter :init_cart
  delegate :cart, :to => :session

  class_inheritable_accessor :render_index, :render_show, :render_new_or_edit,
        :render_create, :render_update, :render_notice
  self.render_index = lambda { render( :update ) { |page| @objects.render_index( page, cart ) } }
  self.render_show = lambda { render( :update ) { |page| @object.render_show( page ) } }
  self.render_new_or_edit =
    lambda { render( :update ) { |page| @object.render_new_or_edit( page, cart ) } }
  self.render_create = self.render_update =
    lambda { render( :update ) { |page| @object.render_create_or_update( page, cart ) } }
  self.render_notice = lambda { render( :update ) { |page| page.show_notice } }
  
  def index
    @object = current_model.new_object( params )    
    @objects = current_model.all_objects( params ) rescue [ @object ]
    if request.xhr?
      render_index.bind( self )[]
    else
      render :partial => "index", :layout => @objects.index_layout
    end
  end

  def show
    @object = current_model.current_object( params, cart )
    render_show.bind( self )[]    
  end

  def new
    @object = current_model.new
    render_new_or_edit.bind( self )[]     
  end

  def edit
    @object = current_model.current_object( params, cart )
    render_new_or_edit.bind( self )[]    
  end

  def create
    @object = current_model.new_object( params )
    if @object.save_object( session )
      flash.now[ :notice ] = @object.create_notice
      render_create.bind( self )[]      
    else
      render_new_or_edit.bind( self )[]
    end
  end

  def update
    @object = current_model.object_for_update( params, cart )    
    if @object.update_object( params )
      flash.now[ :notice ] = @object.update_notice
      render_update.bind( self )[]
    else
      render_new_or_edit.bind( self )[]      
    end
  end

  def destroy
    @object = current_model.current_object( params, cart )
    @object.destroy_object
    flash.now[ :notice ] = @object.destroy_notice
    render( :update ) { |page| @object.render_destroy( page, cart ) }      
  end

  def close
    @object = current_model.current_object( params, cart )
    @object.close_object
    flash.now[ :notice ] = @object.close_notice    
    render( :update ) { |page| @object.render_close( page ) }      
  end    

  private
#    def init_cart() @cart = session.cart end

    def current_model() controller_name.classify.constantize end

end
