# encoding: utf-8
 class ActiveRecord1 < ActiveRecord::Base
   
  include ActiveModel::Validations
     
  self.abstract_class = true   

  Index_template_hash = { :template => "shared/index.rjs" }
  Show_template_hash = { :template => "shared/show.rjs" }
  New_or_edit_template_hash = { :template => "shared/new_or_edit.rjs" }
  Create_or_update_template_hash = { :template => "shared/create_or_update.rjs" }
  Destroy_template_hash = { :template => "shared/destroy.rjs" }
   
  class_inheritable_accessor :class_name_rus, :class_name_rus_cap, :back_image, :delete_image, :delete_title,
    :close_window_image, :submit_image, :submit_text, :created_at_rus, :updated_at_rus,
    :index_image, :index_text, :replace, :delete_text, :nav_image, :nav_text, 
    :new_image, :new_text, :show_image, :name_rus, :submit_with_options, :change_text,
    :paginate_options, :insert_or_replace,    
    :index_render_block, :show_render_block, :new_render_block, :edit_render_block, :create_render_block,
    :update_render_block, :destroy_render_block,
    :js_for_index, :js_for_show, :js_for_new_or_edit, :js_for_create_or_update,
    :index_tag, :index_partial,
    :show_tag, :show_partial,
    :edit_tag, :edit_partial,
    :new_tag, :new_partial,
    :partial_path,
    :row_partial,
    :dom_id,
    :headers,
    :create_or_update_partial
    
  self.class_name_rus = ""
  self.class_name_rus_cap = ""  
  self.back_image = [ "back1.png", { :title => "Назад" } ]
  self.delete_image = "delete.png"
  self.delete_text = ""
  self.close_window_image = [ "close.png", { :title => "Закрыть окно" } ]
  self.submit_with_options = [ "image_submit_tag", "document-save-16.png", { :title => "Сохранить" } ]    
  self.created_at_rus = "Создан"  
  self.updated_at_rus = "Изменён"
  self.index_image = []
  self.index_text = ""
  self.show_image = []
#  self.replace = :replace     
  self.nav_image = []
  self.nav_text = ""
  self.new_image = []
  self.new_text = ""
  self.name_rus = ""
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
  attr_accessor_with_default( :delete_title ) { "Удалить #{class_name_rus} #{name rescue id}?" }
  attr_accessor_with_default( :tag ) { "#{to_underscore}_#{id}" }
  attr_accessor_with_default( :edit_tag ) { "edit_#{to_underscore}_#{id}" }
  attr_accessor_with_default( :create_or_update_tag ) { edit_tag }
  attr_accessor_with_default( :create_or_update_partial ) { edit_partial }
  attr_accessor_with_default( :single_path ) { [ "#{to_underscore}_path", self ] }      
  
  def must_have_name
    errors.add :base, "#{class_name_rus_cap} не может быть пустым" if name.blank?      
  end  
  
  def must_have_long_name
    errors.add :base, "В имени должно быть не менее двух символов" if name.size < 2     
  end  

  def must_have_valid_email
    errors.add :base, "Неверный формат адреса электронной почты" if email !~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i     
  end 
  
  scope :index_scope
    
  class << self

# actions
    def all_objects( params, * ); index_scope( params ).paginate_objects( params ) end
    
    def paginate_hash( params ); paginate_options.merge :page => params[ :page ] end

    def paginate_objects( params ); paginate paginate_hash( params ) end 

    def find_current_object( params, session ); find params[ :id ] end
    alias_method :find_object_for_update, :find_current_object

    def update_object( params, session, flash )
      find_object_for_update( params, session ).update_object( params ).tap {
            |result| result.first.set_update_notice( flash ) if result.second }
    end

    def destroy_object( params, session, flash )
      find_current_object( params, session ).tap { |result| result.set_destroy_notice( flash ) }.destroy_object
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
      
# links back
    def link_to_new( page )
      page.link_to_remote2 new_image, new_text, page.send( "new_#{name.underscore}_path" ), :id => "link_to_new"
    end

    def link_to_index( page, params = nil )
      page.link_to_remote2 index_image, ( params[ :index_text ] rescue class_name_rus_cap.pluralize ),
          page.send( "#{name.tableize}_path", params )      
    end

    def link_to_season( page ); page.link_to_remote2 nil, "Всего (#{count})", self end      
      
#    def submit_to( page ); page.send( *submit_with_options ) end      

# tags and partials
    attr_accessor_with_default( :new_tag ) { "new_#{name.underscore}" }
    attr_accessor_with_default( :new_partial ) { edit_partial }
    
    attr_accessor_with_default( :row_partial ) { name.underscore }    
    attr_accessor_with_default( :partial_path ) { name.tableize }
    attr_accessor_with_default( :dom_id ) { name.tableize }   
    
    attr_accessor_with_default( :index_partial ) { "#{partial_path}/index" }
    attr_accessor_with_default( :show_partial ) { "#{partial_path}/show" }     
      
# JS
    def close_window( page ); page.action :remove, dom_id end  

    attr_accessor_with_default( :class_name_rus_cap_first ) { class_name_rus_cap.split.first }

  end

  attr_accessor_with_default( :to_underscore ) { self.class.name.underscore }

# actions
  def update_object( params ); [ self, update_attributes( params[ to_underscore ] ) ] end
    
  def destroy_object; destroy end     
  
  def save_object( session, flash ); save.tap { |success| set_create_notice( flash ) if success } end
    
# notices
  def set_create_notice( flash ); flash.now[ :notice ] = "#{class_name_rus_cap} создан удачно." end
  def set_update_notice( flash ); flash.now[ :notice ] = "#{class_name_rus_cap} удачно обновлён." end
  def set_destroy_notice( flash ); flash.now[ :notice ] = "#{class_name_rus_cap} удалён." end     

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
  def link_to_category( page, seasons )
    page.link_to_remote2 [], name + " (#{send( seasons ).size})",
          page.send( "category_#{seasons}_path", self ), :class => "category"
  end

  def link_to_show( page ); ( page.link_to_remote2 show_image, show_text, self ) rescue deleted_notice end    

  def link_to_delete( page ) 
    page.link_to_remote2 [ delete_image, { :title => delete_title } ], delete_text, self, :method => :delete,
            :confirm => delete_title
  end

end
