# encoding: utf-8
class WinterCatalogItem < CatalogItem

  self.season_icon = WinterImage
  self.season_name = self.human_attribute_name( :season_name )  
  set_inheritance_column "type"       

end
