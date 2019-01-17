# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

    loader_position = ->       
        window_height = $(window).height()
        list_height = $(".file_list").height()
        list_offset = $(".file_list").offset().top
        scroll_top = $(window).scrollTop()        
        position = "0%" if (scroll_top + window_height) < list_offset
        if (scroll_top + window_height) > list_offset and scroll_top < (list_offset + list_height)
            position = ((window_height + scroll_top) / (2 * list_height)) * 100
            position = if position > 75 then "100%" else position + "%"
        position = "100%" if scroll_top  >  (list_offset + list_height)                
        $(".archive_loader .centric2").css("margin-top", position)


    $("#archive_upload").fileupload
        add: (e, data) ->
            $(".archive_loader").toggleClass("hide")            
            parent_id = $(this).serializeArray()[2].value
            if parent_id == ""
                $(".archive_loader").toggleClass("hide")
                alert "Cannot add file to this folder"
            else
                data.submit()
            e.preventDefault()                                            
        false 

    $(document).on("submit", "#archive_search, #archive_mime_type", (e)->
        $(".archive_loader").toggleClass("hide")
        data = $(this)
        $.ajax(
            type:"POST"
            url:  data.attr("action") 
            data: data.serialize()          
            datatype: "json"
            success: (op_data)->
                $("#archive_search").find("input[type=text]").val("")                 
                $(".archive_loader").toggleClass("hide")
            error: (op_data)->
                $(".archive_loader").toggleClass("hide")                 
                alert "Error Occured!!! Please try again!!!"                
            )
        e.preventDefault()                                            
        false
    )
    
    $(document).on("click", ".main_folder, .archive_children, .back_button, .archive_delete_file", (e) ->         
        $(".archive_loader").toggleClass("hide")
        loader_position        
        $.ajax(
            type:"POST"
            url:  this.href
            datatype: "json"
            success: (op_data)->                
                $(".archive_loader").toggleClass("hide")
            error: (op_data)->                 
                $(".archive_loader").toggleClass("hide")
                alert "Error Occured!!! Please try again!!!"                
            )
        e.preventDefault()                                               
        false
    )

    $(window).scroll ->        
        loader_position() unless $(".archive_loader").hasClass("hide")         