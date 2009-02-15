module Admin::ShippingRatesHelper
    def editable_content(options)
   options[:content] = { :element => 'span' }.merge(options[:content])
   options[:url] = {}.merge(options[:url])
   options[:ajax] = { :okText => "'Save'", :cancelText => "'Cancel'"}.merge(options[:ajax] || {})
   script = Array.new
   script << "new Ajax.InPlaceEditor("
   script << "  '#{options[:content][:options][:id]}',"
   script << "  '#{url_for(options[:url])}',"
   script << "  {"
   script << options[:ajax].map{ |key, value| "#{key.to_s}: #{value}" }.join(", ")
   script << "  }"
   script << ")"

    #submit_function << "var s = document.createElement('input'); s.setAttribute('type', 'hidden'); "
    #submit_function << "s.setAttribute('name', '#{request_forgery_protection_token}'); s.setAttribute('value', '#{escape_javascript form_authenticity_token}'); f.appendChild(s);"

   content_tag(options[:content][:element],
     options[:content][:text],
     options[:content][:options]) + javascript_tag( script.join )
 end

end
