# Author:: Carlo Bertini (WaYdotNET)
# WebSite:: http://blogs.ugidotnet.org/carlitoway
# Based on LightBoxHelper
# Many thx to Davide D'Agostino (DAddYE)
require 'action_view'

module ActionView
  module Helpers
    module LightWindowHelper
      def self.included(base)
        base.class_eval do
          include InstanceMethods
        end
      end
      module InstanceMethods    
        def lightwindow_link_to(name, options = {}, html_options = {}, *parameters_for_method_reference)
          html_options.merge!(:class => "lightwindow") unless html_options[:class]
          # url_for(options) it's hack to resolve this problem
          # http://railsforum.com/viewtopic.php?pid=46594 (thx to DAddYE)
          link_to(name, url_for(options) + "/", html_options, *parameters_for_method_reference)
        end
      end
    end
  end
end

ActionView::Base.class_eval do
  include ActionView::Helpers::LightWindowHelper
end

ActionView::Helpers::AssetTagHelper.register_javascript_include_default 'lightwindow'