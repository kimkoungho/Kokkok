$(document).ready(function () {

    $(".tour_reLink").click(function () {

        $(this).siblings(".tour_reply").toggle();
    });
  
    $('.foot-slide').click(function(){
    	var url="SiteDetail.jsp?area_no="+$(this).attr("id")+"&kind=area";
    	location.href=url;
    });
    
    
    $('.toursite_1').click(function () {
        var index = $(this).index();
        var url = "SiteList.jsp?local=";

        var parent=$(this).parent().attr('id');
        
        if(parent=="up"){
	        switch (index) {
	            case 0: url = url + "괴산군"; break;
	            case 1: url = url + "단양군"; break;
	            case 2: url = url + "보은군"; break;
	            case 3: url = url + "영동군"; break;
	            case 4: url = url + "옥천군"; break;
	        }
        }
        
        else{
	        switch(index){
	        	 case 0: url = url + "음성군"; break;
	             case 1: url = url + "제천시"; break;
	             case 2: url = url + "증평군"; break;
	             case 3: url = url + "진천군"; break;
	             case 4: url = url + "청주시"; break;
	             case 5: url = url + "충주시"; break;
	        }
        }
        
        url = url + "&page=1";
       
        location.href = url;
    });

   
});