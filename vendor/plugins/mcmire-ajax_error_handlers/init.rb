require File.dirname(__FILE__) + '/install'
require File.dirname(__FILE__) + '/lib/controller'

ActionController::Base.send(:include, McMire::AjaxErrorHandlers::Controller)
