# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

	$(document).on("click", ".reply_form_link", (e)->		
        data = $(this)                    
        discussion_id = data.data().discussionId       
        if $(".reply_form_" + discussion_id).html() == ""        	
	        $.ajax
	            type: "POST"
	            url: this.href                  
	            datatype: "json"                          
	            success: (op_data)->		                	                	                
	                $(".reply_form_" + discussion_id).html(op_data)	                
	            error: (op_data)->	                
	                alert "Error Occured!!! Please try again!!!"                  
        e.preventDefault()
        false
    )
	
	$(document).on("click", ".edit_discussion", ->
    	id = $(this).data().id
    	$(".show_comment_" + id).toggleClass("hide")
    	$(".update_comment_" + id).toggleClass("hide")
	)
	
	$(document).on("click", ".update_discussion", ->
		data = $(this)
		data.bind("click", false)
		id = data.data().id
		comment = $(".update_comment_input_" + id).val()		
		$.ajax
		    type: "PUT"
		    url: data.data().href
		    data: {comments: comment}                 
		    datatype: "json"                          
		    success: (op_data)->
		    	if op_data.hasOwnProperty("message")
                   alert op_data.message                    
                else
                   $(".show_comment_" + id).text(comment)
                   data.unbind("click", false)
               $(".show_comment_" + id).toggleClass("hide")
               $(".update_comment_" + id).toggleClass("hide")
		    error: (op_data)->
		       	data.unbind("click", false)
		       	alert "Error Occured!!! Please try again!!!"                          
  	false
	)             