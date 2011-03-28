class CatalogItemsController < ApplicationController

  def search
    @objects = controller_name.classify.constantize.search_results( params )
    flash.now[ :notice ] = CatalogItem.not_found_notice( params ) if @objects.empty?
    render_index.bind( self )[]
  end

end
