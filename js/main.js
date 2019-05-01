var fullpath;
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
                    "transform": "scale(1.1)",
                    "filter": "saturate(1)",
                    "transition": "all .8s ease-in-out"
            });
            $(this).parent().children(".news-title").children(".title-text").css({"color":"rgb(0,255,102)"});
        }, function () {
            $($(this)).css({
                "width": "100%",
                "height": "100%",
                "object-fit": "cover",
                "z-index": "1",
                "transform": "scale(1)",
                "filter": "saturate(.5)",
                "transition": "all .8s ease-in-out"
        });
        $(this).parent().children(".news-title").children(".title-text").css({"color":"inherit"});
        }
    );
    
    $(".title-text").hover(function () {
            $(this).css({"color":"rgb(0,255,102)"}); 
            $(this).parent().parent().children(".news-image").css({
                "width": "100%",
                "height": "100%",
                "object-fit": "cover",
                "z-index": "1",
                "transform": "scale(1.1)",
                "filter": "saturate(1)",
                "transition": "all .8s ease-in-out" 
            })
        }, function () {
            $(this).css({"color":"inherit"});
            $(this).parent().parent().children(".news-image").css({
                "width": "100%",
                "height": "100%",
                "object-fit": "cover",
                "z-index": "1",
                "transform": "scale(1)",
                "filter": "saturate(1)",
                "transition": "all .8s ease-in-out" 
            })
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

    $(".tournament-block").click(function (e) { 
        e.preventDefault();
        location.href=$(this).attr("data-href");
    });

    $(".tournament-block").hover(function () {
            $(this).css("color", "white");
        }, function () {
            $(this).css("color", "#a6c6cb");
        }
    )

    $("input[type=file]").change(function (e) { 
        var filename=$("#logo-tournament")[0].files[0].name;
        fullpath='./images/tournamentLogos/'+filename;
        $(".file-label").html("<img class='image-block' src="+fullpath+">");
        $("img.image-block").css({
                                "width":"100%",
                                "height":"100%",
                                "object-fit":"contain"
        });
    });

    $(".fa-minus-circle").click(function (e) { 
        e.preventDefault();
        if($("#tournament-prize").val()==""){
            $("#tournament-prize").val(0);
        }
        else{
            var prize=Number($("#tournament-prize").val());
            if(prize>0)
            {
                $("#tournament-prize").val(prize-1);
            }            
        }
    });

    $(".fa-plus-circle").click(function (e) { 
        e.preventDefault();
        if($("#tournament-prize").val()==""){
            $("#tournament-prize").val(0);
        }
        else{
            var prize=Number($("#tournament-prize").val());
            if(prize>=0)
            {
                $("#tournament-prize").val(prize+1);
            }            
        }
    });

    $("#preview").click(function (e) { 
        e.preventDefault();
        var monthName=["Января","Февраля","Марта","Апреля","Мая","Июня","Июля","Августа","Сентября","Октября","Ноября","Декабря"];
        var date=$("#tournament-date-begin").val();
        date=date.split("-");
        var year=date[0];
        var month=date[1];
        var day=date[2];
        date=day+" "+monthName[month.replace("0","")]+" "+year;
        $("div.preview-window-wrapper div.tournament-block div.tournament-title-img span.tournament-name").text($("#name-tournament").val());
        $("div.preview-window-wrapper div.tournament-block div.tournament-title-img img.tournament-img").attr("src", fullpath);
        $("div.preview-window-wrapper div.tournament-block div.date-prize span.date").text(date);
        $("div.preview-window-wrapper div.tournament-block div.date-prize span.prize").text("$"+$("#tournament-prize").val());
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
