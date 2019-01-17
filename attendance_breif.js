$(document).ready(function(){

	
    colOrder = 'asc'
    $('.sortCol').click(function(){

      var colName = $(this).data('colsort')
      if(colOrder == 'asc'){
        var colOrd = 'desc'  
      }else{
        var colOrd = 'asc'  
      }
      
      $.ajax({
          url:'new',
          cache:false,
          type:'Post',
          data:{sortCol:colName, order:colOrd},
          dataType:'json',
          success:function(response){
            alert(response)
          }
      })

    });
	
});