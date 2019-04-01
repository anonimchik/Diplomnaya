$(function () {
    $(".owl-carousel").owlCarousel( //установка параметров слайдера 
        {
            autoplay: true,
            loop: true,
            autoplayTimeout: 3000,
            autoplayHoverPause: true,
            nav: true, 
            dotData: true,
            dotsEach: true,
            dots: true,
            navText: ['<i class="fas fa-chevron-circle-left"></i>','<i class="fas fa-chevron-circle-right"></i>']
        }
    );
    $(".owl-stage-outer").css("border", "1px solid #666666");
    $(".owl-prev").addClass("owl-prev");
    $(".owl-next").addClass("owl-next");
    $('ul.tabs li a').click(function(e){
        e.preventDefault();
        var tab_id = $(this).parent().attr('data-tab');    
        $('ul.tabs li').removeClass('current');
        $('.tab-content').removeClass('current');
        $(this).parent().addClass('current');
        $("#"+tab_id).addClass('current');
    })
});
