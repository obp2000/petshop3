# encoding: utf-8
class CatalogItem < Item

  class_inheritable_accessor :season_icon, :season_name
  self.season_icon = AllSeasonsImage
  self.season_name = I18n.t( :all_seasons )

#  self.show_tag = "details"
  self.paginate_options = { :per_page => 8 }
  self.js_for_show = []
  self.index_layout = "application"
  
  cattr_accessor :partial_path
  self.partial_path = tableize

  scope :ordered_by_id, order( :id )
  scope :with_category, lambda { |params| where( :category_id => params[ :category_id ] ) if
        params[ :category_id ] }
  scope :index_scope, lambda { |params| with_category( params ).ordered_by_id }
#  scope :group_by_category, group( :category_id )
  scope :group_by_category, find( :all, :select => "category_id", :group => :category_id )  

  class << self
    
    attr_accessor_with_default( :js_for_index ) { superclass.js_for_index << "attach_shadowOn" }
    
    def back( page )
      page.fade_appear( show_tag, tableize )
    end

    def render_show( page )
      super
      page.fade_appear( tableize, show_tag )
    end

# actions
    def search_results( params )
      search( *params.search_args )
    end

# notices
    def not_found_notice( params )
      "#{I18n.t( :on_your_query )} \"#{params[ :q ]}\" #{human_attribute_name( :not_found_notice )}"         
    end

    def season_page_title
      model_name.human + ': ' + season_name
    end

    def render_index( page, objects, session )
      page.render_catalog_items( session )
      super
    end 

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
  
  def search_args
    [ self[ :q ], { :page => self[ :page ], :per_page => 8, :order => :id, :sort_mode => :desc } ]
  end
  
end
