// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

Ajax.Responders.register({
 onCreate: function() {
   if (Ajax.activeRequestCount > 0)
     Element.show('overlay');
 },
 onComplete: function() {
   if (Ajax.activeRequestCount == 0)
     Element.hide('overlay');
 }
 });

function set_class_name(element, class_name) {
	new Element.ClassNames(element).set(class_name);
}
/*jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")} 
})*/