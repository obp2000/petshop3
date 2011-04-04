class CatalogItemsController < ApplicationController

  def search
    @objects = current_model.search_results( params )
    if @objects.empty?
      flash.now[ :notice ] = current_model.not_found_notice( params )
      render_notice.bind( self )[]
    else
      render_index.bind( self )[]      
    end
  end

end
