require File.join(File.dirname(__FILE__), 'lib', 'modalbox_helper')
ActionView::Helpers::AssetTagHelper::register_javascript_include_default('modalbox')
ActionView::Helpers::AssetTagHelper::register_stylesheet_expansion :modalbox_css => ["modalbox"]