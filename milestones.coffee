# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->    
    if /^\/milestones\/\d+$/.test(window.location.pathname)
        path = window.location.pathname
        milestone_id = path.replace("/milestones/", "")
        $.ajax(url: "/milestones/" + milestone_id + "/followers").done (html) ->     
            $("#follow").append html
            $("#new_milestone_follower").validate()  

    $(".form-horizontal").validate()    

jQuery ->
    $.datepicker.setDefaults
        dateFormat: 'yy-mm-dd'
        changeMonth: true 
        changeYear: true
        yearRange: '1900:2099'        

    $(".date_pick").datepicker()

    $(document).on("submit", "#milestone_create", (e)->                      
        save_button = $(".milestone_save")[0]        
        save_button.disabled = true
        save_button.value = "Saving..."        
        data = $(this)
        form_data = data.serializeArray()                                 
        sd = new Date($("#milestone_start_date").val())
        ed = new Date($("#milestone_end_date").val())            
        if sd > ed
            alert "Start Date should be before End Date."
            save_button.disabled = false
            save_button.value = "Save"                                
        else                
            $.ajax
                type: "POST"
                url: data.attr("action")       
                data: data.serialize()
                datatype: "json"                          
                success: (op_data)->
                    $("#milestone_form").find("input[type=text]").val("")
                    $(".close").click()                       
                    save_button.disabled = false
                    save_button.value = "Save" 
                    alert "Milestone Saved Successfully!!!"                       
                error: (op_data)->
                    alert "Error Occured!!! Please try again!!!"
                    save_button.disabled = false
                    save_button.value = "Save"
        e.preventDefault()
        false
    )

    $(document).on("submit", ".milestone_edit", (e)->                                   
        save_button = $(".milestone_save")[0]        
        save_button.disabled = true
        save_button.value = "Saving..."        
        data = $(this)
        form_data = data.serializeArray()                                 
        sd = new Date($("#milestone_start_date").val())
        ed = new Date($("#milestone_end_date").val())          
        if sd > ed
            alert "Start Date should be before End Date."
            save_button.disabled = false
            save_button.value = "Save"                                
        else                
            $.ajax
                type: "PUT"
                url: data.attr("action")       
                data: data.serialize()
                datatype: "json"                          
                success: (op_data)->
                    $("#milestone_form").find("input[type=text]").val("")
                    $(".close").click()                       
                    save_button.disabled = false
                    save_button.value = "Save"  
                    alert "Milestone Updated Successfully!!!"                                             
                error: (op_data)->
                    alert "Error Occured!!! Please try again!!!"
                    save_button.disabled = false
                    save_button.value = "Save"
        e.preventDefault()
        false
    )

    $(document).on("click", ".milestone_cancel", ->
        $(".hr_forms").find("input[type=text]").val("")
    )

    $(document).on("click", ".milestone_manager_change", ->        
        id = this.dataset.id
        if $(".milestone_" + id + "_manager").hasClass("hide")
            $(".milestone_" + id + "_manager").toggleClass("hide")
    )

    $(document).on("submit", "#milestone_search", (e)->                
        $('#search_save').attr("disabled", true)
        data = $(this)
        $.ajax
            type: "GET"
            url: data.attr("action")       
            data: data.serialize()                 
            datatype: "json"                          
            success: (op_data)->
                $('#search_save').attr("disabled", false)  
                $('#search_search').val('')          
            error: (op_data)->
                $('#search_save').attr("disabled", false)
                alert "Error Occured!!! Please try again!!!"                  
        e.preventDefault()
        false
    )

    $(document).on("submit", "#new_milestone_follower", (e)->                      
        save_button = $(".milestone_member_save")[0]
        save_button.disabled = true
        save_button.value = "ADDING..."        
        data = $(this)        
        $.ajax
            type: "POST"
            url: data.attr("action")       
            data: data.serialize()
            datatype: "json"                          
            success: (op_data)->
                if op_data.hasOwnProperty("message")
                    alert op_data.message
                    save_button.disabled = false
                    save_button.value = "ADD"
                else
                    alert "Member Added Successfully"
                    $("#new_follower_member_id :selected").remove()
                    $("#new_follower_member_id").val("")
                    save_button.disabled = false
                    save_button.value = "ADD"                                   
            error: (op_data)->                                                     
                alert "Error Occured!!! Please try again!!!"
                save_button.disabled = false
                save_button.value = "ADD"  
        e.preventDefault()
        false
    )

    $(document).on("click", ".delete_milestone_follower", (e)->
        data = $(this)        
        $(this).bind("click", false)        
        $.ajax
            type: "POST"
            url: this.href                  
            datatype: "json"                          
            success: (op_data)->
                if op_data.hasOwnProperty("message")
                    alert op_data.message
                    $(".close").click()
                else
                    alert "Member Deleted Successfully"                
                    if $("#new_follower_member_id option[value=" + op_data.member_id + "]").length > 0                   
                        $("#new_follower_member_id option[value=" + op_data.member_id + "]").show()
                    else                    
                        value = op_data.member_id           
                        key = data.data().followerName
                        option = new Option(key, value)
                        $("#new_follower_member_id").append($(option))                
                    $("#new_follower_member_id").val("")                                
                    milestone_id = data.data().milestoneId
                    follower_id = data.data().followerId
                    $("#milestone_" + milestone_id + "_follower_" + follower_id).remove() 
                    $(".close").click()                                            
            error: (op_data)->
                $(this).unbind("click", false)
                alert "Error Occured!!! Please try again!!!"                  
        e.preventDefault()
        false
    )
    
    $(document).on("submit", "#add_task", (e)->          
        save_button = $(".add_task_save")[0]
        save_button.disabled = true
        save_button.value = "ADDING..."        
        data = $(this)        
        $.ajax
            type: "POST"
            url: data.attr("action")       
            data: data.serialize()
            datatype: "json"                          
            success: (op_data)->
                alert "Task Added Successfully"
                $("#add_task_task_id :selected").remove()
                $("#add_task_task_id").val("")
                save_button.disabled = false
                save_button.value = "ADD"                                   
            error: (op_data)->                                                     
                alert "Error Occured!!! Please try again!!!"
                save_button.disabled = false
                save_button.value = "ADD"  
        e.preventDefault()
        false
    )