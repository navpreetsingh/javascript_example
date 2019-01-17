
jQuery(document).ready(function($){

    /*Over time Validation*/
    $(document).on("click",".mile_discussion", function(e){
        var form = $(this);
        form.validate({
            rules: {
                'discussion[topic]': {
                    required: true
                }

            },
            // Specify the validation error messages
            messages: {
                'discussion[topic]': {
                    required: 'Please enter topic'
                }
                
            },
            errorPlacement: function(error, element) {
                if(element.attr("name") == "discussion[topic]") {
                    error.insertAfter( element.closest(".search_result"));
                } else {
                    error.insertAfter(element);
                }
            }
         })      
    })/*End*/




 }); 