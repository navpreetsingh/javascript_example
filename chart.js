$(document).ready(function(){

  $('.radioStatus').click(function(){
    var radioOpt = $(this).val()
    window.location = mainUrl+'/ganttchart/'+radioOpt
  })

  $('.gntChart').click(function(){
    window.location = mainUrl+'/ganttchart'
  })

  


/*********************************************************Gantt charts **************************************************/  

  /* Project change event :- making dynamic milestone dropdown */
	$('#prjSelect').change(function(){
        var curRef = $(this)
        var prj_id = curRef.val()

        if (prj_id != 'ganttchart'){
          $.ajax({
            url:'/getMilestone',
            type:'post',
            data:{prjId:prj_id},
            dataType:'json',
            success:function(response){

             //Making milestone selectbox according to project
              var allMile = ''
              var str = ''
        			$('#mileSelect option').remove()
        			
        			if(response.status==1){
        				$.each(response.projectList, function(key,value){
        					str += '<option value="'+value.id+'">'+value.name+'</option>';
                  allMile +=value.id+',' //Concatnate all milestone ids so that all milestone will be show at once
        				});
      			  }

              // allMile = allMile.slice(0, -1);//Removed comma from the last 
              // topOpt='<option value="'+allMile+'">All milestone and project level tasks</option>';

              topOpt='<option value="prj'+prj_id+'">All milestone and project level tasks</option>';
              str = topOpt+str //Add this all milestone option at first
              $('#mileSelect').append(str)

              //Show all milestone on calender according to project

              $.ajax({
                url:'/project_list',
                type:'post',
                data:{prjId:prj_id},
                dataType:'json',
                success:function(response){
                  $(".gantt").gantt({
                      source: response,
                      navigate: "scroll",
                      maxScale: "hours",
                      itemsPerPage: 500
                  });
                }
              })



            }
          });
        }else{
         $(".gantt").gantt({
              source: "/project_list",
              navigate: "scroll",
              maxScale: "hours",
              itemsPerPage: 500
              
          });
        }  
    });


  /* Milestone change event so that show in charts */
    $('#mileSelect').change(function(){
      
      mile_id = $(this).val()

      if(mile_id!=''){ 
        $.ajax({
          url:'/project_list',
          type:'post',
          data:{mileId:mile_id},
          dataType:'json',
          success:function(response){

            $(".gantt").gantt({
                source: response,
                navigate: "scroll",
                maxScale: "hours",
                itemsPerPage: 500
            });

          }
        })
      }  

    });


    $(".gantt").gantt({
        source: "/project_list",
        navigate: "scroll",
        maxScale: "hours",
        itemsPerPage: 500
        // onItemClick: function(data) {
        //   alert("Item clicked - show some details");
        // },
        // onAddClick: function(dt, rowId) {
        //   alert("Empty space clicked - add an item!");
        // },
        // onRender: function() {
        //   if (window.console && typeof console.log === "function") {
        //     console.log("chart rendered");
        //   }
        // }
    });

      // $(".gantt").popover({
      //   selector: ".bar",
      //   title: "I'm a popover",
      //   content: "And I'm the content of said popover.",
      //   trigger: "hover"
      // });
  

  

/*********************************************************Project/Milestone filter **************************************************/


    /* Milestone change event so that result will show in reports */
   $('#prjReport').change(function(){
        var curRef = $(this)
        var id = curRef.val()
        report_opt = $('input[type="radio"]:checked').val()
        if (id!=''){
          $.ajax({
            url:'/getMilestone',
            type:'post',
            data:{prjId:id},
            dataType:'json',
            success:function(response){
              //Fetch all milestone in a dropdown according to project              
              $('#mileReport option').remove()
              allMile = ''
              str='';
              
              if(response.status){
                $.each(response.projectList, function(key,value){
                  str += '<option value="'+value.id+'">'+value.name+'</option>';
                   //allMile +=value.id+',' //Concatnate all milestone ids so that all milestone will be show at once
                });
              }
              // allMile = allMile.slice(0, -1);//Removed comma from the last 
              // topOpt='<option value="'+allMile+'">All milestone</option>';
              // str = topOpt+str //Add this all milestone option at first

              topOpt='<option value="prj'+id+'">All milestone and project level tasks</option>'; //project id bz we hav to show(miles tasks and project task)
              str = topOpt+str //Add this all milestone option at first

              $('#mileReport').append(str)

              //Show all milestone data on report according to project
              $.ajax({
                url: '/generate_report',
                type: 'post',
                data: {prjAlltask:id,reportOpt:report_opt},
                dataType: 'json',
                success: function(response){                                    
                  $('#reportTable tbody tr').remove()
                  if(response.status){
                    $.each(response.reportArr, function(key,value){
                      if (value.tasks!=''){
                        $.each(value.tasks, function(taskKey,taskVal){
                          str = '<tr>';
                          str += "<td class='dark_text'><textarea class='prjName'>"+taskVal.project_name+"</textarea></td>"
                          str += "<td class='dark_text'><textarea class='taskName'>"+taskVal.task_name+"</textarea></td>"
                          str += "<td class='dark_text'>High</td>"
                          if (taskVal.task_status == 4){
                            str += "<td class='dark_text'>Pending</td>"  
                          }else if(taskVal.task_status == 5){
                            str += "<td class='dark_text'>In-Progress</td>"  
                          }else if(taskVal.task_status == 6){
                            str += "<td class='dark_text'>Complete</td>"  
                          }
                          str += "</tr>"  
                          $('#reportTable tbody').append(str)
                        });
                      }else{
                        str = '<tr>';
                          str += "<td class='dark_text'>"+value.project_name+"</td>"
                          str += "<td class='dark_text'>N/A</td>"
                          str += "<td class='dark_text'>N/A</td>"
                          str += "<td class='dark_text'>N/A</td>"
                        str += "</tr>"  
                        $('#reportTable tbody').append(str)
                      }
                    });
                      
                  }else{
                    $('#reportTable tbody').append("<tr><td colspan='4'> No Record Found </tr>")
                  } 
                },
                error: function(response){
                  alert("great");
                }
              });//End
      
            }
          });
        }else{
          $('#mileReport').children('option:not(:first)').remove() // remove milestone all option except first
        }

    });


   /* Milestone change event so that show in reports */
    $('#mileReport').change(function(){
        idArr = $(this).val()
        
        report_opt = $('input[type="radio"]:checked').val()

        /*Reset date input type*/
        $('.date_pick').val('')
        if (idArr!=''){
          $.ajax({
            url:'/generate_report',
            type:'post',
            data:{mileId:idArr,reportOpt:report_opt},
            dataType:'json',
            success:function(response){
              $('#reportTable tbody tr').remove()
               
              if(response.status){
                $.each(response.reportArr, function(key,value){

                  if (value.tasks!=''){
                     $.each(value.tasks, function(taskKey,taskVal){
                        str = '<tr>';
                        str += "<td class='dark_text'><textarea class='prjName'>"+taskVal.project_name+"</textarea></td>"
                        str += "<td class='dark_text'><textarea class='taskName'>"+taskVal.task_name+"</textarea></td>"
                        str += "<td class='dark_text'>High</td>"
                        if (taskVal.task_status == 4){
                          str += "<td class='dark_text'>Pending</td>"  
                        }else if(taskVal.task_status == 5){
                          str += "<td class='dark_text'>In-Progress</td>"  
                        }else if(taskVal.task_status == 6){
                          str += "<td class='dark_text'>Complete</td>"  
                        }
                        str += "</tr>"  
                        $('#reportTable tbody').append(str)
                     });
                  }else{
                    str = '<tr>';
                      str += "<td class='dark_text'>"+value.project_name+"</td>"
                      str += "<td class='dark_text'>N/A</td>"
                      str += "<td class='dark_text'>N/A</td>"
                      str += "<td class='dark_text'>N/A</td>"
                    str += "</tr>"  
                    $('#reportTable tbody').append(str)
                  }

                });
                
              }else{
                $('#reportTable tbody').append("<tr><td colspan='4'> No Record Found </tr>")
              }
            }
          })
        }

    });


/***********************************************************Report Date filter **************************************************/
 
     $( "#date_pick_from" ).datepicker({
       dateFormat: 'yy-mm-dd'
     }); 
    /* Milestone change event so that show in reports */
    $( "#date_pick_to" ).datepicker({
      dateFormat: 'yy-mm-dd',
      onSelect: function(selected,evnt) {
        
        date_from = $('#date_pick_from').val()
        end_to = $('#date_pick_to').val()
        report_opt = $('input[type="radio"]:checked').val()

        if(date_from ==''){
          alert("Please select from date")
          return false
        }

        /*Reset milestone dropdown*/
        //$('#mileReport option').remove('')

        $.ajax({
          url:'/generate_report',
          type:'post',
          data:{reportOpt:report_opt,dateFrom:date_from,endTo:end_to},
          dataType:'json',
          success:function(response){  
                       
            $('#reportTable tbody tr').remove()
            if(response.status){
              $.each(response.reportArr, function(key,value){

                if (value.tasks!=''){
                   $.each(value.tasks, function(taskKey,taskVal){
                      str = '<tr>';
                      str += "<td class='dark_text'><textarea class='prjName'>"+taskVal.project_name+"</textarea></td>"
                      str += "<td class='dark_text'><textarea class='taskName'>"+taskVal.task_name+"</textarea></td>"
                      str += "<td class='dark_text'>High</td>"
                      if (taskVal.task_status == 5){
                        str += "<td class='dark_text'>In-Progress</td>"  
                      }else if(taskVal.task_status == 4){
                        str += "<td class='dark_text'>Pending</td>"  
                      }else if(taskVal.task_status == 6){
                        str += "<td class='dark_text'>Complete</td>"  
                      }
                      str += "</tr>"  
                      $('#reportTable tbody').append(str)
                   });
                }else{
                  str = '<tr>';
                    str += "<td class='dark_text'>"+value.project_name+"</td>"
                    str += "<td class='dark_text'>N/A</td>"
                    str += "<td class='dark_text'>N/A</td>"
                    str += "<td class='dark_text'>N/A</td>"
                  str += "</tr>"  
                  $('#reportTable tbody').append(str)
                }

              });
              
            }else{
              str = "<tr><td colspan='4'> No Record Found </tr>"
              $('#reportTable tbody').append(str)
            }

          }
        })
      } 
    });
    

/***********************************************************Employee basis report **************************************************/

  $('#empList').change(function(){    
    emp_id = $(this).val()
    report_opt = $('input[type="radio"]:checked').val()
    $.ajax({
      url:'/generate_report',
      type:'post',
      data:{reportOpt:report_opt,empId:emp_id},
      dataType:'json',
      success: function(response){      
         
      $('#reportTable tbody tr').remove()
        if(response.status){          
            $.each(response.reportArr, function(key,value){               
               if (value.tasks!=''){
                   $.each(value.tasks, function(taskKey,taskVal){
                      str = '<tr>';
                      str += "<td class='dark_text'><textarea class='prjName'>"+taskVal.project_name+"</textarea></td>"
                      str += "<td class='dark_text'><textarea class='taskName'>"+taskVal.task_name+"</textarea></td>"
                      str += "<td class='dark_text'>High</td>"
                      if (taskVal.task_status == 5){
                        str += "<td class='dark_text'>In-Progress</td>"  
                      }else if(taskVal.task_status == 4){
                        str += "<td class='dark_text'>Pending</td>"  
                      }else if(taskVal.task_status == 6){
                        str += "<td class='dark_text'>Complete</td>"  
                      }
                      str += "</tr>"  
                      $('#reportTable tbody').append(str)
                   });
                }else{
                  str = '<tr>';
                    str += "<td class='dark_text'>"+value.project_name+"</td>"
                    str += "<td class='dark_text'>N/A</td>"
                    str += "<td class='dark_text'>N/A</td>"
                    str += "<td class='dark_text'>N/A</td>"
                  str += "</tr>"  
                  $('#reportTable tbody').append(str)
                } 
              
            });
            
          }else{
            str = "<tr><td colspan='4'> No Record Found </tr>"
            $('#reportTable tbody').append(str)
          }
      },
      error: function(response){
        alert("Error");
        console.log(response);
      }
    })
  })

});

//Forcefully selected all project option when we refresh a page on report
$(window).load(function(){
  $( 'option[value="ganttchart"]' ).prop( 'selected', 'selected' );
})

