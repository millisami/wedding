#Modalbox
module ActionView::Helpers::UrlHelper
  def modalbox_link_to(name, options = {}, html_options = {}, *parameters_for_method_reference)
        
    defaults = {:title => "Modalbox",
	    :width => 600,
	    #:params => {},
	    :loadingString => "Please wait. Loading...",
	    :closeString => "Close window", 
	    :closeValue => "&times", #can pu the loader image path
	    
        }
        #options = defaults.merge(options)
      
        return link_to(name,options[:url]) if options[:url].class == String && options[:url].include?('http://')
	
        html_options[:href] = url_for(options[:url]) unless html_options
        html_options[:href] = url_for(options[:url]) unless (html_options && html_options[:href] )

        html_options[:onclick] = "Modalbox.show(this.href, {title: this.title, "
        html_options[:onclick] += "width: "  + (options[:width] ||= defaults[:width])
        html_options[:onclick] += ", loadingString: '" + (options[:loadingString] ||= defaults[:loadingString]) + "'"
        html_options[:onclick] += ", closeString: '" + (options[:closeString] ||= defaults[:closeString]) + "'"
	      html_options[:onclick] += ", closeValue: '" + (options[:closeValue] ||= defaults[:closeValue]) + "'"

	      html_options[:onclick] += ", overlayClose: "  + (options[:overlayClose]).to_s if options[:overlayClose]
        html_options[:onclick] += ", height: #{options[:height]}" if options[:height]
        html_options[:onclick] += ", overlayOpacity: #{options[:overlayOpacity]}" if options[:overlayOpacity]
        html_options[:onclick] += ", overlayDuration: #{options[:overlayDuration]}" if options[:overlayDuration]
        html_options[:onclick] += ", slideDownDuration: #{options[:slideDownDuration]}" if options[:slideDownDuration]
        html_options[:onclick] += ", slideUpDuration: #{options[:slideUpDuration]}" if options[:slideUpDuration]
        html_options[:onclick] += ", resizeDuration: #{options[:resizeDuration]}" if options[:resizeDuration]
        html_options[:onclick] += ", inactiveFade: #{options[:inactiveFade]}" if options[:inactiveFade]
        html_options[:onclick] += ", transitions: #{options[:transitions]}" if options[:transitions]
        html_options[:onclick] += ", autoFocusing: #{options[:autoFocusing]}" if options[:autoFocusing]

        html_options[:onclick] += ", method: '#{options[:method]}'" if options[:method]
	      html_options[:onclick] += " }); return false;"

        link_to(name, options, html_options, *parameters_for_method_reference)
    end
end