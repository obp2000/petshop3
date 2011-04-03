# encoding: utf-8
class ForumPost < ActiveRecord1

  acts_as_threaded

  self.paginate_options = { :per_page => 15 }

  class_inheritable_accessor :link_to_reply_dom_id, :parent_tag, :edit_partial, :new_tag
  self.link_to_reply_dom_id = "link_to_reply"
  self.edit_partial = "form"
  self.new_tag = "post_new"
  
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
      page.fade( new_tag )
    end

  end

# actions
  def save_object( * )
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
    @full_set_clone = full_set.clone
    full_set.each( &:delete )      
  end

# notices
  def create_notice() human_attribute_name( parent_id.zero? ? :create_notice : :send_notice ) end

  def destroy_notice() human_attribute_name( :destroy_notice ) end

# renders  
  def render_new_or_edit( page, *args )
    super
    page.fade show_tag
  end 

  def render_destroy( page, cart )
    @full_set_clone.each { |forum_post| forum_post.class.superclass.instance_method(
        :render_destroy ).bind( forum_post )[ page, cart ] }
  end

  def parent_tag() "#{underscore}_#{parent_id}" end
  def row_tag() tag end
  def style() "margin-left: #{depth*20 + 30}px" end

  def render_reply( page, *args )
    self.class.superclass.instance_method( :render_new_or_edit ).bind( self )[ page, *args ]    
    page.fade( link_to_reply_dom_id )    
  end 
  
  def render_create_or_update( page, session )
    page.render_create_forum_post self
  end

end
