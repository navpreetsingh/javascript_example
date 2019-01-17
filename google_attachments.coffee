# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
    $(".discussion").validate()

jQuery ->

    files = []
    drag_files = 0

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

    
    $(document).on("click", ".main_folder, .archive_children, .back_button", (e) ->         
        $(".archive_loader").toggleClass("hide")
        loader_position        
        discussion = $(this).data().discussion        
        $.ajax(
            type:"POST"
            url:  this.href
            datatype: "json"
            data: {discussion: discussion}
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
        loader_position() unless $(".archive_loader").length == 0 || $(".archive_loader").hasClass("hide")       

    $(document).on("change", ".google_file", (e) ->
        data = $(this)        
        if data.is(":checked")
            files.push(data.data().file) 
        else
            index = files.indexOf(data)
            files.splice(index, 1)        
    )    

    $(document).on("click", ".google_attachment", (e) ->                 
        $.ajax
            type:"POST"
            url: this.href
            data: {files: files}
            datatype: "json"
            success: (op_data)->
                alert "Files added Successfully"
                $(".close").click()
                files = []
                $(this).unbind("click", false)
            error: (op_data) ->
                alert "Error Occured!!! Please try again!!!"
                $(this).unbind("click", false)
        e.preventDefault()
        false
    )

    $(document).on("submit", ".discussion", (e)->                       
        data = $(this)
        save_button = $(".save_button")[0]        
        save_button.disabled = true
        attachments = {}        
        attachments[i] = file for file, i in files        
        data[0].children[3].value = JSON.stringify(attachments)                                
        formData = new FormData(data[0])
        formData.append("avatar", JSON.stringify(drag_files))
        # $(".upload").on("fileuploadsend", {avatar: drag_files})              
        $.ajax
            type: "POST"
            url: data.attr("action")       
            data: formData
            datatype: "json"
            async: false
            cache: false
            enctype: 'multipart/form-data'
            processData: false
            contentType: false            
            success: (op_data)->                
                files = []                
                $(".discussion").find("input[type=text]").val("") 
                $("#filestyle-8").val("")
                save_button.disabled = false               
            error: (op_data)->
                save_button.disabled = false
        e.preventDefault()                                                                 
        false
    )
    
    $(document).on("click", ".discussion_attachment_discard", ->
        $(".upload").val("")
        files = []
    )

    # $(".upload").fileupload
    #     add: (e, data) ->
    #         drag_files = data.files[0]

    # submit_data = $(".upload").on('fileuploadsend', (e, data) ->
    #     drag_files = "" 
    #     e.preventDefault
    # )