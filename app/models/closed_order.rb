# encoding: utf-8
class ClosedOrder < Order

  self.status_nav = human_attribute_name( :status_nav )
  self.status_ = human_attribute_name( :status_ )   

  def closed?; true end
     
end
