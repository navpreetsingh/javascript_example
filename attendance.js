$(document).ready(function(){

	
	/**Function for overtime edition **/
	$('.overtime_section a.edit-row').click(function(){
		overId = $(this).attr('id').replace('over_','')	
		$.ajax({
			url:'overtime_edit',
			cache: false,
			type: 'post',
			dataType: 'json',
			data:{over_Id:overId},
			success: function(response){
				$.each(response, function(key,value){

					//if(key == 'status' && value == true){

						$('#overtime_form').prepend('<input type="hidden" name="overtime[id]" id="overtime_id" value="'+overId+'" >')
						if (key == 'overTimeDetail'){
							
							$.each(value, function(key,value){

								if(key=='p_name'){
									$('#overtime_p_name').val(value)
								}else if(key == 'status_id'){
									if(value == 1){
										$('#overtime_active').attr('checked',true)
									}else{
										$('#overtime_inactive').attr('checked',true)
									}
								}else if(key == 'max_no_f_hr_day_week'){
									$('#overtime_max_no_f_hr_day_week').val(value)
								}else if(key == 'max_no_f_hr_day_non_week' ){
									$('#overtime_max_no_f_hr_day_non_week').val(value)
								}else if(key == 'val_hr_week'){
									$('#overtime_val_hr_week').val(value)
								}else if(key == 'val_hr_non_week'){
									$('#overtime_val_hr_non_week').val(value)
								}else if(key == 'approved_by'){
									$('#overtime_approved_by').val(value)
								}else if(key == 'calculation'){
									if(value == 'a'){
										$('#calAuto').attr('checked',true)
									}else{
										$('#calManual').attr('checked',true)
									}
								}else if(key == 'group'){
									$('#overtime_group').val(value)
								}else if(key == 'user'){
									$('#overtime_user').val(value)
								}
							})	

						}
					
				});
			}
		})
	})

	/**Deletion for overtime policy**/
	$('.overtime_section a.delete-row').click(function(){
		rowRef = $(this)
		overId = rowRef.attr('id').replace('over_','')
		$.ajax({
			url:'overtimeDel',
			cache:false,
			method:'DELETE',
			dataType:'json',
			data:{over_Id:overId},
			success:function(response){
				$.each(response, function(key,value){
					if(key == 'status' && value == true){
						rowRef.closest('tr').hide("slow", function(){ rowRef.closest('tr').remove(); })
					}	
				})
			}
		})
	})


	
	/**Reset for when we create overtime policy**/
	$('.overtime_create').click(function(){
		$( "#overtime_discard" ).trigger( "click" );
		$('#overtime_active').attr('checked',true)
		$('#calManual').attr('checked',true)
	})

	/**Overtime checkbox checked event handled here bez its default behaviour not working properly bez of some css**/
	$('.over_status').click(function(){
		if($(this).closest('div').hasClass('active_on'))
		{	
			$(this).closest('div').removeClass('active_on');
			$(this).closest('div').find('input[type=checkbox]').val(2);
			$(this).closest('div').find('input[type=hidden]').val(2);
		}
		else
		{
			$(this).closest('div').addClass('active_on');
			$(this).closest('div').find('input[type=checkbox]').val(1);
			$(this).closest('div').find('input[type=hidden]').val(1);
		}
		
	})

	

/** Create Holiday record **/
	$('.holiday_but').click(function(){
		hol_data = $('.holiday_ele').serializeArray();
		
		var trIndex = ""
		
		/* Custom validation */
       if($('#holiday_holiday').val() == "" ){
            alert("Please enter holiday title")
            return false;
        }//End
	    

		/**Check is present for updation otherwise record will be create **/
		if($('#holiday_id').val()){
			var editId  = $("#holi_"+$('#holiday_id').val());
			var	trIndex = $('.holiday_table tr').index(editId.closest('tr'))
		}
		

		$.ajax({
			url:'holiday_create',
			cache:false,
			method:'post',
			data: hol_data,
			dataType:'json',
			success:function(response){
				if(response.status == true){
					$.each(response, function(key,value){
						//if(key == 'status' && value == true){

						if(key =='holiDetails'){
							var holiTit,holiDes,holiDate = ''
							$.each(value, function(holiKey,holiVal){
								
								if(holiKey =='holiday'){
									holiTit = holiVal
								}else if(holiKey =='description'){
									holiDes = holiVal
								}else if(holiKey =='date'){
									if (holiVal!=null){
										holiDate =  new Date(holiVal)
										var dd = holiDate.getDate();
		      							var mm = holiDate.getMonth()+1; //January is 0!
										var yyyy = holiDate.getFullYear();
										holiDate = dd+'/'+mm+'/'+yyyy
									}else{
										holiDate = 'N/A'
									}
								}else if(holiKey =='id'){
									id = holiVal
								}
								
							});

							if(trIndex!=0){ //For edition update row on its original position
								trRef = $('.holiday_table tr:eq('+trIndex+')')
							}else{ //For new record
								trRef = $('.holiday_table tr:last').prev();
							}

							trRef.after('<tr><td>'+holiTit+'</td><td>'+holiDes+'</td> <td>'+holiDate+'</td><td class="table-action"><a id = holi_'+id+' class="tooltips holiEdit" title="" data-toggle="tooltip" href="javascript:void(0);" data-original-title="Edit"><i class="fa edit-icon"></i></a> <a id = holi_'+id+' class="delete-row tooltips holiDel" data-toggle="tooltip" href="javascript:void(0);" data-original-title="Delete"><i class="fa close-icon"></i></a></td></tr>')
							
							if(trIndex!=0){ //Remove edition row 
								$("#holi_"+$('#holiday_id').val()).closest('tr').remove()
							}	
							
							$('#holiday_tr').hide()
						}
							
						//}
					});
				}
			}
		})
	});
	

	/**Show records for edition and removed row because it will be show on edit sextion**/
	$(document).on("click", ".holiEdit", function(event){

		trIndex = $('.holiday_table tr').index($(this).closest('tr'))
		holiId = $(this).attr('id').replace('holi_','')
		
		$('#holiday_id').val(holiId)
		
		/**Geting records for edition**/
		$.ajax({
			url:'holiday_edit',
			cache:false,
			method:'post',
			data:{id:holiId},
			dataType:'json',
			success:function(response){
				
				if(response.status == true){
					$.each(response.holiDetails,function(key,value){
						$('#holiday_holiday').val(value.holiday)
						$('#holiday_description').val(value.description)
						$('#holiday_date').val(value.date)
						$('#holiday_id').show();
					});
					$("#holiday_tr").show()
				}
				
			}

		})

	});


	
	/**Show holiday textbox row**/
	$(".holiday_plus").click(function(){
		if ($('#holiday_tr').is(':hidden')){
			$('#holiday_tr').show()
			$(".holiday_ele").val("");
		}
	})

	/**Delete records for holiday**/
	$(document).on('click','.holiDel',function(){
		holiRef = $(this)
		holiId = holiRef.attr('id').replace('holi_','')
		$('#holiday_id').val(holiId)
		
		/**Geting deletion for edition**/
		$.ajax({
			url:'holiday_delete',
			cache:false,
			method:'post',
			data:{id:holiId},
			dataType:'json',
			success:function(response){
				if(response.status == true){
					holiRef.closest('tr').remove();
				}
				
			}

		})

	});

	$('.top_sub').click(function(){
		$('#attendance_setting').submit();
	});

	$('.top_disc').click(function(){
		$('#attendance_setting').reset();
	});



	
});