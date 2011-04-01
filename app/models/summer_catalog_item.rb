# encoding: utf-8
class SummerCatalogItem < CatalogItem

  self.season_icon = SummerImage
  self.season_name = human_attribute_name( :season_name1 )  
  set_inheritance_column "type"

end
