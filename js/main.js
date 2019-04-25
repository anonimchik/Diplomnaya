$(function () {
    $('ul.tabs li a').click(function(e){
        e.preventDefault();
        var tab_id = $(this).parent().attr('data-tab');    
        $('ul.tabs li').removeClass('current');
        $('.tab-content').removeClass('current');
        $(this).parent().addClass('current');
        $("#"+tab_id).addClass('current');
    });
    
    $(".match-href").hover(function () {
            $(".fas.fa-video").css("color", "rgb(93, 255, 168)");  
            $(".match-href").css("cursor", "pointer");       
        }, function () {
            $(".fas.fa-video").css("color", "white"); 
        }
    );

    $(".vs").hover(function () {
            $(".vs").css("color", "rgb(193, 241, 135)");    
        }, function () {
            $(".vs").css("color", "white");    
        }
    );

    $(".match-href").click(function () { 
       location.href="#"; //ссылка на страницу матча
    });

    $(".news-image").hover(function () {
            $($(this)).css({
                    "width": "100%",
                    "height": "100%",
                    "object-fit": "cover",
                    "z-index": "1",
                    "flex-wrap": "wrap",
                    "transform": "scale(1.1)",
                    "transition": "all 1s ease-in-out"
            });
            $(this).parent().children(".news-title").children(".title-text").css({"color":"rgb(0,255,102)"});
        }, function () {
            $($(this)).css({
                "width": "100%",
                "height": "100%",
                "object-fit": "cover",
                "z-index": "1",
                "flex-wrap": "wrap",
                "transform": "scale(1)",
                "transition": "all 1s ease-in-out"
        });
        $(this).parent().children(".news-title").children(".title-text").css({"color":"inherit"});
        }
    );

    $("a.enter").click(function (e) { 
        e.preventDefault();
        if($(".registration-invisible").is(":visible"))
        {
            $(".registration-invisible").hide();
        }
        $(".enter-invisible").show();
    });

    $("i.fa-times").click(function (e) { 
        e.preventDefault();
        $(".enter-invisible").hide();
    });

    $("a.registration").click(function (e) { 
        e.preventDefault();
        if($(".enter-invisible").is(":visible"))
        {
            $(".enter-invisible").hide();
        }
        $(".registration-invisible").show();
    });

    $("i.fa-times").click(function (e) { 
        e.preventDefault();
        $(".registration-invisible").hide();
    });

    if($("div").is(".owl-carousel"))
    {
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
    }

});
