# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
	$(document).on("submit", "#add_to_do_list", (e)->              
	        save_button = $(".add_to_do_list_save")[0]
	        save_button.disabled = true
	        save_button.value = "ADDING..."        
	        data = $(this)        
	        $.ajax
	            type: "POST"
	            url: data.attr("action")       
	            data: data.serialize()
	            datatype: "json"                          
	            success: (op_data)->
	                alert "To Do List Added Successfully"	                
	                $("#to_do_list_name").val("")
	                save_button.disabled = false
	                save_button.value = "ADD"                                   
	            error: (op_data)->                                                     
	                alert "Error Occured!!! Please try again!!!"
	                save_button.disabled = false
	                save_button.value = "ADD"  
	        e.preventDefault()
	        false
	    )

	$(document).on("click", ".delete_to_do_list", (e)->
        data = $(this)        
        $(this).bind("click", false)        
        $.ajax
            type: "DELETE"
            url: this.href                  
            datatype: "json"                          
            success: (op_data)->
                alert "To Do List Deleted Successfully"
                to_do_list_id = data.data().toDoListId                                
                $("#to_do_list_" + to_do_list_id).remove() 
                $(".close").click()                                            
            error: (op_data)->
                $(".delete_to_do_list").unbind("click", false)
                alert "Error Occured!!! Please try again!!!"                  
        e.preventDefault()
        false
    )
	
	$(document).on("change", ".to_do_list_completed", (e) ->
	  	data = $(this).data()
	  	to_do_list_id = data.toDoListId
	  	href = data.href	  	
	  	$.ajax
            type: "PUT"
            url: href                  
            datatype: "json"                          
            success: (op_data)->
            	alert "To Do List Updated"
            error: (op_data)->
            	alert "Error Occured!!! Please try again!!!"
        e.preventDefault()
        false
    )