var headerSize;

$(document).ready(function () {
   
   $('#search_btn').click(function(){
      location.href="SiteList.jsp";
   });
   var course_box_flag=true;
   
   $('#title_toggle_btn').click(function(){
      if(course_box_flag){
         $(this).text('- 접기');
      }else{
         $(this).text('+ 더보기');
      }
      course_box_flag=!course_box_flag;
      
      var size=$('.course_box').length;
      for(var i=1; i<size; i++){
         $('.course_box').eq(i).slideToggle();
      }
   });
   $('#search_btn').click(function(){
      
   });
   
    $(".best_box").click(function ()
    {
        if ($(this).children(".bestCourse").children(".show_course").children(".img_check").hasClass("on"))
        {
            $(this).children(".bestCourse").children(".show_course").children(".scrap_image").css('top', '0px');
            //$(this).css('border', '1px solid #cccccc')
            $(this).css("border", "");

            $(this).children(".bestCourse").children(".content_title").css('opacity', '1');
            $(this).children(".bestCourse").children(".content_addr").css('opacity', '1');
            $(this).children(".bestCourse").children(".BC_map").css('opacity', '1');
            $(this).children(".bestCourse").css('background-color', '#ffffff');
            $(this).children(".bestCourse").children(".show_course").children(".scrap_image").css('opacity', '1');
            $(this).children(".bestCourse").children(".show_course").children(".img_check").toggle();
            $(this).children(".bestCourse").children(".show_course").children(".img_check").removeClass("on");
        }
        else
        {
            $(this).children(".bestCourse").children(".show_course").children(".scrap_image").css('top', '-20px');
            $(this).css('border', '1px solid #0b2e6e')
         
            $(this).children(".bestCourse").children(".content_title").css('opacity', '0.7');
            $(this).children(".bestCourse").children(".content_addr").css('opacity', '0.7');
            $(this).children(".bestCourse").children(".BC_map").css('opacity', '0.7');
            $(this).children(".bestCourse").css('background-color', '#cccccc');
            $(this).children(".bestCourse").children(".show_course").children(".scrap_image").css('opacity', '0.7');
            $(this).children(".bestCourse").children(".show_course").children(".img_check").toggle();
            $(this).children(".bestCourse").children(".show_course").children(".img_check").addClass("on");
        }
    });
    
    
    
    $(".course_btn").click(function ()
    {
        if ($(this).parent('.course_title').parent('.course_box').hasClass("on"))
        {
           $(this).parent('.course_title').parent('.course_box').css('border','1px solid #eaeaea');
           $(this).parent('.course_title').css('background-color','#F6F6F6');
           $(this).prev('.course_name').css('color','#314881');
           
           $(this).css("background-image", "");
           $(this).css("width","auto");
           $(this).css("height","auto");
           $(this).text('담기');
           
           //$(this).next('.img_check2').css('display','none');
           $(this).parent('.course_title').parent('.course_box').removeClass("on");
        }
        else
        {
        	$(this).parent('.course_title').parent('.course_box').css('border','1px solid rgb(11, 46, 110)');
        	$(this).parent('.course_title').css('background-color','#314881');
        	$(this).prev('.course_name').css('color','#ffffff');
        	
        	var w=$(this).css("width");
        	var h=$(this).css("height");
        	$(this).css("background-image", "url(IMAGES/check.png)"); 
        	$(this).text('');
        	$(this).css("width",w);
        	$(this).css("height",h);
        	
        	$(this).parent('.course_title').parent('.course_box').addClass("on");
        }
    });
    
//    $(".img_check2").click(function (){
//       if ($(this).parent().parent().hasClass("on"))
//        {
//           $(this).parent().parent().css('border','1px solid #eaeaea');
//           $(this).parent().css('background-color','#F6F6F6');
//           $('.course_name').css('color','#314881');
//           $('.course_btn').css('color','#ffffff');
//           $('.img_check2').css('display','none');
//           $(this).parent().parent().removeClass("on");
//        }
//    });
    
    
    $('.date').change(function(){
       $('.date option:selected').each(function(){
          var ind=$(this).index();
          
          if(ind==0)
        	  return;
          
          var item=document.getElementById('item').cloneNode(true);
          
          var flag=false;
          while(ind<item.children.length/2){
             ind=ind+1;
             $('#item').children().last().remove();
             $('#item').children().last().remove();
             flag=true;
          }
          if(flag)return;
          
          var text=""; 
          for(var i=item.children.length/2+1; i<=ind; i++){
             text=text
            +"<div class='name'>&nbsp"+i+"일차"
                  +"<div class='fold_icon'><img src='IMAGES/fold.png' width='25%'></div>"
            +"</div>"
             +'<div class="day_wrap">'
                +'<div class="course_day">'
                  +'<div class="site_box">'
                     +'<div class="info">현재 담긴 명소 '+cnt+'곳 (최대 5곳 선택 가능)</div>'
                        +'<select name="site_select" class="site">'
                        +$('.site').html()
                        +'</select>'
                  +'</div>'
                  +'<div class=tot_wrap>'
                     +'<div class="order">'
                     +'</div>'
                     +'<div class="day_site_wrap_total">'
                        
                     +'</div>'
                  +'</div>'
               +'</div>'
         +'</div>';
          }
          // alert(text);
          
          $('#item').append(text);
         
       });
    });
   
});
$(document).on("click",'.delete', function(){
   var parent=$(this).parent().parent();
   
   var day_num=$(this).parent().parent().parent().parent().parent().children('.order').children('.day_num');
   
   var id=$(this).parent().parent().attr('Id');
   var name=$(this).parent().prev().text();
   var text="<option value='"+id+"'>"+name+"</option>";
   $('.site').append(text);
   
   day_num.eq(day_num.length-1).replaceWith('');
   
   parent.next().remove();
   parent.remove();
   
   cnt++;
   $('.info').text('현재 담긴 명소 '+cnt+'곳 (최대 5곳 선택 가능)');
});
$(document).on("click",'.up', function(){
   // alert('1111');
   var parent=$(this).parent().parent().parent();
   var index=parent.index();
   // alert(index);
   
   if(index==0){
      return;
   }else{
      // alert(index);
      
      var prev=parent.prev();
      prev.insertAfter(parent);
// var line_prev=parent.prev();
// line_prev.insertAfter(parent);
   }
});
$(document).on("click",'.down', function(){
   var parent=$(this).parent().parent().parent();
   var index=parent.index();
   // alert(parent.parent().children().length-1);
   if(index==parent.parent().children().length-1){
      return;
   }else{
// alert(index);
      var next=parent.next();
      parent.insertAfter(next);
// var line_next=next.prev();
// line_next.insertAfter(next);
   }
});
$(document).on("change",'.site', function(){
   $('.site option:selected').each(function(){
	   
      var ind=$(this).index();
      
      
      if(ind==0)
         return;
	   
      var name=$(this).text();
      // alert(name);
      // alert($(this).val());
      var parent=$(this).parent().parent().parent();// 최상위 부모
// alert(parent.html());
      var order=parent.children('.tot_wrap').children('.order');// 숫자
      
      var len=order.children().length+1;
      // 추가할 내용
//      
      if(len>5){
    	  alert('5곳 이상 추가할 수 없습니다.');
    	  return;
      }
      //alert(len);
// alert(order.html());
      var order_new='<div class="day_num">'+len+'</div>';
      order.append(order_new);
      
      
      var text
         ='<div class="day_site_wrap" id="wrap'+len+'">'
            +'<div class="day_site" id="'+$(this).val()+'">'
               +'<span class="s_name">'+name+'</span>' 
               +'<span class="icons">'
                  +'<img src="IMAGES/up.png" style="width: 20%; margin: 0 2%;" class="up" />'
                  +'<img src="IMAGES/down.png" style="width: 20%; margin: 0 2%;" class="down" />' 
                  +'<img src="IMAGES/delete.png" style="width: 20%; margin: 0 2%;" class="delete" />'
               +'</span>'
            +'</div>'
         +'</div>'
      +'</div>';
      
      $('.site option[value="'+$(this).val()+'"]').remove();
      $(this).val("0").prop("selected", true);
      var tot_content=parent.children('.tot_wrap').children('.day_site_wrap_total');
      tot_content.append(text);
      
      cnt--;
      $('.info').text('현재 담긴 명소 '+cnt+'곳 (최대 5곳 선택 가능)');
   });
})
$(document).on("click",'.fold_icon', function(){
   var index = $(this).index(".fold_icon");
    $(".day_wrap").eq(index).slideToggle();
});


function list1Set() {
    var $container = $('.best_container');
    var gutter = 5;
    var min_width = 100;
    // container 에 이미지가 로드 되고 있을 때 실행됨
    // $container.imagesLoaded( function(){
    $container.masonry({// masonry 플러그인 적용
        itemSelector: '.best_box', // 해당 박스 이름
        gutterWidth: gutter, //
        isAnimated: true,
        columnWidth: function (containerWidth) {
            var box_width = (((containerWidth - gutter)/ 2)| 0);

            if (box_width < min_width) {
                box_width = (((containerWidth - gutter) / 2) | 0);
            }

            if (box_width < min_width) {
                box_width = containerWidth;
            }

           //alert(containerWidth+"..."+box_width);
            $('.best_box').width(box_width);

            return box_width;
        }
    });
    // });
}