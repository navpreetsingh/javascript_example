# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
    if window.location.pathname == "/employees/new"
        $(".secondary_form :input").attr("disabled", true)
        $(".secondary_form_p :input").attr("disabled", true) 
    $("a[href=" + window.location.hash + "]").click()                   

jQuery ->
    
    content_addition = 3

    $.datepicker.setDefaults
        dateFormat: 'yy-mm-dd'
        changeMonth: true 
        changeYear: true
        yearRange: '1900:2099'
        maxDate: 0	

    $(".add_child_panel").click ->
        $(".child_form").show()

    $(".add_speak_language_panel").click ->
        $(".language_form").show()

    $(".add_education_panel").click ->
        $(".education_form").show()

    $(".add_files_panel").click ->
        $(".files_form").show()

    $(".add_notes_panel").click ->
        $(".notes_form").show()

    $(".add_professional_membership_panel").click ->
        $(".professional_membership_form").show()

    $(".add_previous_employment_panel").click ->
        $(".previous_employment_form").show()

    $(".add_files_panel").click ->
        $(".files_form").show()

    $(".add_notes_panel").click ->
        $(".notes_form").show()

    $(".add_files_panel").click ->
        $(".files_form").show()

    $(".add_offboarding_workflow_panel").click ->
        $(".offboarding_workflow_form").show()

    $(".add_offboarding_question_panel").click ->
        $(".offboarding_question_form").show()

    $("#emp_personal_dob, #emp_family_dob").datepicker
        maxDate: -18*365 - 4

    $(".form-control").on("change", (e)->
        form_name = this.name.split("[")[0]
        form_name = "address" if form_name.includes("correspondence") or form_name.includes("permanent")
        if form_name.includes("compensation")
            if this.hasClass("basic_compensation")
                form_name = "basic_compensation"
            else
                form_name = "compensation_benefits"                
        if $("." + form_name + "_save").hasClass("hidden-item")
            $("." + form_name + "_save").toggleClass("hidden-item")
            $("." + form_name + "_complete").toggleClass("hidden-item")        
    )


    $("#emp_family_dom, #emp_child_dob, #previous_employment_start_date, #previous_employment_leave_date, #professional_membership_qualification_date, #education_graduation_date, #organization_details_join_date").datepicker()    

    # GOOGLE AUTO COMPLETE  
    completer = new GmapsCompleter
        inputField: '#emp_personal_place_of_birth, #emp_family_place_of_birth, #emp_child_place_of_birth, #correspondence_city, #permanent_city, #education_location, #gmaps-input-address'
        errorField: 'Cannot find the place'  
        debugOn: false         

    completer.autoCompleteInit
        country: "*"          

    $('a[href^="#"]').on('click', (e)->
        e.preventDefault()

        target = this.hash                    
        $target = $(target)

        if $target[0] != undefined
            window.location.hash = target
    )

    #SMOOTH SCROLLING
    $('a[href^="#collapse"]').on('click', (e)->
        e.preventDefault()

        target = this.hash                    
        $target = $(target)

        if $target[0] != undefined
            window.location.hash = target
            $("html body").stop().animate(
               'scrollTop': $target.offset().top + 150
            , 500, 'swing'
            )
    )                 

    $("#emp_personal_photo").change ()->
    	file = this.files[0]
    	reader = new FileReader()
    	reader.onload = ->
            $(".avatar img")[0].src = reader.result
            $("#cropbox")[0].src = reader.result
            $("#preview")[0].src = reader.result
            $(".jcrop-holder img")[0].src = reader.result
            $(".jcrop-holder img")[1].src = reader.result
            $(".round_thm img")[0].src = reader.result
    	reader.readAsDataURL file

    $.validator.addMethod("double", (value, element) -> 
        this.optional(element) || /^\d{1,10}.\d{0,2}$/.test( value )
    , "Please add digits only.")

    $.validator.addMethod("strict_email", (value, element) -> 
        this.optional(element) || /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/.test( value )
    , "Incorrect Email Format.");


    $("#emp_personal_form").validate
        submitHandler: (form) ->
            save_button = $(".emp_personal_save")[0]        
            save_button.disabled = true
            save_button.value = "Saving..."        
            data = $(form)               
            formData = new FormData(data[0])        
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
                error: (op_data)->                                 
                    save_button.disabled = false
                    save_button.value = "Save"
                    alert "Error Occured!!! Please try again!!!"  
            false
            

    $(".emp_family_save").click ->
        $("#emp_family_save").click()

    $("#emp_family_form").validate
        submitHandler: (form) ->  
            save_button = $(".emp_family_save")[0]
            save_button.disabled = true
            save_button.value = "Saving..."  
            data = $(form)
            form_data = data.serializeArray()             
            bd = new Date(form_data[7].value)
            md = new Date(form_data[9].value)
            if bd > md
                alert "Birth Date should be before Marriage Date."
                save_button.disabled = false
                save_button.value = "Save"
            else          
                $.ajax(
                    type:"POST"
                    url: data.attr("action")
                    data: data.serialize()
                    datatype: "json"
                    success: (op_data)->
                        $(".emp_family_save").toggleClass("hidden-item")
                        $(".emp_family_complete").toggleClass("hidden-item")
                        if !$("#collapse3").hasClass("in")
                            $("a[href='#collapse3'").click()
                        save_button.disabled = false
                        save_button.value = "Save" 
                    error: ->
                        save_button.disabled = false
                        save_button.value = "Save"
                        alert "Error Occured!!! Please try again!!!"
                    )           
            false
    

    $("#emp_child_form").validate
        rules:
            "family_name":
                required: true
        submitHandler: (form) -> 
            save_button = $(".emp_child_save")[0]
            save_button.disabled = true
            save_button.value = "Saving..."    
            data = $(form)
            form_data = data.serializeArray()        
            $.ajax
                type:"POST"
                url: data.attr("action")
                data: data.serialize()
                datatype: "json"
                success: (op_data)->                
                    save_button.disabled = false
                    save_button.value = "Save"
                    $(".edit-child-row").unbind('click', false)
                    $(".child_form").hide()
                    $(".child_form").find("input[type=text]").val("")
                    gender = $("#emp_child_gender_id 
                        ").text()
                    nationality = $("#emp_child_country_id :selected").text()
                    form_data[content_addition + 3].value = gender    
                    form_data[content_addition + 4].value = nationality    
                    td_data = ""
                    td_data += "<td>" + form_data[value].value + "</td>" for value in [content_addition+1..form_data.length-2]                            
                    $(".child_form").before("
                        <tr>" + 
                            td_data +          
                            "<td class='table-action'>
                                <a class='edit-child-row tooltips' data-toggle='tooltip' data-original-title='Edit' data-details='{&quot;id&quot;:" + op_data.data.id + ",&quot;name&quot;:&quot;" + op_data.data.name + "&quot;,&quot;family_name&quot;:&quot;" + op_data.data.family_name + "&quot;,&quot;gender_id&quot;:" + op_data.data.gender_id + ",&quot;dob&quot;:&quot;" + op_data.data.dob + "&quot;,&quot;country_id&quot;:" + op_data.data.country_id + ",&quot;place_of_birth&quot;:&quot;" + op_data.data.place_of_birth + "&quot;}' title='' href='#' data-original-title=''>
                                  <i class='fa edit-icon'></i>
                                </a>
                                <a class='delete-row tooltips' data-original-title='Delete' data-toggle='tooltip' data-href='/children/" + op_data.data.id + " href='#'> 
                                      <i class='fa close-icon'></i>
                                </a> 
                            </td>
                        </tr>")                    
                error: (op_data)->                
                    save_button.disabled = false
                    save_button.value = "Save"
                    alert "Error Occured!!! Please try again!!!"          
            false    

    $("#address_form").validate(
        submitHandler: (form) ->
            save_button = $(".address_save")[0]
            save_button.disabled = true
            save_button.value = "Saving..."    
            data = $(form)        
            $.ajax(
                type:"POST", 
                url: data.attr("action")       
                data: data.serialize()
                datatype: "json"
                success: (op_data)->
                    $(".address_save").toggleClass("hidden-item")
                    $(".address_complete").toggleClass("hidden-item")
                    if !$("#collapse4").hasClass("in")
                        $("a[href='#collapse4'").click()                           
                error: (op_data)->
                    save_button.disabled = false
                    save_button.value = "Save"
                    alert "Error Occured!!! Please try again!!!"                
                ).done ->                
                    save_button.disabled = false
                    save_button.value = "Save"         
            false
    ) 

    $("#emergency_contact_form").validate(
        submitHandler: (form) ->
            save_button = $(".emergency_contact_save")[0]
            save_button.disabled = true
            save_button.value = "Saving..."    
            data = $(form)        
            $.ajax(
                type:"POST", 
                url: data.attr("action")       
                data: data.serialize()
                datatype: "json"
                success: (op_data)->
                    $(".emergency_contact_save").toggleClass("hidden-item")
                    $(".emergency_contact_complete").toggleClass("hidden-item")
                    if !$("#collapse5").hasClass("in")
                        $("a[href='#collapse5'").click()                           
                error: (op_data)->
                    save_button.disabled = false
                    save_button.value = "Save"
                    alert "Error Occured!!! Please try again!!!"                
                ).done ->                
                    save_button.disabled = false
                    save_button.value = "Save"            
            false
    )

    $("#bank_details_form").validate(
        submitHandler: (form) ->
            save_button = $(".bank_details_save")[0]
            save_button.disabled = true
            save_button.value = "Saving..."    
            data = $(form)        
            $.ajax(
                type:"POST", 
                url: data.attr("action")       
                data: data.serialize()
                datatype: "json"
                success: (op_data)->
                    $(".bank_details_save").toggleClass("hidden-item")
                    $(".bank_details_complete").toggleClass("hidden-item")
                    if !$("#collapse6").hasClass("in")
                        $("a[href='#collapse6'").click()                           
                error: (op_data)->
                    save_button.disabled = false
                    save_button.value = "Save"
                    alert "Error Occured!!! Please try again!!!"                 
                ).done ->                
                    save_button.disabled = false
                    save_button.value = "Save" 
            false
    )

    $("#speak_languages_form").validate(
        submitHandler: (form) ->
            save_button = $(".speak_language_save")[0]
            save_button.disabled = true
            save_button.value = "Saving..."    
            data = $(form)
            form_data = data.serializeArray()        
            $.ajax(
                type:"POST"
                url: data.attr("action")
                data: data.serialize()
                datatype: "json"
                success: (op_data)->
                    save_button.disabled = false
                    save_button.value = "Save"
                    $(".language_form").hide()
                    proficiency_count = form_data.length - 2                             
                    checked = parseInt(form_data[proficiency_count].value)                    
                    language = form_data[content_addition].key
                    td_data = "<td>" + $("#speak_languages_language_id :selected").text()  + "</td> "
                    td_data += "<td> <div class='ckbox ckbox-default'> <input type='checkbox' value=' " +  value + 
                        "' id='checkboxDefault1' disabled " +                              
                        (if value == checked then " checked> " else "> ") + 
                        "<label for='checkboxDefault1'></label></div></td> " for value in [1..4]            
                    $(".language_form").before("
                        <tr>" + 
                            td_data +          
                            "<td class='table-action'> 
                                <a data-original-title='Delete' href='javascript:void(0);' data-toggle='tooltip' data-href='/speak_languages/" + op_data.id + "' title='' class='delete-row tooltips'>
                                  <i class='fa close-icon'></i>
                                </a>                                 
                            </td> 
                        </tr>")
                    $("#speak_languages_language_id :selected").remove()
                    $("#speak_languages_language_id").val("")                
                error: (op_data)->
                    save_button.disabled = false
                    save_button.value = "Save"
                    alert "Error Occured!!! Please try again!!!"                
                ).done ->
            false
    )

    $("#education_form").validate(
        submitHandler: (form) ->
            save_button = $(".education_save")[0]
            save_button.disabled = true
            save_button.value = "Saving..."    
            data = $(form)
            form_data = data.serializeArray()
            $.ajax(
                type:"POST"
                url: data.attr("action")
                data: data.serialize()
                datatype: "json"
                success: (op_data)->
                    $(".edit-education-row").unbind('click', false)
                    save_button.disabled = false
                    save_button.value = "Save"
                    $(".education_form").hide()
                    $(".education_form").find("input[type=text]").val("")    
                    td_data = ""
                    td_data += "<td>" + form_data[value].value + "</td>" for value in [content_addition+1..form_data.length-2] 
                    $(".education_form").before("
                        <tr>" + 
                            td_data +          
                            "<td class='table-action'>
                                <a class='edit-education-row tooltips' data-toggle='tooltip' data-original-title='Edit' data-details='{&quot;id&quot;:" + op_data.data.id + ",&quot;major&quot;:&quot;" + op_data.data.major + "&quot;,&quot;degree&quot;:&quot;" + op_data.data.degree + 
                                    "&quot;,&quot;graduation_date&quot;:&quot;" + op_data.data.graduation_date + "&quot;,&quot;duration&quot;:" + op_data.data.duration + ",&quot;institute_name&quot;:&quot;" + op_data.data.institute_name + "&quot;,&quot;location&quot;:&quot;" + op_data.data.location + 
                                    "&quot;}' title='' href='#' data-original-title=''>
                                  <i class='fa edit-icon'></i>
                                </a>    
                                <a class='delete-row tooltips' data-original-title='Delete' data-toggle='tooltip' data-href='/education/" + op_data.data.id + "'  href='#'>
                                  <i class='fa close-icon'></i>
                                </a>    
                            </td>
                        </tr>")                
                error: ->
                    save_button.disabled = false
                    save_button.value = "Save"
                    alert "Error Occured!!! Please try again!!!"                
                ).done -> 
            false
    )

    $("#professional_membership_form").validate(
        submitHandler: (form) ->
            save_button = $(".professional_membership_save")[0]
            save_button.disabled = true
            save_button.value = "Saving..."    
            data = $(form)
            form_data = data.serializeArray()
            $.ajax(
                type:"POST"
                url: data.attr("action")
                data: data.serialize()
                datatype: "json"
                success: (op_data)->
                    $(".edit-professional_membership-row").unbind('click', false)
                    save_button.disabled = false
                    save_button.value = "Save"
                    $(".professional_membership_form").hide()
                    $(".professional_membership_form").find("input[type=text]").val("")   
                    td_data = ""
                    td_data += "<td>" + form_data[value].value + "</td>" for value in [content_addition+1..form_data.length-2] 
                    $(".professional_membership_form").before("
                        <tr>" + 
                            td_data +          
                            "<td class='table-action'>
                                <a class='edit-professional_membership-row tooltips' data-original-title='Edit' data-toggle='tooltip' data-details='{&quot;id&quot;:" + op_data.data.id + ",&quot;professional_body&quot;:&quot;" + op_data.data.professional_body + "&quot;,&quot;level&quot;:&quot;" + op_data.data.level + "&quot;,&quot;qualification_date&quot;:&quot;" + op_data.data.qualification_date + "&quot;}' title='' href='#' data-original-title=''>
                                  <i class='fa edit-icon'></i>
                            </a>    <a class='delete-row tooltips' data-original-title='Delete' data-toggle='tooltip' data-href='/professional_memberships/" + op_data.data.id + "' href='#''> 
                                  <i class='fa close-icon'></i>
                            </a>  </td> 
                        </tr>")                
                error: ->
                    save_button.disabled = false
                    save_button.value = "Save"
                    alert "Error Occured!!! Please try again!!!"                 
                ).done -> 
            false
    )

    $("#previous_employment_form").validate(
        submitHandler: (form) ->
            save_button = $(".previous_employment_save")[0]
            save_button.disabled = true
            save_button.value = "Saving..."    
            data = $(form)
            form_data = data.serializeArray()            
            sd = new Date(form_data[4].value)
            ld = new Date(form_data[5].value)
            if sd > ld
                alert "Start Date should be before Leaving Date."
                save_button.disabled = false
                save_button.value = "Save"
            else 
                $.ajax(
                    type:"POST"
                    url: data.attr("action")
                    data: data.serialize()
                    datatype: "json"
                    success: (op_data)->
                        $(".edit-previous_employment-row").unbind('click', false)
                        save_button.disabled = false
                        save_button.value = "Save"
                        $(".previous_employment_form").hide()
                        $(".previous_employment_form").find("input[type=text]").val("") 
                        nationality = $("#previous_employment_country_id :selected").text()                
                        form_data[content_addition + 4].value = nationality
                        td_data = ""
                        td_data += "<td>" + form_data[value].value + "</td>" for value in [content_addition+1..form_data.length-2] 
                        $(".previous_employment_form").before("
                            <tr>" + 
                                td_data +          
                                "<td class='table-action'>
                                    <a class='edit-previous_employment-row tooltips' data-original-title='Edit' data-toggle='tooltip' data-details='{&quot;id&quot;:" + op_data.data.id + ",&quot;start_date&quot;:&quot;" + op_data.data.start_date + "&quot;,&quot;leave_date&quot;:&quot;" + op_data.data.leave_date + "&quot;,&quot;company_name&quot;:&quot;" + op_data.data.company_name + "&quot;,&quot;country_id&quot;:" + op_data.data.country_id + ",&quot;job_title&quot;:&quot;" + op_data.data.job_title + "&quot;}' title='' href='#'>
                                      <i class='fa edit-icon'></i>
                                    </a>    
                                    <a class='delete-row tooltips' data-original-title='Delete' data-toggle='tooltip' data-href='/previous_employments/" + op_data.data.id + "' href='#'> 
                                      <i class='fa close-icon'></i>
                                    </a>
                                </td> 
                            </tr>")
                    error: ->
                        save_button.disabled = false
                        save_button.value = "Save"
                        alert "Error Occured!!! Please try again!!!"                 
                    ) 
            false
    )

    $("#organization_details_form").validate(
        submitHandler: (form) ->
            save_button = $(".organization_save")[0]
            save_button.disabled = true
            save_button.value = "Saving..."    
            data = $(form)
            url = data.attr("action")        
            user_id = data.serializeArray()[2].value
            data.attr("action", url + "/" + user_id) unless data.attr("action").includes(user_id)
            $.ajax(
                type:"PUT", 
                url: data.attr("action")       
                data: data.serialize()
                datatype: "json"
                success: (op_data)->
                    $(".organization_save").toggleClass("hidden-item")
                    $(".organization_complete").toggleClass("hidden-item")                           
                error: (op_data)->                  
                    save_button.disabled = false
                    save_button.value = "Save"
                    alert "Error Occured!!! Please try again!!!" 
                ).done ->                
                    save_button.disabled = false
                    save_button.value = "Save"                                
            
            false
    )

    $("#basic_compensation_form").validate(
        submitHandler: (form) ->
            save_button = $(".basic_compensation_save")[0]
            save_button.disabled = true
            save_button.value = "Saving..."    
            data = $(form)        
            $.ajax(
                type:"POST", 
                url: data.attr("action")       
                data: data.serialize()
                datatype: "json"
                success: (op_data)->                
                    $(".basic_compensation_save").toggleClass("hidden-item")
                    $(".basic_compensation_complete").toggleClass("hidden-item")                
                    if !$("#collapse14").hasClass("in")
                        $("a[href='#collapse14'").click()                             
                error: (op_data)->                  
                    save_button.disabled = false
                    save_button.value = "Save"
                    alert "Error Occured!!! Please try again!!!" 
                ).done ->                
                    save_button.disabled = false
                    save_button.value = "Save"
            false
    )

    $("#compensation_benefits_form").validate(
        submitHandler: (form) ->
            save_button = $(".compensation_benefits_save")[0]
            save_button.disabled = true
            save_button.value = "Saving..."    
            data = $(form)        
            url = data.attr("action")        
            user_id = data.serializeArray()[2].value
            data.attr("action", url + "/" + user_id) unless data.attr("action").includes(user_id)     
            $.ajax(
                type:"PUT", 
                url: data.attr("action")       
                data: data.serialize()
                datatype: "json"
                success: (op_data)->                
                    $(".compensation_benefits_save").toggleClass("hidden-item")
                    $(".compensation_benefits_complete").toggleClass("hidden-item")
                    if !$("#collapse15").hasClass("in")
                        $("a[href='#collapse15'").click()                   
                error: (op_data)->                  
                    save_button.disabled = false
                    save_button.value = "Save"
                    alert "Error Occured!!! Please try again!!!" 
                ).done ->                
                    save_button.disabled = false
                    save_button.value = "Save"
            false
    )

    $("#loan_form").validate(
        submitHandler: (form) ->
            save_button = $(".loan_save")[0]
            save_button.disabled = true
            save_button.value = "Saving..."    
            data = $(form)        
            $.ajax(
                type:"POST", 
                url: data.attr("action")       
                data: data.serialize()
                datatype: "json"
                success: (op_data)->                
                    $(".loan_save").toggleClass("hidden-item")
                    $(".loan_complete").toggleClass("hidden-item")                                   
                error: (op_data)->                  
                    save_button.disabled = false
                    save_button.value = "Save"
                    alert "Error Occured!!! Please try again!!!" 
                ).done ->                
                    save_button.disabled = false
                    save_button.value = "Save"  
            false
    )

    $("#efiles_form").validate(
        submitHandler: (form) ->        
            save_button = $(".efiles_save")[0]
            save_button.disabled = true
            save_button.value = "Saving..."        
            data = $(form)        
            formData = new FormData(data[0])
            $.ajax(
                type:"POST", 
                url: data.attr("action")       
                data: formData
                datatype: "json"
                async: false
                cache: false
                enctype: 'multipart/form-data'
                processData: false
                contentType: false            
                success: (op_data)-> 
                    $("#efiles_docs").attr("disabled", false)
                    $("#efiles_docs").attr("required", true)              
                    $(".efiles_save").attr("disabled", false)
                    $(".edit-efile-row").unbind('click', false)                
                    $(".efiles_save").val("Save")
                    form_data = data.serializeArray()
                    form_data[content_addition + 2].value = $("#efiles_file_category_id :selected").text()
                    if $("#efiles_docs").val() == ""
                        filename = $("#efiles_efile_file_name").val()
                    else
                        filename = $("#efiles_docs").val().split('\\').pop()
                    td_data = "<td class='bluetext'>" + filename + "</td>"                
                    td_data += "<td>" + form_data[value].value + "</td>" for value in [content_addition+1..content_addition + 2]
                    td_data += "<td>
                                    <div class='ckbox ckbox-default'>" +
                                        (
                                            if $("#checkboxDefault").prop('checked') 
                                                "<input type='checkbox' id='checkboxDefault1' disabled checked >"
                                            else 
                                                ""
                                        ) +                     
                                        "<label for='checkboxDefault1'> </label>
                                    </div>
                                </td>"
                    $(".files_form").before("
                        <tr>" + 
                            td_data +          
                            "<td class='table-action'>
                                <a class='edit-efile-row tooltips' data-original-title='Edit' data-toggle='tooltip' data-details='{&quot;id&quot;:" + op_data.data.id + ",&quot;file_name&quot;:&quot;" + op_data.data.file_name + "&quot;,&quot;description&quot;:&quot;" + op_data.data.description + "&quot;,&quot;file_category_id&quot;:" + op_data.data.file_category_id + ",&quot;shared_with_manager&quot;:" + op_data.data.shared_with_manager + "}' title='' href='#'>
                                    <i class='fa edit-icon'></i>
                                </a>                              
                                <a class='delete-row tooltips' data-original-title='Delete' data-toggle='tooltip' data-href='/efiles/" + op_data.data.id + "' href='#'> 
                                    <i class='fa close-icon'></i>
                                </a>    
                            </td>
                        </tr>")                
                    $(".files_form").hide()
                    $("#efiles_efile_id").val("")
                    $("#efiles_docs").val("")
                    $("#efiles_efile_file_name").val("")
                    $(".files_form").find("input[type=text]").val("")                                     
                error: (op_data)->                  
                    save_button.disabled = false
                    save_button.value = "Save"
                    alert "Error Occured!!! Please try again!!!" 
                )  
            false
    )

    $("#notes_form").validate(
        submitHandler: (form) ->
            save_button = $(".notes_save")[0]
            save_button.disabled = true
            save_button.value = "Saving..."    
            data = $(form)
            form_data = data.serializeArray()
            $.ajax(
                type:"POST"
                url: data.attr("action")
                data: data.serialize()
                datatype: "json"
                success: (op_data)->
                    save_button.disabled = false
                    save_button.value = "Save"
                    $(".notes_form").hide()
                    $(".notes_form").find("textarea").val("")   
                    td_data = "<td>" + $(".notes_form td").html() + "</td>"
                    td_data += "<td>" + form_data[value].value + "</td>" for value in [content_addition..form_data.length-2] 
                    $(".notes_form").before("
                        <tr>" + 
                            td_data +          
                            "<td class='table-action'> 
                                <div data-original-title='Delete' data-toggle='tooltip' data-href='/notes/"+ op_data.id + "' class='delete-row tooltips'>     
                                  <i class='fa close-icon'></i>
                                </div> 
                            </td> 
                        </tr>")
                error: -> 
                    save_button.disabled = false
                    save_button.value = "Save"
                    alert "Error Occured!!! Please try again!!!"                
                )
            false
    )
        

    $("#offboarding_workflow_form").validate(
        submitHandler: (form) ->
            save_button = $(".offboarding_workflow_save")[0]
            save_button.disabled = true
            save_button.value = "Saving..."    
            data = $(form)
            form_data = data.serializeArray()
            $.ajax(
                type:"POST"
                url: data.attr("action")
                data: data.serialize()
                datatype: "json"
                success: (op_data)->
                    save_button.disabled = false
                    save_button.value = "Save"
                    $(".edit-offboarding_checklist-row").unbind('click', false)
                    $(".offboarding_workflow_form").hide()
                    $(".offboarding_workflow_form").find("input[type=text]").val("")   
                    td_data = ""
                    td_data += "<td>" + form_data[value].value + "</td>" for value in [content_addition+1..form_data.length-2] 
                    $(".offboarding_workflow_form").before("
                        <tr>" + 
                            td_data +          
                            "<td class='table-action'>
                                <a class='edit-offboarding_checklist-row tooltips' data-original-title='Edit' data-toggle='tooltip' data-details='{&quot;id&quot;:" + op_data.data.id + ",&quot;task&quot;:&quot;" + op_data.data.task + "&quot;,&quot;assign_to&quot;:&quot;" + op_data.data.assign_to + 
                                    "&quot;,&quot;due_date&quot;:&quot;" + op_data.data.due_date + 
                                    "&quot;}' title='' href='#'>
                                  <i class='fa edit-icon'></i>
                                </a>        
                                <a class='delete-row tooltips' data-original-title='Delete' data-toggle='tooltip' data-href='/offboarding_workflows/" + op_data.data.id + "' href='#'> 
                                  <i class='fa close-icon'></i>
                                </a>
                            </td> 
                        </tr>")
                error: -> 
                    save_button.disabled = false
                    save_button.value = "Save"
                    alert "Error Occured!!! Please try again!!!"                
                )
            false
    )

    $("#offboarding_question_form").validate(
        submitHandler: (form) ->
            save_button = $(".offboarding_question_save")[0]
            save_button.disabled = true
            save_button.value = "Saving..."    
            data = $(form)
            form_data = data.serializeArray()
            $.ajax(
                type:"POST"
                url: data.attr("action")
                data: data.serialize()
                datatype: "json"
                success: (op_data)->
                    save_button.disabled = false
                    save_button.value = "Save"
                    $(".edit-offboarding_question-row").unbind('click', false)
                    $(".offboarding_question_form").hide()
                    $(".offboarding_question_form").find("textarea").val("")   
                    td_data = ""
                    td_data += "<td>" + form_data[value].value + "</td>" for value in [content_addition+1..form_data.length-2] 
                    $(".offboarding_question_form").before("
                        <tr>" + 
                            td_data +          
                            "<td class='table-action'>
                                <a class='edit-offboarding_question-row tooltips' data-original-title='Edit' data-toggle='tooltip' data-details='{&quot;id&quot;:" + op_data.data.id + ",&quot;question&quot;:&quot;" + op_data.data.question + "&quot;,&quot;answer&quot;:&quot;" + op_data.data.answer + "&quot;}' title='' href='#'>
                                  <i class='fa edit-icon'></i>
                                </a>        
                                <a class='delete-row tooltips' data-original-title='Delete' data-toggle='tooltip' data-href='/offboarding_questions/" + op_data.data.id + "' href='#'> 
                                  <i class='fa close-icon'></i>
                                </a>
                            </td> 
                        </tr>")
                error: -> 
                    save_button.disabled = false
                    save_button.value = "Save"
                    alert "Error Occured!!! Please try again!!!"                
                )
            false
        )

    $(document).on("click", ".delete-row", (e)->        
        if (confirm("Are you sure?"))
            link = $(this)
            $.ajax(
                type:"DELETE"
                url: link.data().href            
                datatype: "json"
                success: (op_data)->                    
                    if link.data().href.includes("speak_languages")                        
                        value = op_data.language_id             
                        key = link.parent().parent().children().first().text().replace(" ", "")           
                        option = new Option(key, value)
                        $("#speak_languages_language_id").append($(option))
                error: (op_data)->                 
                    alert "Error Occured!!! Please try again!!!"                
                ).done ->
                    link.parent().parent().hide()                                            
        false
    )
    

    $(document).on("click", ".edit-child-row", (e)->
        $(this).tooltip('hide')
        $(".edit-child-row").bind('click', false)
        $(".add_child_panel").click()                     
        link = $(this)
        data = link.data().details        
        $("#emp_child_name").val(data.name)
        $("#emp_child_family_name").val(data.family_name)
        $("#emp_child_gender_id").val(data.gender_id)
        $("#emp_child_country_id").val(data.country_id)        
        $("#emp_child_place_of_birth").val(data.place_of_birth)   
        $("#emp_child_dob").val(data.dob)
        $("#emp_child_child_id").val(data.id)
        link.parent().parent().remove()
        e.preventDefault()                                      
        false
    )

    $(document).on("click", ".edit-education-row", (e)->       
        $(this).tooltip('hide')
        $(".add_education_panel").click()                        
        link = $(this)
        data = link.data().details        
        $(".edit-education-row").bind('click', false)
        $("#education_major").val(data.major)
        $("#education_degree").val(data.degree)
        $("#education_graduation_date").val(data.graduation_date)
        $("#education_duration").val(data.duration)        
        $("#education_institute_name").val(data.institute_name)   
        $("#education_location").val(data.location)
        $("#education_education_id").val(data.id)
        link.parent().parent().remove()
        e.preventDefault()                                      
        false
    )

    $(document).on("click", ".edit-professional_membership-row", (e)->        
        $(this).tooltip('hide')
        $(".add_professional_membership_panel").click()                        
        link = $(this)
        data = link.data().details 
        $(".edit-professional_membership-row").bind('click', false)       
        $("#professional_membership_professional_body").val(data.professional_body)
        $("#professional_membership_level").val(data.level)
        $("#professional_membership_qualification_date").val(data.qualification_date)        
        $("#professional_membership_professional_membership_id").val(data.id)
        link.parent().parent().remove()
        e.preventDefault()                                      
        false
    )

    $(document).on("click", ".edit-previous_employment-row", (e)->        
        $(this).tooltip('hide')
        $(".add_previous_employment_panel").click()                        
        link = $(this)
        data = link.data().details        
        $(".edit-previous_employment-row").bind('click', false)
        $("#previous_employment_start_date").val(data.start_date)
        $("#previous_employment_leave_date").val(data.leave_date)
        $("#previous_employment_company_name").val(data.company_name)        
        $("#previous_employment_country_id").val(data.country_id)        
        $("#previous_employment_job_title").val(data.job_title)        
        $("#previous_employment_previous_employment_id").val(data.id)
        link.parent().parent().remove()
        e.preventDefault()                                      
        false
    )

    $(document).on("click", ".edit-offboarding_checklist-row", (e)->        
        $(this).tooltip('hide')
        $(".add_offboarding_workflow_panel").click()                        
        link = $(this)
        data = link.data().details        
        $(".edit-offboarding_checklist-row").bind('click', false)
        $("#offboarding_workflow_task").val(data.task)
        $("#offboarding_workflow_assign_to").val(data.assign_to)
        $("#offboarding_workflow_due_date").val(data.due_date)                        
        $("#offboarding_workflow_offboarding_checklist_id").val(data.id)
        link.parent().parent().remove()
        e.preventDefault()                                      
        false
    )

    $(document).on("click", ".edit-offboarding_question-row", (e)->        
        $(this).tooltip('hide')
        $(".add_offboarding_question_panel").click()                        
        link = $(this)
        data = link.data().details        
        $(".edit-offboarding_question-row").bind('click', false)
        $("#offboarding_question_question").val(data.question)
        $("#offboarding_question_answer").val(data.answer)                                
        $("#offboarding_question_offboarding_question_id").val(data.id)
        link.parent().parent().remove()
        e.preventDefault()                                      
        false
    )

    $(document).on("click", ".edit-efile-row", (e)->        
        $(this).tooltip('hide')
        $(".add_files_panel").click()                        
        link = $(this)
        data = link.data().details                
        $(".edit-efile-row").bind('click', false)
        $("#efiles_description").val(data.description)
        $("#efiles_file_category_id").val(data.file_category_id)
        $("#checkboxDefault").attr("checked", data.shared_with_manager)                               
        $("#efiles_efile_id").val(data.id)
        $("#efiles_docs").attr("disabled", true)
        $("#efiles_docs").attr("required", false)
        $("#efiles_docs").val("")
        $("#efiles_efile_file_name").val(data.file_name)
        link.parent().parent().remove()
        e.preventDefault()                                      
        false
    )