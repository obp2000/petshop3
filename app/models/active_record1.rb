# encoding: utf-8
 class ActiveRecord1 < ActiveRecord::Base
   
  include ActiveModel::Validations
     
  self.abstract_class = true   

  Index_template_hash = { :template => "shared/index.rjs" }
  Show_template_hash = { :template => "shared/show.rjs" }
  New_or_edit_template_hash = { :template => "shared/new_or_edit.rjs" }
  Create_or_update_template_hash = { :template => "shared/create_or_update.rjs" }
  Destroy_template_hash = { :template => "shared/destroy.rjs" }
   
  class_inheritable_accessor :replace, :paginate_options, :insert_or_replace,    
    :index_render_block, :show_render_block, :new_render_block, :edit_render_block, :create_render_block,
    :update_render_block, :destroy_render_block,
    :js_for_index, :js_for_show, :js_for_new_or_edit, :js_for_create_or_update,
    :index_tag, :index_partial, :show_tag, :show_partial, :edit_tag, :edit_partial,
    :new_tag, :new_partial, :partial_path, :row_partial, :dom_id, :headers, :create_or_update_partial

  self.index_render_block = lambda { render Index_template_hash }
  self.show_render_block = lambda { render Show_template_hash }
  self.new_render_block = self.edit_render_block = lambda { render New_or_edit_template_hash }
  self.create_render_block = self.update_render_block = lambda { render Create_or_update_template_hash }
  self.destroy_render_block = lambda { render Destroy_template_hash }
  self.paginate_options = {}
  self.js_for_index = [ "attach_yoxview" ] 
  self.js_for_show = []
  self.js_for_new_or_edit = []
  self.js_for_create_or_update = []
  
  attr_accessor_with_default( :show_text ) { name }
  attr_accessor_with_default( :tag ) { "#{to_underscore}_#{id}" }
  attr_accessor_with_default( :edit_tag ) { "edit_#{to_underscore}_#{id}" }
  attr_accessor_with_default( :create_or_update_tag ) { edit_tag }
  attr_accessor_with_default( :create_or_update_partial ) { edit_partial }
  attr_accessor_with_default( :single_path ) { [ "#{to_underscore}_path", self ] }      
  
  scope :index_scope
    
  class << self

# actions
    def all_objects( params, * )
      index_scope( params ).paginate_objects( params )
    end
    
    def paginate_hash( params ); paginate_options.merge :page => params[ :page ] end

    def paginate_objects( params ); paginate paginate_hash( params ) end 

    def find_current_object( params, session ); find params[ :id ] end
    alias_method :find_object_for_update, :find_current_object

    def update_object( params, session, flash )
      find_object_for_update( params, session ).update_object( params ).tap do |result|
        flash.now[ :notice ] = result.first.set_update_notice if result.second
      end
    end

    def destroy_object( params, session, flash )
      find_current_object( params, session ).tap do |result|
        flash.now[ :notice ] = result.set_destroy_notice 
      end.destroy_object
    end     

    attr_accessor_with_default( :new1 ) { new }      
    
    def new_object( params, session ); new params[ name.underscore ] end
      
# renders    
    def render_index( page, objects )
      page.send insert_or_replace, index_tag, index_partial, objects
      page.attach_chain( js_for_index )
    end      

    def render_show( page )
      page.action :replace_html, show_tag, :partial => show_partial      
      page.attach_chain( js_for_show )      
    end       

# tags and partials
    attr_accessor_with_default( :new_tag ) { "new_#{name.underscore}" }
    attr_accessor_with_default( :edit_partial ) { name.underscore }    
    attr_accessor_with_default( :new_partial ) { edit_partial }
    
    attr_accessor_with_default( :row_partial ) { name.underscore }    
    attr_accessor_with_default( :partial_path ) { name.tableize }
    attr_accessor_with_default( :dom_id ) { name.tableize }   
    
    attr_accessor_with_default( :index_partial ) { "#{partial_path}/index" }
    attr_accessor_with_default( :show_partial ) { "#{partial_path}/show" }     

  end

  attr_accessor_with_default( :to_underscore ) { self.class.name.underscore }

# actions
  def update_object( params ); [ self, update_attributes( params[ to_underscore ] ) ] end
    
  def destroy_object; destroy end     
  
  def save_object( session, flash )
    save.tap do |success|
      flash.now[ :notice ] = set_create_notice if success
    end
  end
    
# notices
  def set_create_notice
    "#{self.class.model_name.human} #{I18n.t(:successfully_created)}."
  end
  
  def set_update_notice
    "#{self.class.model_name.human} #{I18n.t(:successfully_updated)}."
  end
  
  def set_destroy_notice
    "#{self.class.model_name.human} #{I18n.t(:deleted)}."
  end     

# renders
  def render_new_or_edit( page )
    page.action replace, ( new_record? ? new_tag : edit_tag ),
          :partial => ( new_record? ? new_partial : edit_partial ), :object => self
    page.attach_chain( js_for_new_or_edit )     
  end 

  def render_create_or_update( page, session )
    page.render_create_or_update [ :remove, create_or_update_tag ],
            [ :bottom, dom_id, { :partial => create_or_update_partial, :object => self } ]
    page.attach_chain( js_for_create_or_update )             
  end  
  
  def render_destroy( page, session ); page.render_destroy edit_tag, tag end 

# links
  def link_to_category( season_catalog_items )
    name + " (#{send( season_catalog_items ).size})"
  end
    
  def delete_title 
    "#{I18n.t(:remove)} #{self.class.model_name.human} #{name rescue id}"
  end

end
