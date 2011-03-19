# coding: utf-8
module ForumPostsHelper

  def create_forum_post( insert_args, fade_tags )
    insert_html *insert_args
    fade_tags.each { |tag1| fade tag1 }    
    show_notice
  end

  def link_to_reply_to( object ); link_to *object.link_to_reply( self ) end

end