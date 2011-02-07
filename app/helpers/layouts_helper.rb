# coding: utf-8
module LayoutsHelper
  
  def application_javascripts
    [ "jquery-1.4.4", "yoxview/yoxview-init", "jquery-ui.min", "imgpreview.min.0.22.jquery", "rounded",
      "textile_toolbar", "application", "js/jquery.guid", "js/jquery.dotimeout", "js/jquery.shadowon.min",
      "jquery.bltcheckbox", "rails", 'jquery.form', 'jquery.remotipart' ]
  end
  
  def application_stylesheets
    [ "jquery-ui-1.8.custom", "nullify", "common" ]
  end
  
  def items_javascripts
    [ "jquery-1.4.4", "yoxview/yoxview-init", "jquery-ui.min", "imgpreview.min.0.22.jquery", "rounded",
      "application", "textile-editor", "mColorPicker", "jquery.form", "jquery.remotipart",
      "js/jquery.guid", "js/jquery.dotimeout", "js/jquery.shadowon.min", "mfsNiceControls", "jrails", "rails",
      'jquery.form', 'jquery.remotipart' ]
  end
  
  def items_stylesheets
    [ "nullify", "jquery-ui-1.8.custom", "common", "textile-editor" ]
  end
  
  
end
