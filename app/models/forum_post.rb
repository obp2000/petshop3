# encoding: utf-8
class ForumPost < ActiveRecord1

  acts_as_threaded

  self.paginate_options = { :per_page => 15 }
  self.new_tag = "post_new"
  self.show_tag = "post"
  self.edit_partial = "form"

  class_inheritable_accessor :link_to_reply_dom_id, :parent_tag
  self.link_to_reply_dom_id = "link_to_reply"
  
  validates_length_of :name, :minimum => 2
  validates_length_of :subject, :minimum => 5
  validates_length_of :body, :minimum => 5

  scope :index_scope, order( "root_id desc, lft" )
  
  class << self

# actions
    def reply( params )
      new :parent_id => params[ :id ]
    end

    include ReplaceContent  

    def render_show( page )
      super
      page.fade new_tag
    end

  end

# actions
  def save_object( session )
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

  def destroy_object
    full_set.tap do |full_set|
      full_set.each { |forum_post| forum_post.delete }
    end
  end

# notices
  def create_notice
    self.class.human_attribute_name( parent_id.zero? ? :create_notice : :send_notice ) 
  end

  def destroy_notice
    self.class.human_attribute_name( :destroy_notice )
  end

# renders  
  def render_new_or_edit( page, session, controller_name )
    super
    page.fade show_tag
  end 

  attr_accessor_with_default( :parent_tag ) { "#{to_underscore}_#{parent_id}" }

  attr_accessor_with_default( :style ) { "margin-left: #{depth*20 + 30}px" }

  def render_reply( page, *args )
    self.class.superclass.instance_method( :render_new_or_edit ).bind( self )[ page, *args ]    
    page.fade link_to_reply_dom_id    
  end 
  
  def render_create_or_update( page, session, controller_name )
    page.create_forum_post [ ( parent_id.zero? ? "top"  : "after" ),
      ( parent_id.zero? ? dom_id : parent_tag ), { :partial => to_underscore, :object => self } ],
      [ show_tag, new_tag ]    
  end

end
