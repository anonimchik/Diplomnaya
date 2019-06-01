var fullpath, where="where ", i=0, logoBeforeChange="";

$(function () {

    var page=location.href.replace(/http:\/\/localhost\//,'');
    switch (page) {
        case "tournaments1.php":
            $(".mini-admin-panel").css({"width":"11%"});
            $(".arrow").toggle();
            break;

        case "matches1.php":
            $(".mini-admin-panel").css({"width":"10%"});
            $("#add-record").html('<i class="fas fa-plus"></i>Создать матч');
            $("#delete-record").html('<i class="fas fa-minus"></i>Удалить матч');
            $(".arrow").toggle();
            break;

        case "teams1.php":
            $("#add-record").html('<i class="fas fa-plus"></i>Создать команду');
            $("#delete-record").html('<i class="fas fa-minus"></i>Удалить команду');
            $(".arrow").toggle();
            break;

        case "players1.php":
            $(".mini-admin-panel").css({"width":"11%"});
            $("#add-record").html('<i class="fas fa-plus"></i>Создать игрока');
            $("#delete-record").html('<i class="fas fa-minus"></i>Удалить игрока');
            $(".arrow").toggle();
            break;

        default:

            break;
    }   

    $("span.change-information i.fas.fa-pen-square").click(function (e) { 
        e.preventDefault();
        logoBeforeChange=$(".tour-img img").attr("src");
        $("#tournament-title").show();
        $("#begDate").show();
        $("#begDate").css({"display":"flex",
                        "flex-flow":"row nowrap",
                        "flex-basis":"50%"});
        $("div.prize-block>div.numeric-field").show();
        $("div.prize-block>div.numeric-field").css({"display":"flex",
                        "flex-flow":"row nowrap",
                        "flex-basis":"50%",
                        "justify-content":"space-between"});
        $("#seria").show();
        $("#seria").css({"display":"flex",
                        "flex-flow":"row nowrap",
                        "flex-basis":"50%"});
        $("#primary-seria").hide();
        $("#primary-tournament-title").hide();
        $("#primary-prize").hide();
        $("#primary-begDate").hide();
        $(".tour-img img").css({"border":"2px dashed #666666",
                                "border-radius":"10px"});
        var offset = $("form img").offset();
        var top = offset.top;
        $("html").animate({scrollTop:top}, 1000);
        $(".tour-img").attr("for", "tournament-img");
        $(this).hide();
        $(".hidden-action-panel").show();
    });

    $("#safe-changes").click(function (e) { 
        e.preventDefault();
        var tournamentLogo=$("label.tour-img img").attr("src");
        var tournamentTitle=$("#tournament-title").val();
        var begDate=$("#begDate").val();
        var prize=$("#prize-fond").val();
        var seria=$("#seria").val();
        var idtour=location.href.replace(/http:\/\/localhost\/tournaments1.php\?idtour=/, '');
        var sql="update tournaments set event='"+tournamentTitle+"', tournamentLogo='"+tournamentLogo+"', dateBegin='"+begDate+"', prize="+prize+", seria='"+seria+"' where idTournament="+idtour+"";
        $.ajax({
            type: "POST",
            url: "classes.php",
            data: {
                action : "update tournament data", sql : sql 
            },
            success: function (response) {
                alert(response);
                location.reload();
            }
        });
    });


    $("#no-safe-changes").click(function (e) { 
        e.preventDefault();
        $("#tournament-title").hide();
        $("#begDate").hide();
        $("div.prize-block>div.numeric-field").hide();
        $("#seria").hide();
        $("#primary-seria").show();
        $("#primary-tournament-title").show();
        $("#primary-prize").show();
        $("#primary-begDate").show();
        $(".hidden-action-panel").hide();
        $("span.change-information i.fas.fa-pen-square").show();
        $("label.tour-img").removeAttr("for");
        $("label.tour-img img").css({"border":"none"});
        $("label.tour-img img").attr("src", logoBeforeChange);
    });

    $(".team-block i.far.fa-plus-square").click(function (e) { 
        e.preventDefault();
        $("i.far.fa-plus-square").hide();
        $("#add-tournament-member").show();
        $("#tournament-member").show();
        $(this).parent().css({"justify-content":"center"});
    });

    $("#add-tournament-member").click(function (e) { 
        e.preventDefault();
        var idtour=location.href.replace(/http:\/\/localhost\/tournaments1.php\?idtour=/,'');
        var idTeam=$("#tournament-member").val();
        var sql="insert into tournamentmembers(idTournament, idTeam) values("+idtour+", "+idTeam+")";
        $.ajax({
            type: "POST",
            url: "classes.php",
            data: {
                action: "add tournament member", sql:sql
            },
            success: function (response) {
                alert(response);
                location.reload();
            }
        });
    });

    $('ul.tabs li a').click(function(e){
        e.preventDefault();
        var tab_id = $(this).parent().attr('data-tab');    
        $('ul.tabs li').removeClass('current');
        $('.tab-content').removeClass('current');
        $(this).parent().addClass('current');
        $("#"+tab_id).addClass('current');
    });

    $('ul.maps-tab li a').click(function(e){
        e.preventDefault(); 
        var tab_id = $(this).parent().attr('data-tab');    
        $('ul.maps-tab li').removeClass('current');
        $('.tab-content').removeClass('current');
        $(this).parent().addClass('current');
        $("#"+tab_id).addClass('current');
    });
    
    $("ul.maps-tab li a").click(function (e) { 
        e.preventDefault();
        if(!$(this).parent().parent().parent().children("div.tab-content.current").children("div.img-container").children("img").attr("src"))
        {
            $(this).parent().parent().parent().children("div.tab-content.current").children("div.img-container").children("img").attr("src","./images/mapscore/1.png");
            $(this).parent().parent().parent().children("div.tab-content.current").children("div.img-container").children("img").css({"width":"20%",
                                                                                                                                        "height":"20%",
                                                                                                                                        "object-fit":"contain"});
            $(this).parent().parent().parent().children("div.tab-content.current").children("div.img-container").css({"display":"flex",
                                                                                                                    "flex-direction":"column", 
                                                                                                                    "justify-content":"center",
                                                                                                                    "align-items":"center"});
            $(this).parent().parent().parent().children("div.tab-content.current").children("div.img-container").append("<span class='error-message'>Упс, что-то пошло не так.</span>")
        }
    });

    $("#create-match").click(function (e) { 
        e.preventDefault();
        console.log($("#tournament").val());
        console.log($("#date").val());
        console.log($("#time").val());
    });

    $(".team-teams-block").click(function (e) { 
        e.preventDefault();
        location.href=$(this).attr("data-href");
    });

    $(".team-title").click(function (e) { 
        e.preventDefault();
        location.href=$(this).parent().attr("data-href");
    });

    $(".player").click(function (e) { 
        e.preventDefault();
        console.log($(this).parent().attr("data-href"));
    });

    $(".match-href").hover(function () {
            $(".fas.fa-video").css("color", "rgb(93, 255, 168)");  
            $(".match-href").css("cursor", "pointer");       
        }, function () {
            $(".fas.fa-video").css("color", "white"); 
        }
    );

    $("div.score").click(function (e) { 
        e.preventDefault();
        $(this).text($(this).attr("data-score"));
        //$(this).css({})
    });

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

    $("#logo-tournament").change(function (e) { 
        var filename=$("#logo-tournament")[0].files[0].name;
        fullpath='./images/tournamentLogos/'+filename;
        $(".file-label").html("<img class='image-block' src='"+fullpath+"'>");
        $("img.image-block").css({
                                "width":"100%",
                                "height":"100%",
                                "object-fit":"contain"
        });
    });

    $("#tournament-img").change(function (e) { 
        e.preventDefault();
        var filename=$("#tournament-img")[0].files[0].name;
        fullpath='./images/tournamentLogos/'+filename;
        $(".tour-img").html("<img src='"+fullpath+"'>");
        $("label.tour-img img").css({"cursor":"pointer"});
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

    $(".numeric-field i.fas.fa-minus-circle").click(function (e) { 
        e.preventDefault();
        if($("#prize-fond").val()==""){
            $("#prize-fond").val(0);
        }
        else{
            var prize=Number($("#prize-fond").val());
            if(prize>0)
            {
                $("#prize-fond").val(prize-1);
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

    $(".numeric-field i.fas.fa-plus-circle").click(function (e) { 
        e.preventDefault();
        if($("#prize-fond").val()==""){
            $("#prize-fond").val(0);
        }
        else{
            var prize=Number($("#prize-fond").val());
            if(prize>=0)
            {
                $("#prize-fond").val(prize+1);
            }            
        }
    });

    $(".fas.fa-angle-double-left").click(function (e) { 
        e.preventDefault();
        $(".mini-admin-panel").fadeToggle("slow");
        $("div.arrow").fadeToggle("slow");
    });
    $("div.arrow i.fas.fa-angle-double-right").click(function (e) { 
        e.preventDefault();
        $(".mini-admin-panel").fadeToggle("slow");  
        $("div.arrow").fadeToggle("slow");      
    });

    

    $("#add-record").click(function (e) { 
        e.preventDefault();
        var page=location.href.replace(/http:\/\/localhost\//,'');   
        switch (page) {
            case "index1.php":
                if(!$(".administration-panel-wrapper").is(":visible")){
                    $(".administration-panel-wrapper").css({"display":"flex"});
                    $("#admin-form")[0].reset();
                    var offset = $(".administration-panel").offset();
                    var top = offset.top;
                    $("html").animate({scrollTop:top}, 1000);
                }
                else{
                    var offset = $(".administration-panel").offset();
                    var top = offset.top;
                    $("html").animate({scrollTop:top}, 1000);
                }
                break;
            case "tournaments1.php":
                if(!$(".administration-panel-wrapper").is(":visible")){
                    $(".administration-panel-wrapper").css({"display":"flex"});
                    $("#admin-form")[0].reset();
                    var offset = $(".administration-panel").offset();
                    var top = offset.top;
                    $("html").animate({scrollTop:top}, 1000);
                }
                else{
                    var offset = $(".administration-panel").offset();
                    var top = offset.top;
                    $("html").animate({scrollTop:top}, 1000);
                }
                break;
            default:
                break;
        }
    });

    $("#delete-record").click(function (e) { 
        e.preventDefault(); 
        if(i==0){
            var action=$("#delete-record").html().replace(/<i class="fas fa-minus"><\/i>/,'');
            switch (action) {
                case "Удалить матч":
                    if(!$(".checkbox-del-match").is(":visible")){
                        $(".checkbox-del-match").show();
                        var offset = $(".matches-block-header").offset();
                        var top = offset.top;
                        $("html").animate({scrollTop:top}, 1000);
                    }
                    break;
            
                default:
                    break;
            }
            if(!$(".checkbox-del-tour").is(":visible")){
                $(".checkbox-del-tour").show();
                var offset = $(".tournament-indexx-wrapper").offset();
                var top = offset.top;
                $("html").animate({scrollTop:top}, 1000);
            }
        }
        else{ 
            if(where!="where "){ 
                where=where.substring(0, where.lastIndexOf(" and "));  
                var sql="DELETE FROM tournaments "+where;
                $.ajax({
                    type: "POST",
                    url: "classes.php",
                    data: {
                        action: "deleteTournament", sql: sql
                    },
                    success: function (response) {
                        alert(response);
                        location.reload();
                    }
                    
                });
            }
            else{
                alert("Вы ничего не выбрали");
            }
        }
        i++;
    });

    $("#admin-form").submit(function (e) { 
        e.preventDefault();
        var event=$("#name-tournament").val();
        var logo="./images/tournamentLogos/"+$("#logo-tournament").val().replace(/C:\\fakepath\\/, "")+".png";
        var dateBegin=$("#tournament-date-begin").val();
        var dateEnd=$("#tournament-date-end").val();
        var prize=$("#tournament-prize").val();
        var sql="insert into tournaments(event, tournamentLogo, prize, dateBegin, dateEnd) values('"+event+"', '"+logo+"', "+prize+", '"+dateBegin+"', '"+dateEnd+"')";
        console.log(sql);
        $.ajax({
            type: "POST",
            url: "classes.php",
            data: {
                action: "createTournament", sql:sql
            },
            success: function (response) {
                alert(response);
                location.reload();
            }
        });
    });

    $("input:checkbox:checked").prop("checked", false); //сброс всех чекбоксов при обновлении

    $(".tournament-block-wrapper").change(function (e) { 
        if(!$(this).find("#del-tour").is(":checked")){
            $(this).find(".fa-check").css({"display":"none"});
            $(this).find(".checkbox-del-tour").css({"border":"2px solid #666666"})
            where=where.replace("idTournament="+$(this).attr("data-href").replace("tournaments1.php?idtour=","")+" and ","");
        }
        else{
            $(this).find(".fa-check").css({"display":"block"});
            where+="idTournament="+$(this).attr("data-href").replace("tournaments1.php?idtour=","")+" and ";
            $(this).find(".checkbox-del-tour").css({"border":"2px solid rgb(186, 181, 171)"});
        }      
    });

    $(".match-block-wrapper").change(function (e) { 
        e.preventDefault();
        if(!$(this).find("#del-match").is(":checked")){
            $(this).find(".fa-check").css({"display":"none"});
            $(this).find(".checkbox-del-match").css({"border":"2px solid #666666"})
            //where=where.replace("idTournament="+$(this).attr("data-href").replace("tournaments1.php?idtour=","")+" and ","");
        }
        else{
            $(this).find(".fa-check").css({"display":"block"});
            //where+="idTournament="+$(this).attr("data-href").replace("tournaments1.php?idtour=","")+" and ";
            $(this).find(".checkbox-del-match").css({"border":"2px solid rgb(186, 181, 171)"});
        }      
    });

    $(".team-logo").hover(function () {
           $(this).parent().children(".players-wrapper-block").css({"opacity":"1", "z-index":"10"});
           $(this).css({"opacity":".2"});
        }, function () {
            $(this).parent().children(".players-wrapper-block").css({"opacity":"0"});
            $(this).css({"opacity":"1"});
        }
    );

    $(".players-wrapper-block").hover(function () {
            $(this).css({"opacity":"1", "z-index":"10"});
            $(this).parent().children(".team-logo").css({"opacity":".2"});
        }, function () {
            $(this).css({"opacity":"0"});
            $(this).parent().children(".team-logo").css({"opacity":"1"});
        }
    );

    $(".player").click(function (e) { 
        e.preventDefault();
        location.href=$(this).parent().attr("data-href");
    });

    $(".player-index-block").click(function (e) { 
        e.preventDefault();
        location.href=$(this).attr("data-href");
    });

    
    $(".match-block-wrapper").click(function (e) { 
        e.preventDefault();
        location.href=$(this).attr("data-href");
    });

    /*  настройка google charts */
    google.charts.load("current", {packages:["corechart"]});

    google.charts.setOnLoadCallback(function() {
        var data = [['Actives', ''], ['var 1', 0.1], ['var 2', 0.1]];
        drawChartRound( data, 'donutchart' );
    });

    function drawChartRound( arr_data, id ) {
        var data = google.visualization.arrayToDataTable(arr_data);

        var options = {
            title: '',
            pieHole: 0.6,
            slices: {
                0: { color: 'red' },
                1: { color: 'green' }
            },
            legend         : '1-var 1, 2-var 2',
            backgroundColor: 'transparent',
            chartArea      : {left: 10, top: 10, width: '95%', height: '95%'}
        };

        var chart = new google.visualization.PieChart(document.getElementById(id));
        chart.draw(data, options);
    }

    /* настройка плагина owl-carousel */
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
