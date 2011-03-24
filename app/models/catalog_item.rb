# encoding: utf-8
class CatalogItem < Item

  class_inheritable_accessor :season_icon, :season_name
  self.season_icon = AllSeasonsImage
  self.season_name = I18n.t( :all_seasons )

  self.show_tag = "details"

  self.index_render_block =
    lambda { render request.xhr? ? Index_template_hash : { :partial => "index", :layout => "application" } }
  self.paginate_options = { :per_page => 8 }
  self.js_for_show = []
  
  cattr_accessor :row_partial, :partial_path
  self.row_partial = name.underscore  
  self.partial_path = name.tableize

  scope :ordered_by_id, order( :id )
  scope :with_category, lambda { |params| where( :category_id => params[ :category_id ] ) if
        params[ :category_id ] }
  scope :index_scope, lambda { |params| with_category( params ).ordered_by_id }
  scope :group_by_category, group( :category_id )

  class << self
    
    attr_accessor_with_default( :js_for_index ) { superclass.js_for_index << "attach_shadowOn" }
    
    def back( page ); page.fade_appear( show_tag, dom_id ) end

    def render_show( page )
      super
      page.fade_appear dom_id, show_tag
    end

# actions
    def search_results( params, flash )
      flash.now[ :notice ] = not_found_notice( params ) if
          ( results = search( *params.search_args ) ).empty?              
      results
    end

# notices
    def not_found_notice( params )
      "#{I18n.t( :on_your_query )} \"#{params[ :q ]}\" #{human_attribute_name( :not_found_notice )}"         
    end

    def season_page_title; model_name.human + ': ' + season_name end

  end

#ts
  define_index do
    indexes name
    indexes blurb
    indexes colours.name, :as => :colours_name
    indexes sizes.name, :as => :sizes_name
    indexes category.name, :as => :category_name
    indexes photos.comment, :as => :photos_comment
    has :id
  end
  
end

class Hash
  
  def search_args; [ self[ :q ], { :page => self[ :page ], :per_page => 8, :order => :id, :sort_mode => :desc } ] end
  
end
