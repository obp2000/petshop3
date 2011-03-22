# encoding: utf-8
class SummerCatalogItem < CatalogItem

  self.season_icon = "gadu.png"
  self.season_name = I18n.t( :spring_summer )
  set_inheritance_column "type"

end
