# encoding: utf-8
class Season
  attr_reader :item
  
  def initialize( item )
    @item = item
  end

  def name
    @item.type.classify.constantize.season_name
  end
    
end
