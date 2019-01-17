# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


jQuery ->

    department_id = []
    status_id = []
    country_id = []
    job_title_id = []
    search = ""
    sort = ""
    direction = ""        

    $(".listing-icon").on("click", ->
        if $("#employee_tiles").hasClass("hidden-item") 
            $("#employee_tiles").toggleClass("hidden-item")
            $("#employee_list").toggleClass("hidden-item")
            $(".listing-icon").toggleClass("listing-active")
            $(".grid-icon").toggleClass("grid-active")        
    )

    $(".grid-icon").on("click", ->               
        if $("#employee_list").hasClass("hidden-item")
            $("#employee_tiles").toggleClass("hidden-item")
            $("#employee_list").toggleClass("hidden-item")
            $(".listing-icon").toggleClass("listing-active")
            $(".grid-icon").toggleClass("grid-active")                   
    )    

    $(document).on("click", ".emp_change_status", (e)->        
        link = $(this)        
        id = link.data().id       

        $.ajax(
            type:"GET"
            url: link.data().href
            data: {status_id: link.attr("data-status-id")}
            datatype: "json"
            success: (op_data)->                             
                $("#emp_signal_" + id).toggleClass("green-sign")
                $("#emp_signal_" + id).toggleClass("red-sign")                                 
                if link.attr("data-status-id") == "1"
                    status_text =  "Activate"
                    $(".emp_" + id).attr("data-status-id", 2) 
                else 
                    status_text = "Inactivate"
                    $(".emp_" + id).attr("data-status-id", 1) 
                $("#emp_status_text_" + id).text(status_text)                
            error: (op_data)->                 
                alert "Error Occured!!! Please try again!!!"                
            ).done ->
                
        e.preventDefault()                                      
        false
    )    

    $(document).on("click", ".filter_emp", (e)->        
        link = $(this)
        href = "/employees"
        data = link.data()
        
        if data.sort != undefined
            if sort == data.sort
                direction = if direction == "asc" then "desc" else "asc"
            else
                sort = data.sort
                direction = "asc"                
        
        if data.statusId != undefined 
            process = status_id.indexOf(data.statusId) 
            if process == -1
                status_id.push(data.statusId)
            else
                status_id.splice(process, 1)
        
        if data.departmentId != undefined 
            process = department_id.indexOf(data.departmentId) 
            if process == -1
                department_id.push(data.departmentId)
            else
                department_id.splice(process, 1)
        
        if data.countryId != undefined 
            process = country_id.indexOf(data.countryId) 
            if process == -1
                country_id.push(data.countryId)
            else
                country_id.splice(process, 1)
        
        if data.jobTitleId != undefined 
            process = job_title_id.indexOf(data.jobTitleId) 
            if process == -1
                job_title_id.push(data.jobTitleId)
            else
                job_title_id.splice(process, 1)
        
        $.ajax(
            type:"GET"
            url: href
            data: {status_id: status_id.toString(), department_id: department_id.toString(), country_id: country_id.toString(), job_title_id: job_title_id.toString(), search: search, sort: sort + " " + direction}
            datatype: "json"
            success: (op_data)->
                link.toggleClass("activesec")                                             
            error: ->                 
                alert "Error Occured!!! Please try again!!!"
                if data.statusId != undefined 
                    process = status_id.indexOf(data.statusId) 
                    if process == -1
                        status_id.push(data.statusId)
                    else
                        status_id.splice(process, 1)
                
                if data.departmentId != undefined 
                    process = department_id.indexOf(data.departmentId) 
                    if process == -1
                        department_id.push(data.departmentId)
                    else
                        department_id.splice(process, 1)
                
                if data.countryId != undefined 
                    process = country_id.indexOf(data.countryId) 
                    if process == -1
                        country_id.push(data.countryId)
                    else
                        country_id.splice(process, 1)

                if data.jobTitleId != undefined 
                    process = job_title_id.indexOf(data.jobTitleId) 
                    if process == -1
                        job_title_id.push(data.jobTitleId)
                    else
                        job_title_id.splice(process, 1)                
            ).done ->                
        e.preventDefault()                                      
        false
    )
    
    $("#employee_search_form").submit (e) ->           
        data = $(this)
        href = "/employees"
        search = data.serializeArray()[2].value

        $.ajax(
            type:"GET"
            url: href
            data: {status_id: status_id.toString(), department_id: department_id.toString(), country_id: country_id.toString(), job_title_id: job_title_id.toString(), search: search, sort: sort + " " + direction}
            datatype: "json"
            success: (op_data)->                                                             
            error: ->                 
                alert "Error Occured!!! Please try again!!!"                
            ).done ->                
        e.preventDefault()                                      
        false

    $(document).on("click", ".load_more_emp", (e)->          
        link = $(this)
        href = "/employees"        
        page = link.attr("data-page")     
        link.attr("disabled", true)        
        if page == ""
            alert "No More Records"
        else
            $.ajax(
                type:"GET"
                url: href
                data: {status_id: status_id.toString(), department_id: department_id.toString(), country_id: country_id.toString(), job_title_id: job_title_id.toString(), search: search, page: page, sort: sort + " " + direction}
                datatype: "json"
                success: ->                    
                error: ->                
                    alert "Error Occured!!! Please try again!!!"
                    link.attr("disabled", false)
                ).done ->            
        e.preventDefault()
        false
    )