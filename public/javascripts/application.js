// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

Ajax.Responders.register({
<<<<<<< Updated upstream:public/javascripts/application.js
 onCreate: function() {
   if (Ajax.activeRequestCount > 0)
     Element.show('overlay');
 },
 onComplete: function() {
   if (Ajax.activeRequestCount == 0)
     Element.hide('overlay');
 }
 });
=======
    onComplete: function(responder, request){
        var response = (request.responseText.evalJSON(true));
        if (response.object)  {
            // Remove old erroes
            $(response.object + "_form").select(".error").invoke("removeClassName", "error");
            $(response.object + "_form").select(".error_message").invoke("remove");

            // Success: clear all input with text
            if (response.success) {
                var form = $(response.object + "_form");
                form.select(".text").each(function(element) {
                    element.value = ""
                    });
            }
            // Else add error by creating a div with error message
            else {
                response.errors.each(function(error) {
                    var element = $(response.object + "_" + error[0]);
                    if (element) {
                        element.addClassName("error");
                        element.insert({
                            after: new Element("div", {
                                className: "error_message"
                            }).update(error[1])
                            });
                    }
                })
            }
        }
    }
});
>>>>>>> Stashed changes:public/javascripts/application.js


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
