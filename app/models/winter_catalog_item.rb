# encoding: utf-8
class WinterCatalogItem < CatalogItem

  self.season_icon = WinterImage
  self.season_name = I18n.t( :fall_winter )
  set_inheritance_column "type"       

end
