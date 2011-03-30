# coding: utf-8
module ForumPostsHelper

  def render_create_forum_post( insert_args, fade_tags )
    insert_html *insert_args
    fade_tags.each { |tag1| fade tag1 }    
    show_notice
  end

end