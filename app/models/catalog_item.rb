# encoding: utf-8
class CatalogItem < Item

  class_inheritable_accessor :season_icon, :season_name
  self.season_icon = "amor.png"
  self.season_name = "Все сезоны"
  
  self.index_text = "Назад в магазин"    
  self.submit_with_options = [ "image_submit_tag", "search_32.png", { :title => "Поиск #{class_name_rus}а" } ]
  self.index_render_block =
    lambda { render request.xhr? ? Index_template_hash : { :partial => "index", :layout => "application" } }
  self.paginate_options = { :per_page => 8 }
  self.js_for_show = []
  
  cattr_accessor :row_partial, :partial_path
  self.row_partial = name.underscore  
  self.partial_path = name.tableize
  
  self.thumb_path = SharedPath

  scope :ordered_by_id, order( :id )
  scope :with_category, lambda { |params| where( :category_id => params[ :category_id ] ) if params[ :category_id ] }
  scope :index_scope, lambda { |params| with_category( params ).ordered_by_id }
#  scope :group_by_category, group( :category_id )

  class << self
    
    attr_accessor_with_default( :js_for_index ) { superclass.js_for_index << "attach_shadowOn" }
    
    def back( page ); page.fade_appear( show_tag, name.tableize ) end     

    def render_show( page ); super; page.fade_appear name.tableize, show_tag end

# actions
    def search_results( params, flash )
      not_found_notice( params, flash ) if ( results = search( *params.search_args ) ).empty?              
      results
    end

# links    
    def link_to_index_local( page ); page.link_to index_text, self end

# tags and partials
    attr_accessor_with_default( :show_tag ) { "details" }

# notices
    def not_found_notice( params, flash )
      flash.now[ :notice ] = "По Вашему запросу \"#{params[ :q ]}\" #{class_name_rus}ы не найдены"         
    end

    def index_page_title_for( params )
      if params[ :q ]
        "Результаты поиска по запросу \"#{params[ :q ]}\" ( всего найдено #{class_name_rus}ов: #{search( *params.search_args ).size} )"
      else
        "Каталог #{class_name_rus}ов#{': ' + season_name}#{': ' + Category.find( params[ :category_id ] ).name rescue ''}"      
      end
    end

  end

#  attr_accessor_with_default( :edit_tag ) { self.class.name.underscore }

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

