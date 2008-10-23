// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
Ajax.Responders.register({
 onCreate: function() {
   if (Ajax.activeRequestCount > 0)
     Element.show('form-indicator');
 },
 onComplete: function() {
   if (Ajax.activeRequestCount == 0)
     Element.hide('form-indicator');
 }
 });

function set_class_name(element, class_name) {
	new Element.ClassNames(element).set(class_name);
}
sfHover = function() {
	var sfEls = document.getElementById("nav").getElementsByTagName("LI");
	for (var i=0; i<sfEls.length; i++) {
		sfEls[i].onmouseover=function() {
			this.className+=" sfhover";
		}
		sfEls[i].onmouseout=function() {
			this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
		}
	}
}
if (window.attachEvent) window.attachEvent("onload", sfHover);

