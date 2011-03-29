# encoding: utf-8
class Season
  attr_reader :item
  
  def initialize( item )
    @item = item
  end

#  cattr_accessor :attr_choose_partial
#  self.attr_choose_partial = tableize

  def name
    @item.type.classify.constantize.season_name
  end
    
end
