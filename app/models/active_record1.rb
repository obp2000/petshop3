# encoding: utf-8
 class ActiveRecord1 < ActiveRecord::Base
   
  include ActiveModel::Validations
     
  self.abstract_class = true   
   
  class_inheritable_accessor :replace, :paginate_options, :insert_or_replace,
    :js_for_index, :js_for_show, :js_for_new_or_edit, :js_for_create_or_update,
    :index_tag, :index_partial, :show_tag, :edit_tag, :edit_partial,
    :new_tag, :new_partial, :row_partial, :partial_path, :index_layout, :new1

  self.paginate_options = {}
  self.js_for_index = [ "attach_yoxview" ]
  self.js_for_show = []
  self.js_for_new_or_edit = []
  self.js_for_create_or_update = []
  self.index_layout = ""
  
  scope :index_scope
    
  class << self

# actions
    def all_objects( params )
      index_scope( params ).paginate_objects( params )
    end
    
    def paginate_hash( params )
      paginate_options.merge :page => params[ :page ]
    end

    def paginate_objects( params )
      paginate paginate_hash( params )
    end 

    def find_current_object( params, session )
      find params[ :id ]
    end
    alias_method :find_object_for_update, :find_current_object

    attr_accessor_with_default( :new1 ) { new }      
    
    def new_object( params, session )
      new params[ underscore ]
    end
      
# renders    
    def render_index( page, objects, session )
      page.send insert_or_replace, index_tag, index_partial, objects
      page.attach_chain( js_for_index )
    end      

    def render_show( page )
      page.action :replace_html, show_tag, :partial => "#{partial_path}/show"      
      page.attach_chain( js_for_show )      
    end       

    delegate :tableize, :underscore, :to => :name

# tags and partials
    attr_accessor_with_default( :new_tag ) { "new_#{underscore}" }
    attr_accessor_with_default( :edit_partial ) { underscore }    
    attr_accessor_with_default( :new_partial ) { edit_partial }
    attr_accessor_with_default( :partial_path ) { tableize }
    attr_accessor_with_default( :index_partial ) { "#{partial_path}/index" }
    attr_accessor_with_default( :show_tag ) { underscore }
    attr_accessor_with_default( :attrs_tag ) { "form_#{tableize}" }  

  end

  delegate :tableize, :underscore, :attrs_tag, :to => "self.class"

  attr_accessor_with_default( :tag ) { ActionController::RecordIdentifier.dom_id( self ) }
  attr_accessor_with_default( :edit_tag ) { ActionController::RecordIdentifier.dom_id( self, :edit ) }
  attr_accessor_with_default( :row_tag ) { edit_tag }
  attr_accessor_with_default( :row_partial ) { edit_partial }

# actions
  def update_object( params )
    update_attributes( params[ underscore ] )
  end
    
  def destroy_object
    destroy
  end     
  
  def save_object( session )
    save
  end
    
# notices
  def create_notice
    "#{self.class.model_name.human} #{I18n.t(:successfully_created)}."
  end
  
  def update_notice
    "#{self.class.model_name.human} #{I18n.t(:successfully_updated)}."
  end
  
  def destroy_notice
    "#{self.class.model_name.human} #{I18n.t(:deleted)}."
  end     

# renders
  def render_new_or_edit( page, session )
    page.action replace, ( new_record? ? new_tag : edit_tag ),
          :partial => ( new_record? ? new_partial : edit_partial ), :object => self
    page.attach_chain( js_for_new_or_edit )     
  end 

  def render_create_or_update( page, session )
    page.render_create_or_update [ :remove, row_tag ],
            [ :bottom, tableize, { :partial => row_partial, :object => self } ]
    page.attach_chain( js_for_create_or_update )             
  end  
  
  def render_destroy( page, session )
    page.render_destroy( row_tag )
  end 

# links
  def link_to_category( season_catalog_items )
    name + " (#{send( season_catalog_items ).size})"
  end
    
  def delete_title 
    "#{I18n.t(:remove)} #{self.class.model_name.human} #{name rescue id}"
  end

end
