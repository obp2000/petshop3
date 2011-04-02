# coding: utf-8
module ForumPostsHelper

#  def render_create_forum_post( insert_args, fade_tags )
  def render_create_forum_post( forum_post )    
#    insert_html *insert_args
    insert_html *forum_post.instance_exec { [ ( parent_id.zero? ? "top"  : "after" ),
      ( parent_id.zero? ? tableize : parent_tag ),
      { :partial => underscore, :object => self } ] }    
    fade forum_post.show_tag
    fade forum_post.new_tag
#    fade_tags.each { |tag1| fade tag1 }    
    show_notice
  end

end