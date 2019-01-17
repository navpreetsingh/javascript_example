# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# //= require jquery.validate

$(document).ready ->   
	$("#error, #errors, #forgot-password-notification, .forgot-page, #forgot-password-notification, #forgot-error, #password-error, #password-success, #password-error-length").hide()	

jQuery ->
    $(".new_session, .forgot-session").validate()

    $(document).on("submit", ".new_session", (e)->
        save_button = $(".session_save")[0]
        save_button.disabled = true
        save_button.value = "Please Wait..."        
        data = $(this)
        form_data = data.serializeArray()           
        $.ajax(
            type: "POST"
            url: data.attr("action")       
            data: data.serialize()
            datatype: "json"                          
        ).done (html)->                     
            save_button.disabled = false
            save_button.value = "SUBMIT"
        e.preventDefault()
        false
    )

    $(document).on("click", ".forgot_pwd", ->
        $(".login-page").hide()
        $(".forgot-page").show()
    )
    
    $(document).on("click", ".back_button", ->
        $(".login-page").show()
        $(".forgot-page").hide()
    )

    $(document).on("submit", ".forgot-session", (e)->
        save_button = $(".session_save")[0]
        save_button.disabled = true
        save_button.value = "SUBMITTING"        
        data = $(this)
        form_data = data.serializeArray()           
        $.ajax(
            type: "POST"
            url: data.attr("action")       
            data: data.serialize()
            datatype: "json"                          
        ).done (html)->                     
            save_button.disabled = false
            save_button.value = "SUBMIT"            
        e.preventDefault()
        false
    )
    
    $(document).on("submit", ".reset_password", (e)->                
        $("#password-error").hide()
        $("#password-error-length").hide()
        $("#error").hide()
        data = $(this)        
        form_data = data.serializeArray()                   
        if form_data[2].value == form_data[3].value
            if form_data[2].value.length < 8
                $("#password-error-length").show()
            else
                save_button = $(".session_save")[0]
                save_button.disabled = true
                save_button.value = "SUBMITTING"            
                $.ajax(
                    type: "POST"
                    url: data.attr("action")       
                    data: data.serialize()
                    datatype: "json"                          
                ).done (html)->                     
                    save_button.disabled = false
                    save_button.value = "SUBMIT"
        else
            $("#password-error").show()
        e.preventDefault()
        false
    )