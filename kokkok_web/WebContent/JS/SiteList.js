function list1Set() {

    var $container = $('#container_site');

    var gutter = 0;
    var min_width = 150;
    //container 에 이미지가 로드 되고 있을 때 실행됨
    //    $container.imagesLoaded( function(){
    $container.masonry({ //masonry 플러그인 적용
        itemSelector: '.box_site', //해당 박스 이름
        gutterWidth: gutter, //
        isAnimated: true,
        columnWidth: function(containerWidth) {
            var box_width = (((containerWidth - 2 * gutter)) | 0);

            if (box_width < min_width) {
                box_width = (((containerWidth - gutter) / 2) | 0);
            }

            if (box_width < min_width) {
                box_width = containerWidth;
            }
            
            $('.box_site').width(box_width);

            return box_width;
        }
    });
    
    //    });
}