$(document).ready(function(){

	//callback handler for form submit
	$(document).on('click','.close_model', function(e){
		$('.upload_files').modal('hide');
	});

	$(document).on("submit",".mile_discussion", function(e)
	{
		var checkDiv  = $(this).closest('div').attr('class')
		var refCurrent = $(this)

		var postData = new FormData(refCurrent[0]);
	    
	    //var postData = $(this).serializeArray();
	    var formURL = $(this).attr("action");

	    $.ajax(
	    {
	        url : formURL,
	        cache: false,
            contentType: false,
            processData: false,
            enctype: 'multipart/form-data',
	        type: "POST",
	        data : postData,
	        dataType: 'json',
	        success:function(data) 
	        {
	        	str = '';
	        	$.each(data, function(key,val){
	        		if(key == 'finalDisTopicArr'){
	        			$.each(val, function(empKey,empVal){

		        			if (typeof empVal.avatar != 'undefined'){	
			        			if ( empVal.avatar == ''){
		    						photoUrl  = url+'profile_photo.png'
		    					}else{
		    						photoUrl  = url+empVal.avatar
		    					}
	    					}

		        			if (checkDiv.toLowerCase().indexOf('comments_form') == -1 ){ //Check parents or child comment button clicked

		        				if ($("#topic_"+empVal.id).length == 0){
		        					
				        			str= '<li id="topic_'+empVal.id+'"><span class="round_img profile_picture"><img src="/assets/'+empVal.photo+'"></span><div class="row mb10 mainTopDiv"><div class="col-xs-2"><span class="bluetext">'+empVal.first_name+' '+empVal.last_name+'</span> </div><div class="col-xs-6"><span class="editTopicCont">'+empVal.topic+'</span>';

				        			if (typeof empVal.avatar != 'undefined'){

				        				if(empVal.avatar_icon == ''){
				        					str+='<div clas="thumbimg"><img src="'+photoUrl+'"></div>'	
				        				}else{
				        					str+='<div clas="thumbimg"><a href="'+url+empVal.avatar+'"><img src="'+empVal.avatar_icon+'"></a></div>'	
				        				}
									}


				        			str+='<input type="text" name="editTopic" id="editTopic" value="'+empVal.topic+'"></div><div class="col-xs-2"> <a data-toggle="modal" data-target="#upload-files" data-original-title="Upload" class="round_thm w_h40 tooltips" href="javascript:void(0);"><i class="centric2 ico_attach"></i></a> <a href="javascript:void(0)" data-toggle="tooltip" title="" class="round_thm w_h40 tooltips" data-original-title="Edit"> <i class="edit-iconnew centric2 mileEdit"></i> </a> <a class="round_thm w_h40 delete-row tooltips" title="" data-toggle="modal" data-target="#delete-confirmation" href="javascript:void(0);" data-original-title="Delete"><i class="close-iconnew centric2 delComLi" data-mile-id="mile_'+empVal.id+'"></i></a> </div><div class="col-xs-2"><a class="btn btn-default text-uppercase pull-right btn-reply semib replyComment" href="javascript:void(0);">reply</a></div></div><div class="row"><div class="col-xs-12"><div class="filter_list mt15 comments_form"><form method="post" accept-charset="UTF-8" action="discussion" class="mile_discussion"><input type="hidden" value="✓" name="utf8"><div class="modal fade upload_files" id="upload-files-child" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"><div role="document" class="modal-dialog width700"><div class="modal-content padding15"><div class="modal-header modal-groupheader"><button aria-label="Close" data-dismiss="modal" class="close" type="button"><span aria-hidden="true">×</span></button><h4 id="myModalLabel" class="modal-title">Attachments1</h4></div><div class="modal-body"><p class="font16 lightgrey">Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, </p><div class="row"><div class="col-xs-12"><div class="borderdotted padding20 text-center dragtext "> <a href="#">Drag and Drop here to upload Files <br>or</a><br><span class="text-center"><div class="file-upload btn btn-default"><span>Upload</span><input type="file" class="upload" name="discussion[avatar]" data-input="false" data-badge="false"  id="filestyle-8" ></div></span> </div></div><div class="col-xs-12 text-uppercase text-center"><div class="font16 mt17 pull-left"><span class="mt12">Attach &nbsp; Documents &nbsp; From</span></div><div class="pull-right"><button class="btn btn-default mt17 border-btn mr10" type="button"><img align="absmiddle" src="/assets/googledrive.png"> Google Drive</button><button class="btn btn-default border-btn mt17" type="button"><img align="absmiddle" src="/assets/dropbox.png"> DropBox</button></div></div></div></div><div class="modal-footer"><div class="form_btns"><button type="button" class="btn btn-default btn-orange close_model">Save</button><a href="javascript:void(0);" class="btn btn-default">Discard</a></div></div></div></div></div><table cellspacing="0" cellpadding="0" width="100%"><tbody><tr><td valign="top" class="filter_length"><div class="search_result"><input type="text" placeholder="Add Comment" class="form-control input-group-lg" id="discussion_topic" name="discussion[topic]"><input type="hidden" value="'+empVal.id+'" name="discussion[comments_parent_id]"></div></td><td valign="top" class="attach_width"><a data-toggle="modal" data-target="#upload-files-child" class="round_thm w_h40" href="javascript:void(0);"><i class="centric2 ico_attach"></i></a></td><td valign="top" class="comment-btn"><input type="submit" class="btn btn-orange" value="COMMENT" name="commit"></td></tr></tbody></table></form></div><ul class="discussion_list list-unstyled comments_ul" ></ul></div></div></li>'
				        				$("ul#discus_ul").prepend(str);	
				        		}		
			        		}else{

			        			if($('#subTopic_'+empVal.id).length == 0){ // Check that children li is not creted yet then only add li

			        				str =  '<li id="subTopic_'+empVal.id+'"><span class="round_img profile_picture"><img src="/assets/'+empVal.photo+'"></span><div class="row childTopic"><div class="col-xs-2"><span class="bluetext">'+empVal.first_name+' '+empVal.last_name+'</div><div class="col-xs-6"><span class="editTopicCont">'+empVal.topic+'</span>'
			        				
			        				if (typeof empVal.avatar != 'undefined'){

				        				if(empVal.avatar_icon == ''){
				        					str+='<div clas="thumbimg"><img src="'+photoUrl+'"></div>'	
				        				}else{
				        					str+='<div clas="thumbimg"><a href="'+url+empVal.avatar+'"><img src="'+empVal.avatar_icon+'"></a></div>'	
				        				}
									}	
			        					

		        					str += '<input type="text" name="editTopic" id="editTopic" value="'+empVal.topic+'"></div><div class="col-md-2 col-sm-3 comment_wrap text-right"><a href="javascript:void(0)" data-toggle="tooltip" title="" class="tooltips round_thm w_h40" data-original-title="Edit"> <i class="edit-iconnew centric2 mileEdit"></i> </a> <a class="delete-row round_thm w_h40 tooltips" title="" data-toggle="modal" data-target="#delete-confirmation" href="javascript:void(0);" data-original-title="Delete"><i class="close-iconnew  centric2 delComLi" data-mile-id="mile_'+empVal.id+'"></i></a> </div></div></li>'
		                    		refCurrent.closest('.col-xs-12').find('ul.comments_ul').prepend(str);	      	
			                    }	
			        		}

	        			})
	        			
	        		}
	        	});
				
	            //data: return data from server
	        },
	        error: function(jqXHR, textStatus, errorThrown) 
	        {
	            //if fails      
	            alert(textStatus)
	        }
	    });
	    e.preventDefault(); //STOP default action
	});

	
	var pubnub = PUBNUB({
	    subscribe_key: 'sub-c-7d092e12-2555-11e5-83e8-02ee2ddab7fe', 
		publish_key: 'pub-c-4b8f55ea-aaf3-4dfc-b64a-57668ee9e2e4', 
		secret_key:'sec-c-NzMwMWU5MTMtYmRlOC00ZTAzLTlhODgtOGM2N2I0YjllNzBk'

	});

	pubnub.subscribe({                                     
        channel : "mile_channel",
        message : function(message,env,ch,timer,magic_ch){
	          console.log(
	          "Message Received." + '<br>' +
	          "Channel: " + ch + '<br>' +
	          "Message: " + JSON.stringify(message) + '<br>' +
	          "Raw Envelope: " + JSON.stringify(env) + '<br>' +
	          "Magic Channel: " + JSON.stringify(magic_ch)
	        )

	        /*When edit topic using pubnub*/  
	        if(typeof message.disId != 'undefined') {

	        	/*Check parent or child clicked*/
	        	if(message.disId.indexOf('subTopic')>=0){
	        		pubRefDiv = $("#"+message.disId).find('.childTopic')
	        	}else{
	        		pubRefDiv = $("#"+message.disId).find('.mainTopDiv')
	        	}/*End*/

	        	pubRefDiv.find('.editTopicCont').text(message.comment)


	        	
	        }/*End*/ 

	        /*When del topic using pubnub*/  
	        if(typeof message.delId != 'undefined'){
	        	
				if (message.delTopic == 'p'){
					var mile_id = 'topic_'+message.delId
				}else{
					var mile_id = 'subTopic_'+message.delId	
				}

				$('li#'+mile_id ).hide( "slow", function() {
					$('li#'+mile_id ).remove()
				});

	        }/*End*/

	        /*Attachment uploaded*/
	        if (typeof message.avatar != 'undefined'){
	        	if (message.avatar == ''){
					photoUrl  = url+'profile_photo.png'
				}else{
					photoUrl  = url+message.avatar
				}
			}/*End*/	

	         if (message.disParentId == '')  {
	         	
    					
	        	if ($("#topic_"+message.id).length == 0){
	        		
		        	str= '<li id="topic_'+message.id+'"><span class="round_img profile_picture"><img src="/assets/'+message.photo+'"></span><div class="row mb10 mainTopDiv"><div class="col-xs-2"><span class="bluetext">'+message.first_name+' '+message.last_name+'</span> </div><div class="col-xs-6"><span class="editTopicCont">'+message.topic+'</span>';
					
					

					if (typeof message.avatar != 'undefined'){

        				if(message.avatar_icon == ''){
        					str+='<div clas="thumbimg"><img src="'+photoUrl+'"></div>'	
        				}else{
        					str+='<div clas="thumbimg"><a href="'+url+message.avatar+'"><img src="'+message.avatar_icon+'"></a></div>'	
        				}
					}

		        	

		        	str += '<input type="text" name="editTopic" id="editTopic" value="'+message.topic+'"></div><div class="col-xs-2"><a data-toggle="modal" data-target="#upload-files" data-original-title="Upload" class="round_thm w_h40 tooltips" href="javascript:void(0);"><i class="centric2 ico_attach"></i></a><a href="javascript:void(0)" data-toggle="tooltip" title="" class="tooltips round_thm w_h40" data-original-title="Edit"> <i class="edit-iconnew centric2 mileEdit"></i> </a> <a class="delete-row tooltips round_thm w_h40" title="" data-toggle="modal" data-target="#delete-confirmation" href="javascript:void(0);" data-original-title="Delete"><i class="close-iconnew centric2 delComLi" data-mile-id="mile_'+message.id+'"></i></a> </div><div class="col-xs-2"><a class="btn btn-default text-uppercase pull-right btn-reply semib replyComment" href="javascript:void(0);">reply</a></div></div><div class="row"><div class="col-xs-12"><div class="filter_list mt15 comments_form"><form method="post" accept-charset="UTF-8" action="discussion" class="mile_discussion"><input type="hidden" value="✓" name="utf8"><div class="modal fade upload_files" id="upload-files-child" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"><div role="document" class="modal-dialog width700"><div class="modal-content padding15"><div class="modal-header modal-groupheader"><button aria-label="Close" data-dismiss="modal" class="close" type="button"><span aria-hidden="true">×</span></button><h4 id="myModalLabel" class="modal-title">Attachments1</h4></div><div class="modal-body"><p class="font16 lightgrey">Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s</p><div class="row"><div class="col-xs-12"><div class="borderdotted padding20 text-center dragtext "> <a href="#">Drag and Drop here to upload Files <br>or</a><br><span class="text-center"><div class="file-upload btn btn-default"><span>Upload</span><input type="file" class="upload" name="discussion[avatar]" data-input="false" data-badge="false"  id="filestyle-8" ></div></span> </div></div><div class="col-xs-12 text-uppercase text-center"><div class="font16 mt17 pull-left"><span class="mt12">Attach &nbsp; Documents &nbsp; From</span></div><div class="pull-right"><button class="btn btn-default mt17 border-btn mr10" type="button"><img align="absmiddle" src="/assets/googledrive.png"> Google Drive</button><button class="btn btn-default border-btn mt17" type="button"><img align="absmiddle" src="/assets/dropbox.png"> DropBox</button></div></div></div></div><div class="modal-footer"><div class="form_btns"><button type="button" class="btn btn-default btn-orange close_model">Save</button><a href="javascript:void(0);" class="btn btn-default">Discard</a></div></div></div></div></div><table cellspacing="0" cellpadding="0" width="100%"><tbody><tr><td valign="top" class="filter_length"><div class="search_result"><input type="text" placeholder="Add Comment" class="form-control input-group-lg" id="discussion_topic" name="discussion[topic]"><input type="hidden" value="'+message.id+'" name="discussion[comments_parent_id]"></div></td><td valign="top" class="attach_width"><a data-toggle="modal" data-target="#upload-files-child" class="round_thm w_h40" href="javascript:void(0);"><i class="centric2 ico_attach"></i></a></td><td valign="top" class="comment-btn"><input type="submit" class="btn btn-orange" value="COMMENT" name="commit"></td></tr></tbody></table></form></div><ul class="discussion_list list-unstyled comments_ul" ></ul></div></div></li>'

			        	$("ul#discus_ul").prepend(str);	

	       		}  
	        }else{
	        	if (!$('#subTopic_'+message.id).length){	// Check that children li is not creted yet then only add li
		        	str =  '<li id="subTopic_'+message.id+'"><span class="round_img profile_picture"><img src="/assets/'+message.photo+'"></span><div class="row childTopic"><div class="col-xs-2"><span class="bluetext">'+message.first_name+' '+message.last_name+'</div><div class="col-xs-6"><span class="editTopicCont">'+message.topic+'</span>'
		        	
		        	if (typeof message.avatar != 'undefined'){
        				if(message.avatar_icon == ''){
        					str+='<div clas="thumbimg"><img src="'+photoUrl+'"></div>'	
        				}else{
        					str+='<div clas="thumbimg"><a href="'+url+message.avatar+'"><img src="'+message.avatar_icon+'"></a></div>'	
        				}
					}


	        		str+='</div><input type="text" name="editTopic" id="editTopic" value="'+message.topic+'"></div><div class="col-md-2 col-sm-3 comment_wrap text-right"><a href="javascript:void(0)" data-toggle="tooltip" title="" class="round_thm w_h40 tooltips" data-original-title="Edit"> <i class="edit-iconnew centric2 mileEdit"></i> </a> <a class="round_thm w_h40 tooltips" title="" data-toggle="modal" data-target="#delete-confirmation" href="javascript:void(0);" data-original-title="Delete"><i class="close-iconnew centric2 delComLi" data-mile-id="mile_'+message.id+'"></i></a> </div></div></li>'

	        		$('#'+message.disParentId).find('ul.comments_ul').prepend(str)
		        		
	        	}	
	        		
	        } 

      	},
        
        
    })

/*Hide Show reply comments section*/	
	 $(document).on('click','.replyComment',function(){
	 	$(this).closest('li').find('div.comments_form').toggle()
	 	$(this).closest('li').find('#discussion_topic').val('')
	 	//$(this).closest('li').find('input[type=file]').val('')
	 })

/*Delete comments section*/
	$(document).on('click','.delComLi',function(){

		var mileId = $(this).data('mile-id').replace('mile_','')
		$.ajax({
			url: 'discussion_del',
			type: 'delete',
			data: {mile_id:mileId},
			dataType:'json',
			success: function(response){
				$.each(response, function(key,val){
	        		if(key == 'delDelStatus'){
	        			if (val.topic == 'p'){
	        				var mile_id = 'topic_'+val.id
	        			}else{
	        				var mile_id = 'subTopic_'+val.id	
	        			}
	        			
	        			  $('li#'+mile_id ).hide( "slow", function() {
						    $(this).remove()
						  });
	        		}		
				});
			}
		});
	});	

/*Show records in input type text box when click on edition*/
	$(document).on('click', '.mileEdit', function(){
		
		var editDiv = $(this).closest('li').attr('id')

		/*Check parent or child clicked*/
		if(editDiv.indexOf('subTopic_') >= 0){
			refDiv = $("#"+editDiv).find('.childTopic')
		}else{
			refDiv = $("#"+editDiv).find('.mainTopDiv')
		}/*End*/

		
		refDiv.find('.editTopicCont').hide()
		
		refDiv.find('#editTopic').show()

		$(this).removeClass('edit-iconnew')
		$(this).closest('a').attr('data-original-title','update')

		$(this).addClass('update-iconnew')

	});

/* Updation of records*/	
	$(document).on('click', '.update-iconnew', function(){
		var discussId = $(this).closest('li').attr('id')
		var updateVal = $('#'+discussId).find('#editTopic').val()
		var curObj = $(this)

		/*Changed update icon to edit*/
		$(this).removeClass('update-iconnew')
		$(this).addClass('edit-iconnew')
		$(this).closest('a').attr('data-original-title','edit')

		$.ajax({
			url: 'discussion_edit',
			type: 'put',
			data: {disId:discussId, updVal:updateVal},
			dataType:'json',
			success: function(response){
				$.each(response, function(key,val){
	        		if(key == 'resUpdate'){

	        			if(discussId.indexOf('subTopic_') >= 0){
	        				refDiv = $("#"+discussId).find('.childTopic')
	        			}else{
	        				refDiv = $("#"+discussId).find('.mainTopDiv')
	        			}

	        			refDiv.find('.editTopicCont').html('')

						refDiv.find('.editTopicCont').html(val.comments)
						refDiv.find('.editTopicCont').show()
						refDiv.find('#editTopic').hide()
						curObj.removeClass('update-iconnew')
	        		}		
				});

			}

		})

	});	

/*End*/


	
});