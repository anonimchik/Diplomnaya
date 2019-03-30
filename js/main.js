$(function () {
    $(".owl-carousel").owlCarousel(
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
});
