# encoding: utf-8
class ForumPost < ActiveRecord1
  acts_as_threaded

  self.class_name_rus = "сообщение"  
  self.class_name_rus_cap = "Форум"
  self.index_image = [ "agt_forum.png" ]  
  self.index_text = "Форум"
  self.new_image = [ "document-edit.png" ]
  self.new_text = "Новая тема"
  self.submit_with_options = [ "submit_tag", "Отправить", { :onclick => "$(this).fadeOut().fadeIn()" } ]
  self.name_rus = "Автор"
  self.paginate_options = { :per_page => 15 }
  self.new_tag = "post_new"
  self.show_tag = "post"
  self.edit_partial = "form"

  class_inheritable_accessor :subject_rus, :body_rus, :reply_image, :reply_text, :reply_render_block,
      :link_to_reply_dom_id, :parent_tag
  self.subject_rus = "Тема"
  self.body_rus = "Сообщение"
  self.reply_image = [ new_image ]
  self.reply_text = "Ответить"
  self.reply_render_block = lambda { render :template => "shared/reply.rjs" }
  self.link_to_reply_dom_id = "link_to_reply"
  
  attr_accessor_with_default( :show_text ) { subject }
  attr_accessor_with_default( :style ) { "margin-left: #{depth*20 + 30}px" }
  
  validate :must_have_long_name, :must_have_long_subject, :must_have_long_body  
  
  def must_have_long_subject; errors.add :base, "#{subject_rus} слишком короткая (минимум 5 букв)" if subject.size < 5 end  
  
  def must_have_long_body; errors.add :base, "#{body_rus} слишком короткое (минимум 5 букв)" if body.size < 5 end

  scope :index_scope, order( "root_id desc, lft" )
  
  class << self

# actions
    def reply( params ); new :parent_id => params[ :id ] end

# tags and partials    
    attr_accessor_with_default( :index_page_title_for ) { class_name_rus_cap }

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

# notices
  def set_create_notice( flash ); flash.now[ :notice ] = parent_id.zero? ? "Новая тема создана" : "Сообщение отправлено" end

  def set_destroy_notice( flash ); flash.now[ :notice ] = "Ветвь сообщений удалена" end

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
