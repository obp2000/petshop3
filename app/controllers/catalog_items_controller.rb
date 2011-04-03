class CatalogItemsController < ApplicationController

  def search
    @objects = controller_name.classify.constantize.search_results( params )
    if @objects.empty?
      flash.now[ :notice ] = CatalogItem.not_found_notice( params )
      render_notice.bind( self )[]
    else
      render_index.bind( self )[]      
    end
  end

end
