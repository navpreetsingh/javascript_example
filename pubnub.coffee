# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

	google_list = {"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": {"type": "EXCEL", "pic": "excelicon.png"}, "application/vnd.openxmlformats-officedocument.spreadsheetml.template": {"type": "EXCEL", "pic": "excelicon.png"}, "application/vnd.openxmlformats-officedocument.presentationml.template": {"type": "PRESENTATION TEMPLATE", "pic": "noicon.png"}, "application/vnd.openxmlformats-officedocument.presentationml.slideshow": {"type": "PRESENTATION SLIDESHOW", "pic": "noicon.png"}, "application/vnd.openxmlformats-officedocument.presentationml.presentation": {"type": "PRESENTATION", "pic": "noicon.png"}, "application/vnd.openxmlformats-officedocument.presentationml.slide": {"type": "PRESENTATION SLIDE", "pic": "noicon.png"}, "application/vnd.openxmlformats-officedocument.wordprocessingml.document": {"type": "DOCS", "pic": "docicon.png"}, "application/vnd.openxmlformats-officedocument.wordprocessingml.template": {"type": "DOCS", "pic": "docicon.png"}, "application/vnd.ms-excel.addin.macroEnabled.12": {"type": "EXCEL MACRO ENABLED", "pic": "excelicon.png"}, "application/vnd.ms-excel.sheet.binary.macroEnabled.12": {"type": "EXCEL MACRO ENABLED", "pic": "excelicon.png"}, "application/vnd.ms-excel": {"type": "EXCEL", "pic": "excelicon.png"}, "text/xml": {"type": "XML", "pic": "noicon.png"}, "application/vnd.oasis.opendocument.spreadsheet": {"type": "EXCEL", "pic": "excelicon.png"}, "text/plain": {"type": "TEXT FILE", "pic": "noicon.png"}, "application/pdf": {"type": "PDF", "pic": "pdficon.png"}, "application/x-httpd-php": {"type": "PHP", "pic": "noicon.png"}, "image/jpeg": {"type": "IMAGE", "pic": "noicon.png"}, "image/png": {"type": "IMAGE", "pic": "noicon.png"}, "image/gif": {"type": "IMAGE", "pic": "noicon.png"}, "image/bmp": {"type": "IMAGE", "pic": "noicon.png"}, "application/msword": {"type": "DOCS", "pic": "docicon.png"}, "text/js": {"type": "JAVASCRIPT", "pic": "noicon.png"}, "application/x-shockwave-flash": {"type": "X-SHOCKWAVE FLASH", "pic": "noicon.png"}, "audio/mpeg": {"type": "AUDIO", "pic": "noicon.png"}, "application/zip": {"type": "ZIP", "pic": "noicon.png"}, "application/rar": {"type": "RAR", "pic": "noicon.png"}, "application/tar": {"type": "TAR", "pic": "noicon.png"}, "application/arj": {"type": "ARJ", "pic": "noicon.png"}, "application/cab": {"type": "CAB", "pic": "noicon.png"}, "text/html": {"type": "HTML", "pic": "noicon.png"}, "application/octet-stream": {"type": "DEFAULT", "pic": "noicon.png"}, "application/vnd.google-apps.folder": {"type": "FOLDER", "pic": "folder-icon.png"}, "application/vnd.google-apps.audio": {"type": "AUDIO", "pic": "noicon.png"}, "application/vnd.google-apps.document": {"type": "DOCS", "pic": "docicon.png"}, "application/vnd.google-apps.drawing": {"type": "DRAWING", "pic": "noicon.png"}, "application/vnd.google-apps.file": {"type": "FILE", "pic": "noicon.png"}, "application/vnd.google-apps.form": {"type": "FORM", "pic": "noicon.png"}, "application/vnd.google-apps.fusiontable": {"type": "FUSION TABLES", "pic": "noicon.png"}, "application/vnd.google-apps.photo": {"type": "IMAGE", "pic": "noicon.png"}, "application/vnd.google-apps.presentation": {"type": "SLIDES", "pic": "noicon.png"}, "application/vnd.google-apps.script": {"type": "SCRIPT", "pic": "noicon.png"}, "application/vnd.google-apps.sites": {"type": "SITES", "pic": "noicon.png"}, "application/vnd.google-apps.spreadsheet": {"type": "EXCEL", "pic": "excelicon.png"}, "application/vnd.google-apps.video": {"type": "VIDEO", "pic": "noicon.png"}, "image/svg+xml": {"type": "IMAGE", "pic": "noicon.png"}, "image/x-photoshop": {"type": "PSD", "pic": "noicon.png"}}

	time = (updated) ->
		updated = new Date(Date.parse(updated))		
		date_format = $.datepicker.formatDate('dd/mm/y', updated)
		hours = if updated.getHours() > 12 then updated.getHours() - 12 else updated.getHours()
		minutes = updated.getMinutes()
		suffix = if updated.getHours() >= 12 then "PM" else "AM"
		time_format = hours + ":" + minutes + " " + suffix + " on "		
		format = time_format + date_format

	main_html = (discussion) ->
		image = if discussion.employee == "" or discussion.photo_url == "" or discussion.employee.photo_url.search("profile_photo") >= 0 then "/assets/avatar.png" else url + discussion.employee.photo_url	
		serialize_form = if discussion.task_id == null then (if discussion.milestone_id == null then "project_id=" + discussion.project_id else "milestone_id=" + discussion.milestone_id) else "task_id=" + discussion.task_id
		discussion.comments = if discussion.comments.replace(/\s/g, "").search("<") >= 0 && discussion.comments.replace(/\s/g, "").search("</") >= 0 then discussion.comments.replace(/\</g, "&lt") else discussion.comments		
		delete_button = if is_super_admin == "true" or current_user_id == discussion.project_manager_id + '' then '<a data-confirm="Are you sure?" class="pull-right" data-remote="true" rel="nofollow" data-method="delete" href="/discussions/' + discussion.id + '"> <img alt="Close" src="/assets/close.png">	</a>' else ''		
		edit_button = if is_super_admin == "true" or current_user_id == discussion.project_manager_id + '' or current_user_id == discussion.employee_id + '' then '<a class="pull-right mr10 edit_discussion" href="javascript:void(0);" data-id="' + discussion.id + '"> <img alt="Edit" src="/assets/edit.png"> </a>' else ''
		specify_str = if window.location.pathname.search("project") >= 0 then (if discussion.task_id == null then (if discussion.milestone_id == null then '<span class="info-bandage blue-bandage">COMMENT</span>' else '<span class="info-bandage green-bandage">Milestone</span>' + '<span class="bluetext">' + discussion.track_name.toUpperCase()  + ' </span>') else '<span class="info-bandage lightgreen-bandage">Task</span>' + '<span class="bluetext">' + discussion.track_name.toUpperCase()  + ' </span>') else ""
		str = '<li id="discussion_' + discussion.id + '">
				<span class="round_img profile_picture">
					<img alt="pic" src="' + image + '">			    			
		    	</span>
			    <div class="row">
			      	<div class="col-xs-12 file_types"> 
				        <span class="bluetext">' + 
				        	if discussion.employee == "" then "NIL" else discussion.employee.full_name + '
				        </span>' +
				        specify_str +
				        '<span class="pull-right posting_time">' + 
				        	(time(discussion.updated)) + '
				        </span>
			      	</div>
			      	<div class="col-xs-8">
			       		<strong class="show_comment_' + discussion.id + '"> '  + 
			       			(discussion.comments) + '
			       		</strong>
			       		<div class="update_comment_' + discussion.id + ' hide">
				          <input class="form-control update_comment_input_' + discussion.id + '" value="' + discussion.comments + '" type="text">
				          <input type="button" data-href="/discussions/' + discussion.id + '" value="UPDATE" class="btn btn-orange update_discussion" data-id="' + discussion.id + '">
				        </div> 
			      	</div>
			      	<div class="col-md-2 col-sm-3">' + 
			      		delete_button +
				        edit_button +
			      	'</div>
			      	<div class="col-md-2 col-sm-3">
			        	<a href="/discussions/' + discussion.id + '/reply_form?' + serialize_form + '" data-discussion-id="' + discussion.id + '" class="btn btn-default text-uppercase pull-right btn-reply semib reply_form_link">reply</a>       
			      	</div>
			    </div>
			    <div class="row">' +
			    	(attachments_html(discussion)) + '				      
			      	<div class="col-xs-12">
				        <div class="filter_list mt15 reply_form reply_form_' + discussion.id + '"></div>
				        <ul class="discussion_list list-unstyled reply_list_' + discussion.id + '">			        	
			        	</ul>
			      	</div>
			    </div>
			</li>'		

	reply_html = (reply) ->		
		image = if reply.employee == "" or reply.photo_url == "" or reply.employee.photo_url.search("profile_photo") >= 0 then "/assets/avatar.png" else url + reply.employee.photo_url
		reply.comments = if reply.comments.replace(/\s/g, "").search("<") >= 0 && reply.comments.replace(/\s/g, "").search("</") >= 0 then reply.comments.replace(/\</g, "&lt") else reply.comments
		specify_str = if window.location.pathname.search("project") >= 0 then '<span class="info-bandage blue-bandage">COMMENT</span>' else ""				
		delete_button = if is_super_admin == "true" or current_user_id == reply.project_manager_id + '' then '<a data-confirm="Are you sure?" class="pull-right" data-remote="true" rel="nofollow" data-method="delete" href="/discussions/' + reply.id + '"> <img alt="Close" src="/assets/close.png">	</a>' else ''		
		edit_button = if is_super_admin == "true" or current_user_id == reply.project_manager_id + '' or current_user_id == reply.employee_id + '' then '<a class="pull-right mr10 edit_discussion" href="javascript:void(0);" data-id="' + reply.id + '"> <img alt="Edit" src="/assets/edit.png"> </a>' else ''
		str = '<li id="discussion_' + reply.id + '">
				<span class="round_img profile_picture">
					<img alt="pic" src="' + image + '">			    			
		    	</span>
			    <div class="row">
			      	<div class="col-xs-12 file_types">
			      		<span class="bluetext">' + 
			      			if reply.employee == "" then "NIL" else reply.employee.full_name + 
			      		'</span>			
				        <span class="pull-right posting_time">' + 
				        	(time(reply.updated)) + '
				        </span>
			      	</div>
			      	<div class="col-xs-10">
			       		<strong class="show_comment_' + reply.id + '"> ' + reply.comments + ' </strong>
				        <div class="update_comment_' + reply.id + ' hide">
				          <input class="form-control update_comment_input_' + reply.id + '" value="' + reply.comments + '" type="text">
				          <input type="button" data-href="/discussions/' + reply.id + '" value="UPDATE" class="btn btn-orange update_discussion" data-id="' + reply.id + '">
				        </div> 
			      	</div>
			      	<div class="col-md-2 col-sm-3">' + 
			      		delete_button +
				        edit_button +
			      	'</div>
			    </div>
			    <div class="row">' +
			    	(attachments_html(reply)) + '				      
			      	<div class="col-xs-12">
				        <div class="filter_list mt15 reply_form reply_form_' + reply.id + '"></div>
				        <ul class="discussion_list list-unstyled reply_list_' + reply.id + '">			        	
			        	</ul>
			      	</div>
			    </div>
			</li>'


	attachments_html = (discussion) ->
	    str = '<div class="col-xs-12"> <div class="row">'
	    
	    sub_str_1 = ""
	    for attachment in discussion.attachments
	        mime_type = if google_list[attachment.avatar_content_type] == null then "application/octet-stream" else attachment.avatar_content_type
	        href = url + attachment.avatar_url
	        image_src = google_list[mime_type]["pic"]				    	
	      	 sub_str_1 += '<div class="col-xs-6 col-md-3 col-sm-6 col-lg-2 col-xx-12">     					        		
			          			<div class="attachment_link attachment_' + attachment.id + '">
			            			<div class="filebox">						              	
							            <img alt="image" src="/assets/' + image_src + '">			            
							            <a href="/projects/' + attachment.id + '/delete_attachment" data-remote="true" data-confirm="Are you sure?">  
						              		<div class="fileclose"></div>		            				
						              	</a>
			            			</div>
			            			<a href="' + href + '" target="_blank">				            
			            				<p class="text-center mt10">' + jQuery.trim(attachment.avatar_file_name).substring(0, 15).trim(this) + "..." + '</p>
			            			</a>
			          			</div>			        		
				      		</div>'

        sub_str_2 = ""
        for attachment in discussion.google_attachments
            mime_type = if google_list[attachment.mime_type] == null then "application/octet-stream" else attachment.mime_type
            href = attachment.public_link            
            image_src = google_list[mime_type]["pic"]
            sub_str_2 +='<div class="col-xs-6 col-md-3 col-sm-6 col-lg-2 col-xx-12">				        			    			<div class="attachment_link google_attachment_' + attachment.id + '">
			            			<div class="filebox">			            				
							            <img alt="image" src="/assets/' + image_src + '">			            
							            <a href="/projects/' + attachment.id + '/delete_attachment" data-remote="true" data-confirm="Are you sure?">  
						              		<div class="fileclose"></div>		            				
						              	</a>
			            			</div>				            
			            			<a href="' + href + '" target="_blank">
			            				<p class="text-center mt10">' + jQuery.trim(attachment.name).substring(0, 15).trim(this) + "..." + '</p>			              
			            			</a>	
				          		</div>				        		 
					      	</div>'
     	str += sub_str_1 + sub_str_2

	pubnub = PUBNUB
	    subscribe_key: 'sub-c-7d092e12-2555-11e5-83e8-02ee2ddab7fe'
	    publish_key: 'pub-c-4b8f55ea-aaf3-4dfc-b64a-57668ee9e2e4' 
	    secret_key:'sec-c-NzMwMWU5MTMtYmRlOC00ZTAzLTlhODgtOGM2N2I0YjllNzBk'

	pubnub.subscribe                                     
        channel : "mile_channel",
        message : (message,env,ch,timer,magic_ch) ->
            console.log("Message Received." + '<br>' +
                "Channel: " + ch + '<br>' +
                "Message: " + JSON.stringify(message) + '<br>' +
                "Raw Envelope: " + JSON.stringify(env) + '<br>' +
                "Magic Channel: " + JSON.stringify(magic_ch))                     
            html_formation(message)

	html_formation = (discussion) ->
		main_string = ""
		id = if discussion.task_id == null then (if discussion.milestone_id == null then "project_discussion_" + discussion.project_id else "milestone_discussion_" + discussion.milestone_id) else "task_discussion_" + discussion.task_id				
		if discussion.discussion_id == null
			main_string += main_html(discussion)
			if $(".main_list_" + id).length != 0								
				$(".main_list_" + id).prepend(main_string)				
			if discussion.task_id != null or discussion.milestone_id != null
				project_id = "project_discussion_" + discussion.project_id
				$(".main_list_" + project_id).prepend(main_string)
		else
			if $(".reply_list_" + discussion.discussion_id).length != 0
				main_string += reply_html(discussion)
				$(".reply_list_" + discussion.discussion_id).prepend(main_string)