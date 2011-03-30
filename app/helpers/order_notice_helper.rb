module OrderNoticeHelper
  
  def order_notice( order_item )
    order_item.instance_exec( self ) {
      |p| "#{name} #{size.name rescue ''} #{colour.name rescue ''} (#{ p.number_to_currency( price )}) - #{amount} #{I18n.t(:amount)}".html_safe }
  end
  
  
end
