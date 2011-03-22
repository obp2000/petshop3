# encoding: utf-8
class ForumPost < ActiveRecord1
  acts_as_threaded

  self.index_image = [ "agt_forum.png" ]  
  self.new_image = [ "document-edit.png" ]
  self.new_text = human_attribute_name( :new_text )
  self.paginate_options = { :per_page => 15 }
  self.new_tag = "post_new"
  self.show_tag = "post"
  self.edit_partial = "form"

  class_inheritable_accessor :reply_image, :reply_text, :reply_render_block,
      :link_to_reply_dom_id, :parent_tag
  self.reply_image = [ new_image ]
  self.reply_text = human_attribute_name( :reply_text )
  self.reply_render_block = lambda { render :template => "shared/reply.rjs" }
  self.link_to_reply_dom_id = "link_to_reply"
  
  attr_accessor_with_default( :show_text ) { subject }
  attr_accessor_with_default( :style ) { "margin-left: #{depth*20 + 30}px" }
  
  validates_length_of :name, :minimum => 2
  validates_length_of :subject, :minimum => 5
  validates_length_of :body, :minimum => 5

  scope :index_scope, order( "root_id desc, lft" )
  
  class << self

# actions
    def reply( params ); new :parent_id => params[ :id ] end

# tags and partials    
    attr_accessor_with_default( :index_page_title_for ) { model_name.human }

    include ReplaceContent  

    def render_show( page ); super; page.fade new_tag end

  end

# actions
  def save_object( session, flash )
    super.tap do |success|
      if success
        if parent_id.zero?
          reload; self.root_id = self.id; save
        else
          self.class.find( parent_id ).add_child( self )
        end
      end
    end
  end

  def destroy_object; full_set.tap { |full_set| full_set.each { |forum_post| forum_post.delete } } end

#links
  def link_to_reply( page )
    [ ( page.image_tag( *reply_image ) rescue "" ) + reply_text.html_safe,
    page.send( "reply_#{to_underscore}_path", self ), { :remote => true, :id => link_to_reply_dom_id } ]      
  end


# notices
  def set_create_notice
    self.class.human_attribute_name( parent_id.zero? ? :create_notice : :send_notice ) 
  end

  def set_destroy_notice; self.class.human_attribute_name( :destroy_notice ) end

# renders  
  def render_new_or_edit( page ); super; page.fade show_tag end 

  attr_accessor_with_default( :parent_tag ) { "#{to_underscore}_#{parent_id}" }

  def render_reply( page )
    self.class.superclass.instance_method( :render_new_or_edit ).bind( self )[ page ]    
    page.fade link_to_reply_dom_id    
  end 
  
  def render_create_or_update( page, session )
    page.create_forum_post [ ( parent_id.zero? ? "top"  : "after" ),
      ( parent_id.zero? ? dom_id : parent_tag ), { :partial => to_underscore, :object => self } ],
      [ show_tag, new_tag ]    
  end

end
