# coding: utf-8
module ForumPostsHelper

  def render_create_forum_post( forum_post )    
    insert_html *forum_post.instance_exec { [ ( parent_id.zero? ? "top"  : "after" ),
      ( parent_id.zero? ? tableize : parent_tag ), { :partial => underscore, :object => self } ] }    
    fade forum_post.show_tag
    fade forum_post.new_tag
    show_notice
  end

  def link_to_reply
    link_to image_tag( NewForumPostImage ) + ForumPost.human_attribute_name( :reply ),
        reply_forum_post_path( @object ), :remote => true, :id => "link_to_reply"    
  end

end