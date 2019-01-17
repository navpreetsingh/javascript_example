$(document).ready(function(){
      
	$( "#searchtext" ).autocomplete({
		minLength: 0,
		source: 'get_user_list',
		select: function( event, ui ) {
		  $( "#searchtext" ).val( ui.item.label);
		  $('.autoComplt').attr('href','/attendances/emp_history?emp_id='+ui.item.id)
		  //$( "#searchtext" ).addClass('empId_'+ui.item.id)
		  return false;
		}
	})
	.data( "ui-autocomplete" )._renderItem = function( ul, item ) {
	return $( "<li>" ).data( "item.ui-autocomplete", item ).append('<a><span class="emp_thm round_thm pull-left"><img src="'+url+item.value+'" /></span>'+item.label+'<div class="clearfix"></div></a>' ).appendTo( ul );

	};

	$( "#tim_searchtext" ).autocomplete({
		minLength: 0,
		source: 'get_user_list',
		select: function( event, ui ) {
		  $( "#tim_searchtext" ).val( ui.item.label);
		  $('.timAutoComplt').attr('href','/attendances/emp_history?emp_id='+ui.item.id)
		  //$( "#searchtext" ).addClass('empId_'+ui.item.id)
		  return false;
		}
	})
	.data( "ui-autocomplete" )._renderItem = function( ul, item ) {
	return $( "<li>" ).data( "item.ui-autocomplete", item ).append('<a><span class="emp_thm round_thm pull-left"><img src="'+url+item.value+'" /></span>'+item.label+'<div class="clearfix"></div></a>' ).appendTo( ul );

	};


});
