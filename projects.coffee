# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# //= require jquery-fileupload/basic
# //= require jquery.validate

$(document).ready ->    
    $(".form-horizontal").validate()    

jQuery ->

    $.datepicker.setDefaults
        dateFormat: 'yy-mm-dd'
        changeMonth: true 
        changeYear: true
        yearRange: '1900:2099'        

    $(".date_pick").datepicker()

    $(document).on("keypress", ".date_pick", ->
        return false
    )

    # $("#project_cu").validate       
    #     submitHandler: (form) ->            
    #         save_button = $(".project_save")[0]        
    #         save_button.disabled = true
    #         save_button.value = "Saving..."        
    #         data = $(form)
    #         form_data = data.serializeArray()            
    #         project_id = form_data[3].value             
    #         sd = new Date(form_data[7].value)
    #         ed = new Date(form_data[8].value) 
    #         if sd > ed
    #             alert "Start Date should be before End Date."                                
    #         else                
    #             $.ajax
    #                 type: "POST"
    #                 url: data.attr("action")       
    #                 data: data.serialize()
    #                 datatype: "json"                          
    #                 success: (op_data)->
    #                     if project_id == "" then alert "New Project Created" else alert "Project Updated"
    #                     $(".project_id").val(op_data.id)
    #                     $(".project_member_save").attr("disabled", false)
    #                     save_button.disabled = false
    #                     save_button.value = "Update and Continue"
    #                     $("#myModalLabel").text("Edit Project")
    #                     $(".final_step a").click()                
    #                 error: (op_data)->
    #                     alert "Error Occured!!! Please try again!!!"
    #                     save_button.disabled = false
    #                     save_button.value = "Save and Continue"
    #         false

    # project_edit_validation = $(".project_edit").validate        
    #     submitHandler: ->             
    #         save_button = $(".project_edit_save")[0]        
    #         save_button.disabled = true
    #         save_button.value = "Saving..."        
    #         data = $(form)
    #         form_data = data.serializeArray()     #                               
    #         sd = new Date(form_data[6].value)
    #         ed = new Date(form_data[7].value) 
    #         if sd > ed
    #             alert "Start Date should be before End Date."                                
    #         else                
    #             $.ajax
    #                 type: "POST"
    #                 url: data.attr("action")       
    #                 data: data.serialize()
    #                 datatype: "json"                          
    #                 success: (op_data)->
    #                     alert "Project Updated"                
    #                     save_button.disabled = false
    #                     save_button.value = "Save"                        
    #                 error: (op_datadd: (e, data) ->a)->
    #                     alert "Erradd: (e, data) ->or Occured!!! Please try again!!!"
    #                     save_button.disabled = false
    #                     save_button.value = "Save"
    #         false

    $(document).on("submit", ".project_new_form", (e)->
        save_button = $(".project_save")[0]        
        save_button.disabled = true
        save_button.value = "Saving..."        
        data = $(this)
        form_data = data.serializeArray()                    
        project_id = form_data[2].value                
        sd = new Date($("#project_start_date").val())
        ed = new Date($("#project_end_date").val())       
        if sd > ed
            alert "Start Date should be before End Date."  
            save_button.disabled = false
            save_button.value = "Save and Continue"                              
        else                
            $.ajax
                type: "POST"
                url: data.attr("action")       
                data: data.serialize()
                datatype: "json"                          
                success: (op_data)->                                        
                    op_data = op_data.project                    
                    if project_id == "" then alert "New Project Created" else alert "Project Updated"
                    $(".project_id").val(op_data.id)
                    $(".project_member_save").attr("disabled", false)
                    $("#project_members_member_id option[value=" + op_data.manager.id + "]").hide()
                    save_button.disabled = false
                    save_button.value = "Update and Continue"
                    $("#myModalLabel").text("Edit Project")
                    $(".final_step a").click()                                    
                error: (op_data)->
                    alert "Error Occured!!! Please try again!!!"
                    save_button.disabled = false
                    save_button.value = "Save and Continue"
        e.preventDefault()
        false
    )                             

    $(document).on("submit", ".project_edit", (e)->                         
        save_button = $(".project_save")[0]                
        save_button.disabled = true
        save_button.value = "Saving..."        
        data = $(this)
        form_data = data.serializeArray()                       
        sd = new Date($("#project_start_date").val())
        ed = new Date($("#project_end_date").val()) 
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
                    alert "Project Updated"                
                    save_button.disabled = false
                    save_button.value = "Save" 
                    # $(".close").click();   
                    $(".final_step a").click()                    
                error: (op_data)->
                    alert "Error Occured!!! Please try again!!!"
                    save_button.disabled = false
                    save_button.value = "Save"
        e.preventDefault()
        false
    )

    $(document).on("submit", "#project_member", (e)->        
        save_button = $(".project_member_save")[0]
        save_button.disabled = true
        save_button.value = "ADDING..."        
        data = $(this)
        form_data = data.serializeArray()
        project_id = form_data[2].value
        member_id = form_data[3].value 
        if project_id == ""
            alert "Please create PROJECT." 
            save_button.disabled = false
            save_button.value = "ADD"            
        else if member_id != ""       
            $.ajax
                type: "POST"
                url: data.attr("action")       
                data: data.serialize()
                datatype: "json"                          
                success: (op_data)->
                    alert "Member Added Successfully"
                    $("#project_members_member_id :selected").remove()
                    $("#project_members_member_id").val("")
                    save_button.disabled = false
                    save_button.value = "ADD"                                   
                error: (op_data)->                                                     
                    alert "Error Occured!!! Please try again!!!"
                    save_button.disabled = false
                    save_button.value = "ADD"
        else
            alert "No Follower Selected"
            save_button.disabled = false
            save_button.value = "ADD"  
        e.preventDefault()
        false
    )
    
    $(document).on("click", ".delete_member", (e)->
        data = $(this)          
        $(this).bind("click", false)
        $.ajax
            type: "DELETE"
            url: this.href                  
            datatype: "json"                          
            success: (op_data)->
                if op_data.hasOwnProperty("message")
                    alert op_data.message
                    $(".close").click();
                else
                    alert "Member Deleted Successfully" 
                    if $("#project_members_member_id option[value=" + op_data.member_id + "]").length > 0                   
                        $("#project_members_member_id option[value=" + op_data.member_id + "]").show()
                    else                                    
                        value = op_data.member_id           
                        key = data.data().followerName
                        option = new Option(key, value)
                        $("#project_members_member_id").append($(option))                                   
                    $("#project_members_member_id").val("")                
                    count = $(".role-board-count").text()
                    $(".role-board-count").text(count - 1)                
                    if data.data().parent
                        project_id = data.data().projectId
                        follower_id = data.data().followerId
                        $("#project_" + project_id + "_follower_" + follower_id).remove()
                        $(".close").click();
                    else
                        data.parent().parent().remove()                                                
            error: (op_data)->
                $(this).unbind("click", false)
                alert "Error Occured!!! Please try again!!!"                  
        e.preventDefault()
        false
    )

    $(document).on("click", ".project_form_discard", ->
        $("#myModalLabel").text("Add New Project")
        $("#project_members_member_id option").show()
        $(".project_save").val("SAVE AND CONTINUE")
        $(".project_id").val("")
        $(".hr_forms").find("input[type=text]").val("")
        $("#member_listings").children().remove()
    )

    $(document).on("click", ".project_manager_change", ->
        id = this.dataset.id
        if $(".project_" + id + "_manager").hasClass("hide")
            $(".project_" + id + "_manager").toggleClass("hide")
    )

    $(document).on("submit", "#project_search", (e)->        
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


    # $(".project_tabs").click ->
    #     url = this.href
    #     id = this.dataset.target
    #     $(this).toggleClass("project_tabs")
    #     $.ajax(url: url).done (html) ->                
    #         $(id).append html        
    #         $(".date_pick").datepicker()

    $(document).on('click', 'a.fetch-modal', (e) -> 
        $('div#modals').html(null)        
        $.ajax
            url: $(this).attr('href')
            async: false
            success: (data) ->
                enforceModalFocusFn = $.fn.modal.Constructor.prototype.enforceFocus                
                $.fn.modal.Constructor.prototype.enforceFocus = ->
                $('div.ajax_modal').on('hidden', ->
                    $.fn.modal.Constructor.prototype.enforceFocus = enforceModalFocusFn   
                )             
                $('div#modals').html(data) if data.search("</") >= 0               
                $(".date_pick").datepicker()
                if $(".start_date").length > 0
                    start_date = new Date($(".start_date").val())
                    $(".date_pick").datepicker("option", "minDate", start_date)
                if $(".end_date").length > 0
                    end_date = new Date($(".end_date").val())
                    $(".date_pick").datepicker("option", "maxDate", end_date)                
                $(".form-horizontal").validate()                
                $('div.ajax_modal').modal(
                    backdrop : false 
                )                             
            error: (e) ->
                alert "Error Occured!!! Please try again!!!"                              
        false
    )

    $(document).on("submit", "#new_follower", (e)->              
        save_button = $(".project_member_save")[0]
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
                    $(".close").click()
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

    $(document).on("click", ".delete_follower", (e)->
        data = $(this)                     
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
                    project_id = data.data().projectId
                    follower_id = data.data().followerId
                    $("#project_" + project_id + "_follower_" + follower_id).remove()
                    $(".close").click() unless data.data().followerName == undefined              
                    data.parent().parent().remove()                                
            error: (op_data)->                
                alert "Error Occured!!! Please try again!!!"                  
        e.preventDefault()
        false
    )

    $("#attachment_upload").fileupload()

    $(document).on('click', '.filebox-simple', ->        
        id = $(this).data().attachmentid
        $('.attachment-detail-' + id).show()
        $('.attachment_wrapper').hide()                                        
    )    
    
    $(document).on('click', '.back-to-list', ->
        $('.files_wrapper').hide()        
        $('.attachment_wrapper').show()
    )
    
    $(document).on('click', '.filebox-google', ->        
        id = $(this).data().attachmentid
        $('.google-attachment-detail-' + id).show()
        $('.attachment_wrapper').hide()                                        
    )

    $(document).on("click", ".attachment_link", ->
        $(this).children().last()[0].click()
    )