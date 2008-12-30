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
function set_navigation(navid) {
    var nav_array = $('nav').childElements();
    nav_array.each(function(item, index) {
        if (index+1 == navid) {
            item.removeClassName('menu').addClassName('active');
            $(nav_array[index-1]).removeClassName('active').addClassName('visited');
            //$(nav_array[index-1]).addClassName('visited');
        }
    });
}
function submitForm(elem) {
    while (elem.parentNode && elem.parentNode.tagName != "FORM") {
        elem = elem.parentNode;
    }
    console.log(elem);
    var oForm = elem.parentNode;
    oForm.submit();
    return false;
}
