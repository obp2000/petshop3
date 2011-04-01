# encoding: utf-8
class SummerCatalogItem < CatalogItem

  self.season_icon = SummerImage
  self.season_name = self.human_attribute_name( :season_name )  
  set_inheritance_column "type"

end
