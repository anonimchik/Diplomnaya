var fullpath, idTournament="";
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
        location.href=$(this).parent().attr("data-href");
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

    $(".add-tournament").click(function (e) { 
        e.preventDefault();
        if(!$(".administration-panel-wrapper").is(":visible")){
            $(".administration-panel-wrapper").css({"display":"flex"});
            var offset = $(".administration-panel").offset();
            var top = offset.top;
            $("html").animate({scrollTop:top}, 1000);
        }
    });

    $(".delete-tournament").click(function (e) { 
        e.preventDefault();
        if(!$(".checkbox-del-tour").is(":visible")){
            $(".checkbox-del-tour").show();
            var offset = $(".tournament-facts-wrapper").offset();
            var top = offset.top;
            $("html").animate({scrollTop:top}, 1000);
        }
    });

    $(".hide-administration-panel").click(function (e) { 
        e.preventDefault();
        if($(this).text()=="Показать панель администратора")
        {
            $(this).html("<i class='far fa-eye-slash'>Скрыть панель администратора</i>");
            if(!$(".checkbox-del-tour").is(":visible")){
                $(".checkbox-del-tour").show();
            }
            if(!$(".administration-panel-wrapper").is(":visible")){
                $(".administration-panel-wrapper").css({"display":"flex"});
                var offset = $(".administration-panel").offset();
                var top = offset.top;
                $("html").animate({scrollTop:top}, 1000);
            }
        }
        else{
            $(this).html("<i class='far fa-eye'>Показать панель администратора</i>");
            $(".checkbox-del-tour").hide();
            $(".administration-panel-wrapper").hide();
        }
    });

    $("#preview").click(function (e) { 
        e.preventDefault();
        var monthName=["Января","Февраля","Марта","Апреля","Мая","Июня","Июля","Августа","Сентября","Октября","Ноября","Декабря"];
        var date=$("#tournament-date-begin").val();
        date=date.split("-");
        var year=date[0];
        var month=date[1];
        console.log(month);
        var day=date[2];
        date=day+" "+monthName[month.replace("0","")]+" "+year;
        $("div.preview-window-wrapper div.tournament-block div.tournament-title-img span.tournament-name").text($("#name-tournament").val());
        $("div.preview-window-wrapper div.tournament-block div.tournament-title-img img.tournament-img").attr("src", fullpath);
        $("div.preview-window-wrapper div.tournament-block div.date-prize span.date").text(date);
        $("div.preview-window-wrapper div.tournament-block div.date-prize span.prize").text("$"+$("#tournament-prize").val());
    });

    $(".tournament-block-wrapper").change(function (e) { 
        if(!$(this).find("#del-tour").is(":checked")){
            $(this).find(".fa-check").css({"display":"none"});
            $(this).find(".checkbox-del-tour").css({"border":"2px solid #666666"})
            idTournament=idTournament.replace($(this).attr("data-href").replace("tournament.php?idtour=","")+",","");
        }
        else{
            $(this).find(".fa-check").css({"display":"block"});
            idTournament+=$(this).attr("data-href").replace("tournament.php?idtour=","")+",";
            $(this).find(".checkbox-del-tour").css({"border":"2px solid rgb(186, 181, 171)"})
        }      
        console.log(idTournament);  
    });

    $("img.team-logo").hover(function () {
            $(this).parent().children("div.players-wrapper-block").css({"opacity":"1"});
            $(this).css({"opacity":".2"});     
        }, function () {
            $(this).css({"opacity":"1"});
            $(this).parent().children("div.players-wrapper-block").css({"opacity":"0"});
        }
    );

    $(".teams-block").click(function (e) { 
        e.preventDefault();
        location.href=$(this).attr("data-href");
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
