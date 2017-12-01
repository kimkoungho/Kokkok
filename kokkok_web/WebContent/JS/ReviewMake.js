var change_image=null;
var alter_write=false;

$(document).ready(function (){
   
   $('#review_title').click(function()
   {
   
      if( $('#review_title').hasClass("on"))
         {
            return;
         }
      else
         {      
            $('#review_title').attr('value', "");
            $('#review_title').addClass("on");
         }
   });
   $(document).on("click","#add_tag",function(){
      
      $('.toggle_input_tag').slideToggle();
   });
   $('.tag_btn').click(function(){
     var value=$(this).prev().val();
     var tempArr=value.split("#");
    
     var tempStr = "";

     for(var i=1; i<tempArr.length; i++)
     {
         if( !tempStr.includes(tempArr[i]) )
        	 tempStr += "#" + tempArr[i];
     }
     
     $(".tag_content").val(tempStr);
     var arr = tempStr.split("#");

     $(".toggle_tag_list").empty();
     
     text = "<span class='tag_list' id='add_tag'># 태그</span>";

     for(var i=1; i<arr.length; i++)
         text+="<span class='tag_list'>"+"#"+arr[i]+"</span>";
 
      
      $(this).parent('.toggle_input_tag').prev('.toggle_tag_list').append("  "+text);
      $('.toggle_input_tag').slideToggle();
   });
   $('#file_default').change(function(){
	      
       if (this.files[0]) {
           var reader = new FileReader();  
           reader.onload = function (e) {  
               $('.default_image').parent().css("background-image", "url("+e.target.result+")");
               
              // alert(e.target.result);
           }
           // alert(this.files[0]);
           reader.readAsDataURL(this.files[0]);  
       }else{
          $('.default_image').parent().css("background-image", "url('IMAGES/review_default.svg')");
       }
      
  });
   
   $('#date-range23').dateRangePicker({
      language : 'kor',
      singleMonth : true,
      showShortcuts : false,
      showTopbar : false,
      getValue : function() {
         return this.innerHTML;
      },
      setValue : function(s) {
         var str = s.replace("to", " ~ ");
         $('#date-range-text').text(str);
         
         var date_arr=str.split("~");
         var start_date = date_arr[0];
         var end_date = date_arr[1];
         
         var term=calDateRange(start_date, end_date);
         
         addDate(term+1);
      }
   });
   
});
$(document).on("click",".btn",function(){
   
   //추가될 위치
   var dest=$(this).parent('.btn_list').parent('.toggle_footer').prev('.toggle_content').children('.toggle_content_back').children('.default_btn');
   
   //폼 
   var form=$('#mainForm');
   
   var date=$(this).parent('.btn_list').parent('.toggle_footer').parent('.toggle_container').attr('id');
   var date_index=$(this).parent('.btn_list').parent('.toggle_footer').parent('.toggle_container').index();
   
   var img_index=$(this).parent('.btn_list').parent('.toggle_footer').prev('.toggle_content').children('.toggle_content_back').children('.review_img').length;
   
   //부모의 번호
   var parent_id=date.split("_")[0]+"_"+date.split("_")[1];
   
   var file_index=Number(0);
   var inner_index=Number(0);
   //alert(form.children().length);
   
   for(var i=5; i<form.children().length; i++){
      var child=form.children().eq(i);
      var child_id=child.attr('id');
      
      var temp_id=child_id.split('_')[0]+"_"+child_id.split('_')[1];
      //alert(temp_id);
      if(temp_id==parent_id){// 갯수
         inner_index++;
         
         if(child_id.split('_')[3]=='file'){
            file_index++;
         }
      }
      
   }
   
   //alert(img_index+"............"+file_index);
   
   var file_name=parent_id+"_"+inner_index+"_file";
   var title_name=parent_id+"_"+inner_index+"_title";;
   var content_name=parent_id+"_"+inner_index+"_content";;
   
   
   if($(this).index()==0){
      var text="<div class='write_title_back'>";
        text=text+"<input type='text' class='wrtie_title' />";
        text=text+"</div>";
        
        dest.before(text);
        dest.prev().children('.wrtie_title').focus();
        ///dest.prev('.wrtie_title').focus();
        
        var form_txt="<input type='text' class='write_title' id='"+title_name+"' name='"+title_name+"'/>";
        form.append(form_txt);
        //alert(form_txt);
   }else if($(this).index()==1){
      var text="<div class='write_content_back'>";
        text=text+"<textarea class='write_content' multiple='multiple'></textarea>";
        text=text+"</div>";
        
        dest.before(text);
        dest.prev().children('.write_content').focus();
        //dest.prev('.write_content').focus();
        
        var form_txt="<textarea class='write_content' id='"+content_name+"' name='"+content_name+"'></textarea>";
        form.append(form_txt);
        
   }else if($(this).index()==2){
      //alert($(this).parent('.btn_list').parent('.toggle_footer').parent('.toggle_container').children().eq(1).children('.file1'));
      //var match_file=date.split("_")[0]+"_"+date.split("_")[1]+"_"+img_index+"_file";
      //alert(img_index+"..."+file_index);
      
      
      //이미지의 인덱스와 파일 입력양식의 인덱스가 같을 때만 파일 입력양식을 생성
      if(file_index==img_index){
         var text="<input type='file' name='"+file_name+"' id='"+file_name+"' class='file1' style='display:none;'/>";
         form.append(text);
         $('#'+file_name).click();
      }else{//클릭 이벤트만
         var match_file=null;
         //
         for(var i=0; i<form.children('.file1').length; i++){
            var child=form.children('.file1').eq(i);
            var child_id=child.attr('id');
            
            var temp_id=child_id.split('_')[0]+"_"+child_id.split('_')[1];
            //alert(temp_id+"//////////"+parent_id);
            if(temp_id==parent_id){
               var inner_child=(child_id.split('_')[2]);
               //alert(img_index+"....."+inner_child);
               if(img_index==inner_child){
                  match_file=child;
                  break;
               }
            }
         }
         //alert(match_file);
         if(match_file!=null)
            match_file.click();
      }
      
   }
});
$(document).on("change",".file1",function(){
   //alert('111');
   var id=$(this).attr('id');
   //alert(id);
   var tagname=id.split('_')[0]+"_"+id.split('_')[1]+"_default";
   var img_id=id.split('_')[0]+"_"+id.split('_')[1]+"_"+id.split('_')[2]+"_img";
   
   //alert(img_id);
    if (this.files[0]) {
        var reader = new FileReader();  
        reader.onload = function (e) {
           if(change_image==null){
              //alert(e.target.result);
              var text=
                 "<div class='review_img' id='"+img_id+"'  style='background-image:url("+e.target.result+")'>"+
                 "<img src='IMAGES/transparency.png' style='width:100%'/>"+
                 "</div>";
              $('#'+tagname).before(text);
           }else{
              change_image.css("background-image", "url('"+e.target.result+"')");
              change_image=null;
           }
        }
        //alert(this.files[0]);
        reader.readAsDataURL(this.files[0]);  
    }else{
       $('#'+img_id).remove();
       var form=$('#mainForm');
       for(var i=0; i<form.children('.file1').length; i++){
         var child=form.children('.file1').eq(i);
         var child_id=child.attr('id');
         
         var temp_id=child_id.split('_')[0]+"_"+child_id.split('_')[1]+"_"+child_id.split('_')[2];
         var image_id=img_id.split('_')[0]+"_"+img_id.split('_')[1]+"_"+img_id.split('_')[2];
         if(temp_id==image_id){
            child.remove();
            if(change_image!=null){
               change_image=null;
            }
         }
      }
    }
   
    
});

$(document).on("click",".write_btn",function(){

   //alert($(this).parent().index()+"....."+$(this).index());
   var toggle_container_id=$(this).parent().index()+"_"+(Number(($(this).index())/4)-1);
   //alert(toggle_container_id);
   
   //alert($(this).prev('.site_line').prev('.box_site').children('.site_title').text());
   var text
      ='<div class="toggle_container" style="display:none;" id="'+toggle_container_id+'_container">'
           +'<div class="head">'
              +'<input type="button" class="toggle_cancel_btn" value="취소"/>'
               +'<span class="toggle_title">'+$(this).prev('.site_line').prev('.box_site').children('.site_title').text()+'</span>'
               +'<input type="button" class="toggle_save_btn" value="저장"/>'
          +'</div>'
          +'<div class="toggle_content">'
             +'<div class="toggle_content_back">'
               +'<div class="default_btn" id="'+toggle_container_id+'_default">+ 추가할 항목을 선택하세요</div>'  
            +'</div>'
         +'</div>'
         +'<div class="toggle_footer">'
               +'<div class="btn_list">'
                   +'<div class="btn"><img src="IMAGES/text.svg"/><div>제목</div></div>'
                   +'<div class="btn"><img src="IMAGES/contents.svg"/><div>내용</div></div>'
                   +'<div class="btn"><img src="IMAGES/camera.svg"/><div>사진</div></div>'
               +'</div>'
          +'</div>'
//          +'<form class="write_form" name="'+toggle_container_id+'_form" action="ReviewMakeProc.jsp" enctype="multipart/form-data" method="post">'
//          +'</form>'
        +'</div>';
        
       
   //$('body').append(text);
   $('#toggle').append(text);
   
   
   $('#'+toggle_container_id+'_container').slideToggle();
});

var btn_index;// 버튼이 추가될 장소
$(document).on("click",".area_add_btn",function(){
   $('#dynamic').slideToggle();
   
   btn_index=$(this).prev();
});
$(document).on("click",".toggle_save_btn",function(){
   //작성 완료
   var parent_id=$(this).parent('.head').parent('.toggle_container').attr('id');
   //토글 컨테이너의 아이디
   
   var date=parent_id.split('_')[0];
   var date_seq=parent_id.split('_')[1];
   //alert(date+'...'+date_seq);
   var write_btn=$('#content').children('.total_review_wrap').children('.day_review').eq(Number(date));
   write_btn=write_btn.children('.box_site').eq(Number(date_seq)).next('.site_line').next('.write_btn');
   //작성 버튼의 위치
   
   var content=$("#"+parent_id).children('.toggle_content').children('.toggle_content_back');
   //
   
   var toggle_data="";
   for(var i=0; i<content.children().length-1; i++){
      var content_child=content.children().eq(i).html();
      var content_child_id=content.children().eq(i).attr('id');
      var content_back=content.children().eq(i).css("background-image");
      if(content_child_id==null){
         //alert(content.children().eq(i).attr('class'));
         //alert(content.children().eq(i).attr('class').split("_")[1]);
        if(content.children().eq(i).attr('class').split("_")[1]=="title"){
           toggle_data=toggle_data+
             "<div class='review_sub_title'>"+content_child+"</div>";
        }
        else if(content.children().eq(i).attr('class').split("_")[1]=="content"){
           toggle_data=toggle_data+
             "<div class='review_sub_content'>"+content_child+"</div>"; 
        }
      }else{
         toggle_data=toggle_data+
         "<div class='review_sub_img' id='"+content_child_id+"' style='background-image:"+content_back+"'>"+
         "<img src='IMAGES/transparency.png'>"+
         "</div>";
      }
//      var img_child=content.children().eq(i).attr('src');
//      if(content_child==''){
//         toggle_data=toggle_data+
//         "<img src='"+img_child+"' class=reivew_sub_img id='"+content.children().eq(i).attr('id')+"'>";
//      }else{
//         toggle_data=toggle_data+
//         "<div class='review_sub_content'>"+content_child+"</div>";
//      }
   }
   //alert(toggle_data);
   
   var tour_review_id=date+'_'+date_seq+'_tourReview';
   var text
   ="<div class='tour_review_container' id='"+tour_review_id+"'>"
      +"<div class='tour_review_folder'>"
         +"<div class='tour_review_folder_onoff' value='접기'>나의 여행기 숨기기</div>"
      +"</div>"
      +"<div class='tour_review_content'>"
         +toggle_data
         +"<div class='tour_review_btn_list'>"
            +"<div class='tour_review_modify' value='수정'>수정</div>"
            +"<div class='tour_review_delete' value='삭제'>삭제</div>"
         +"</div>"
      +"</div>"
   +"</div>";
   
//   alert(alter_write);
   if(alter_write){
      alter_write=false;
      var before_review=date+"_"+date_seq+"_tourReview";
      $('#'+tour_review_id).replaceWith(text);
   }else{
      write_btn.replaceWith(text);
   }
   
   $(this).parent('.head').parent('.toggle_container').slideToggle();
});
$(document).on("click",".toggle_cancel_btn",function(){
   if(alter_write){//수정일 때
      alter_write=false;
      $(this).parent('.head').parent('.toggle_container').slideToggle();
      return;   
   }else{// 처음 작성
      $(this).parent('.head').parent('.toggle_container').slideToggle();
      var parent_content=$(this).parent('.head').parent('.toggle_container');
      parent_content.remove();
   }
   
});
//--
$(document).on("click",".write_content_toggle",function(){
   //현재가 작성페이지가 아닌지 검사
   
   
   var swap_tag="<div class='write_content_back'>";
   swap_tag=swap_tag+"<textarea class='write_content'>"+$(this).html().replace(/<br>/g, "\n")+"</textarea>";
   swap_tag=swap_tag+"</div>";
   $(this).replaceWith(swap_tag);
});
function formItemRemove(parentIndex, itemIndex){
   var form=$('#mainForm');
   for(i=5; i<form.children().length; i++){
      var child=form.children().eq(i);
      var child_id=child.attr('id');
      var temp_id=child_id.split('_')[0]+"_"+child_id.split('_')[1];
      
      if(parentIndex==temp_id && itemIndex==child_id.split('_')[2]){
         child.remove();
      }
      
   }
   
}
$(document).on("focusout",".write_content",function(){
//   alert($(this).parent().index());
   var form=$('#mainForm');
   var my_index=$(this).parent('.write_content_back').index();
   
   var parent_index=$(this).parent('.write_content_back').parent('.toggle_content_back').parent('.toggle_content').parent('.toggle_container').attr('id');
   parent_index=parent_index.split('_')[0]+"_"+parent_index.split('_')[1];
   
   if($(this).val()==''){
      //값이 없을 때 form 의 인덱스를 하나씩 땡김
      formItemRemove(parent_index, my_index);
      
      $(this).parent('.write_content_back').remove();
      return;
   }
   
   var swap_tag="<div class='write_content_toggle'>"+$(this).val().replace(/\n/g, "<br>")+"</div>";
   $(this).parent().replaceWith(swap_tag);
   
   var name=parent_index+"_"+my_index+"_content";
   
   document.mainForm.elements[name].value=$(this).val().replace(/\n/g, "<br>");
   //alert(document.mainForm.elements[name].value);
});
$(document).on("click",".write_title_toggle",function(){
   //현재가 작성페이지가 아닌지 검사
   
   
   var swap_tag="<div class='write_title_back'>";
   swap_tag=swap_tag+"<input type='text' class='wrtie_title' value='"+$(this).text()+"'>";
   swap_tag=swap_tag+"</div>";
   $(this).replaceWith(swap_tag);
});
$(document).on("focusout",".wrtie_title",function(){
   var form=$('#mainForm');
   
   var my_index=$(this).parent('.write_title_back').index();
   var parent_index=$(this).parent('.write_title_back').parent('.toggle_content_back').parent('.toggle_content').parent('.toggle_container').attr('id');
   parent_index=parent_index.split('_')[0]+"_"+parent_index.split('_')[1];
   if($(this).val()==''){
      //값이 없을 때 form 의 인덱스를 하나씩 땡김
      
      
      formItemRemove(parent_index, my_index);
      $(this).parent('.write_title_back').remove();

      return;
   }
   var swap_tag="<div class='write_title_toggle'>"+$(this).val()+"</div>";
   $(this).parent().replaceWith(swap_tag);
   
   var name=parent_index+"_"+my_index+"_title";
   //alert(name);
   document.mainForm.elements[name].value=$(this).val();
   //alert(document.mainForm.elements[name].value);
});
$(document).on("click",'.review_img', function(){
   var this_id=$(this).attr('id');
   var file_id=this_id.split('_')[0]+"_"+this_id.split('_')[1]+"_"+this_id.split('_')[2]+"_file";
   
   change_image=$(this);
   //alert(change_image.html());
   $("#"+file_id).click();
});

$(document).on("click",'.tour_review_folder_onoff', function(){
   var swap1=$(this).parent().next();
   if(swap1.css("display") == "none"){
      $(this).text('나의 여행기 숨기기');
   }else{
      $(this).text('나의 여행기 펼치기');
   }
   swap1.slideToggle();
});
$(document).on("click",'.tour_review_modify', function(){
   var parent=$(this).parent('.tour_review_btn_list').parent('.tour_review_content').parent('.tour_review_container');
   
   var parent_id=parent.attr('id').split('_')[0]+"_"+parent.attr('id').split('_')[1];
   
   var toggle_id=parent_id+"_container";
   
   $('#'+toggle_id).slideToggle();
   alter_write=true;
});
$(document).on("click",'.tour_review_delete', function(){
   
   var parent=$(this).parent('.tour_review_btn_list').parent('.tour_review_content').parent('.tour_review_container');
   
   var parent_id=parent.attr('id').split('_')[0]+"_"+parent.attr('id').split('_')[1];
   
   var toggle_id=parent_id+"_container";
   
   var form=$('#mainForm');
   for(var i=5; i<form.children().length; i++){
      var child=form.children().eq(i);
      var child_id=child.attr('id');
      var temp_id=child_id.split('_')[0]+"_"+child_id.split('_')[1];
      if(parent_id==temp_id){
         child.remove();
      }
   }
   
   $('#'+toggle_id).remove();//작성페이지 삭제
   parent.replaceWith("<input type='button' class='write_btn' value='나의 여행기 작성하기'>");// 현재내용 삭제 
});


function addAreaBox(areaObj, area_no){
   if(document.getElementById(area_no)){
      alert('다시 선택해주세요');
      $('#dynamic').toggle();
      return;
   }
   
   btn_index.before(areaObj);
   
   btn_index.before("<input type='button' class='write_btn' value='나의 여행기 작성하기'>");
   
}

function addDate(term){
   var $review_wrap=$('.total_review_wrap');
   
   
   var length=$review_wrap.children('.day_review').length;//현재 날짜
   //alert(term+"…"+length);
   if(length>term){//현재 일차들이 여행기간보다 많음 ,, 여행 기간에 맞게 날짜를 지움
      for(var i=length-1; i>=term; i--){
         $review_wrap.children('.day_review').eq(i).remove();
      }
   }else{//여행기간이 늘어남
      var text="<div class='day_review'><div class='date_bar'><div class='review_date'>";
      for(var i=length; i<term; i++){
         var item=text+(i+1)+"일차</div></div>";
         item=item+"<div class='canvas'><img src='IMAGES/circle.svg' width='100%'/></div>";
         item=item+"<input type='button' class='area_add_btn' value='+ 명소 추가하기'></div>";
         $review_wrap.append(item);
      }
   }
//   $review_wrap.html('');
//   
//   var text="<div class='day_review'><div class='review_date'>";
//   for(var i=1; i<=term; i++){
//      var item=text+(i)+"일차</div>";
//      item=item+"<div class='canvas'>o</div>";
//      item=item+"<input type='button' class='area_add_btn' value='+ 명소 추가하기'></div>";
//      //
//      // item=item+"<input type='text' style='display:none'
//      // name='review_date'/>";
//      //
//      $review_wrap.append(item);
//   }
}
function calDateRange(val1, val2)
{
    var FORMAT = "-";

    // FORMAT이 있는지 체크
    if (val1.indexOf(FORMAT) < 0 || val2.indexOf(FORMAT) < 0)
        return null;

    // 년도, 월, 일로 분리
    var start_dt = val1.split(FORMAT);
    var end_dt = val2.split(FORMAT);

    // 월 - 1(자바스크립트는 월이 0부터 시작하기 때문에…)
    // Number()를 이용하여 08, 09월을 10진수로 인식하게 함.
    start_dt[1] = (Number(start_dt[1]) - 1) + "";
    end_dt[1] = (Number(end_dt[1]) - 1) + "";

    var from_dt = new Date(start_dt[0], start_dt[1], start_dt[2]);
    var to_dt = new Date(end_dt[0], end_dt[1], end_dt[2]);

    return (to_dt.getTime() - from_dt.getTime()) / 1000 / 60 / 60 / 24;
}