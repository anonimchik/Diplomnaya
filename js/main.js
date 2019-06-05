var fullpath, where="where ", i=0, logoBeforeChange="", table="", scriptAction="";

$(function () {

    var page=location.href.replace(/http:\/\/localhost\//,'');
    switch (page) {
        case "tournaments1.php":
            $(".mini-admin-panel").css({"width":"11%"});
            break;

        case "matches1.php":
            $(".mini-admin-panel").css({"width":"10%"});
            $("#add-record").html('<i class="fas fa-plus"></i>Создать матч');
            $("#delete-record").html('<i class="fas fa-minus"></i>Удалить матч');
            break;

        case "teams1.php":
            $("#add-record").html('<i class="fas fa-plus"></i>Создать команду');
            $("#delete-record").html('<i class="fas fa-minus"></i>Удалить команду');
            break;

        case "players1.php":
            $(".mini-admin-panel").css({"width":"11%"});
            $("#add-record").html('<i class="fas fa-plus"></i>Создать игрока');
            $("#delete-record").html('<i class="fas fa-minus"></i>Удалить игрока');
            break;

        default:
            alert(page);
            $(".arrow").hide();
            break;
    }   

    if($.cookie('remember')=='1'){
        $("#entrance-form .login-password input[name='login']").val($.cookie('login'));
        $("#entrance-form .login-password input[name='password']").val($.cookie('password'));
    }

    if($.cookie('user_id')!=null){
        $(".login-info").toggle();
        $(".invisible-user").toggle();
        $(".user-login").text($.cookie('login'));
    }

    $("span.change-information i.fas.fa-pen-square").click(function (e) { 
        e.preventDefault();
        console.log(location.href);
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
        $(".hidden-action-panel").toggle();
    });

    $("div.player-info-wrapper i.fas.fa-pen-square").click(function (e) { 
        e.preventDefault();
        $("#secondary-name").toggle();
        $("#secondary-nickname").toggle();
        $("#secondary-nickname").css({"margin-top":"1em"});
        $("#secondary-birthday").toggle();
        $("#secondary-team").toggle();
        $("#secondary-role").toggle();
        $("#secondary-line").toggle();
        $("span.numeric-field").toggle();
        $(".primary-field").toggle();
        $("i.fas.fa-file-medical").toggle();
        $(".player-info-block div label").toggle();
        $(this).toggle();
        $(".player-info-wrapper label.player-label").attr("for","player-file");
        $(".players-photo").css({"border":"2px dashed #666666",
                                "border-radius":"5px", 
                                "margin-top":"1em",
                                "cursor":"pointer"});
        $(".player-info-wrapper .hidden-action-panel").toggle();
    });

    $(".player-info-wrapper #player-file").change(function (e) {
        e.preventDefault();
        var filename=$(this)[0].files[0].name;
        var fullpath="./images/playerPhotos/"+filename;
        $(".players-photo").attr("src",fullpath);
    })

    $(".player-description-header i.fas.fa-pen-square").click(function (e) { 
        e.preventDefault();
        $(this).toggle();
        $(".admin-textarea").css({"display":"flex"});
        $(".description-block .admin-textarea .hidden-action-panel").show();
        $(".description-block .admin-textarea .hidden-action-panel").css({"margin-top":"1em"});
        $(".primary-textarea").toggle();
    });

    $("#country-flag").change(function (e) { 
        e.preventDefault();
        var filename=$(this)[0].files[0].name;
        var fullpath="./images/countryFlags/"+filename;
        $(".country-name").html(filename.replace(/.png/,'')+'<img style="vertical-align: middle;">');
        $(".country-name img").attr("src",fullpath);
    });

    $("#country-file").change(function (e) { 
        e.preventDefault();
        var filename=$(this)[0].files[0].name;
        var fullpath="./images/countryFlags/"+filename;
        $(".country-flag img").attr("src",fullpath);
        $(".country-flag span").text(filename.replace(/.png/,''));
    });

    $(".team-info-wrapper i.fas.fa-pen-square").click(function (e) { 
        e.preventDefault();
        $(this).toggle();
        $(".country-flag label").toggle();
        $("span.numeric-field").toggle();
        $("#secondary-site").toggle();
        $("#secondary-appereanceDate").toggle();
        $("span.primary-field").toggle();
        $("a.primary-field").toggle();
        $(".team-info-wrapper .hidden-action-panel").toggle();
        $("#secondary-name").toggle();
        $(".team-title").toggle();
    });

    $("#change-tournament-form").submit(function (e) { 
        e.preventDefault();
        var tournamentLogo=$("label.tour-img img").attr("src");
        var tournamentTitle=$("#tournament-title").val();
        var begDate=$("#begDate").val();
        var prize=$("#prize-fond").val();
        var seria=$("#seria").val();
        var idtour=location.href.replace(/http:\/\/localhost\/tournaments1.php\?idtour=/, '');
        var sql="update tournaents set event='"+tournamentTitle+"', tournamentLogo='"+tournamentLogo+"', dateBegin='"+begDate+"', prize="+prize+", seria='"+seria+"' where idTournament="+idtour+"";
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

    $("#change-team-form").submit(function (e) { 
        e.preventDefault();
        var name=$("#secondary-name").val();
        var country=$(".country-flag span").html();
        var countryFlag=$(".country-flag img").attr("src");
        var prize=$("#tournament-prize").val();
        var site=$("#secondary-site").val();
        var appereanceDate=$("#secondary-appereanceDate").val();
        var logo=$(".flag").attr("src");
        var sql="update teams set name='"+name+"', logo='"+logo+"', country='"+country+"', countryFlag='"+countryFlag+"', site='"+site+"', "+
        "prize="+prize+", appearenceDate='"+appereanceDate+"' where idTeam="+location.href.replace(/http:\/\/localhost\/teams1.php\?idteam=/,'');
        console.log(sql);
        $.ajax({
            type: "POST",
            url: "classes.php",
            data: {
                action : "update team", sql : sql
            },
            success: function (response) {
                alert(response);
                location.reload();
            }
        });
    });

    $("#change-team-form .team-info-wrapper .hidden-action-panel #no-safe-changes").click(function (e) { 
        e.preventDefault();
        $(".country-flag label").toggle();
        $("span.numeric-field").toggle();
        $("#secondary-site").toggle();
        $("#secondary-appereanceDate").toggle();
        $("span.primary-field").toggle();
        $("a.primary-field").toggle();
        $(".team-info-wrapper .hidden-action-panel").toggle();
        $("#secondary-name").toggle();
        $(".team-title").toggle();
        $(".team-info-wrapper i.fas.fa-pen-square").toggle();
    });

    $(".description-wrapper .description-title i.fas.fa-pen-square").click(function (e) { 
        e.preventDefault();
        $(this).toggle();
        $(".primary-textarea").toggle();
        $(".admin-textarea").toggle();
        $(".admin-textarea").css({"display":"flex"});
        $(".admin-textarea .hidden-action-panel").css({"margin-top":".5em"});
        $(".admin-textarea .hidden-action-panel").show()
    });

    $(".description-wrapper .description-block .admin-textarea .hidden-action-panel #safe-changes").click(function (e) { 
        e.preventDefault();
        var description=$(".admin-textarea textarea").val();
        var sql="update teams set description='"+description+"' where idTeam="+location.href.replace(/http:\/\/localhost\/teams1.php\?idteam=/,'');
        console.log(sql);
        $.ajax({
            type: "POST",
            url: "classes.php",
            data: {
                action : "update team description", sql : sql
            },
            success: function (response) {
                alert(response);
                location.reload();
            }
        });
    });

    $("#change-player-form").submit(function (e) { 
        e.preventDefault();
        var nickname=$("#secondary-nickname").val();
        var name=$("#secondary-name").val();
        var birthday=$("#secondary-birthday").val();
        var country=$(".country-name").text().replace(/\s/g,'');
        var countryFlag=$(".country-name img").attr("src");
        var team=$("#secondary-team").val();
        var role=$("#secondary-role").val();
        var line=$("#secondary-line").val();
        var prize=$("#tournament-prize").val();
        var sql="update players set nickname='"+nickname+"', name='"+name+"', birthday='"+birthday+"', country='"+country+"', "+
        "countryFlag='"+countryFlag+"', idTeam="+team+", idRole='"+role+"', line='"+line+"', prize="+prize+" where idPlayer="+location.href.replace(/http:\/\/localhost\/players1.php\?idplayer=/,'')+"";
        console.log(sql);
        $.ajax({
            type: "POST",
            url: "classes.php",
            data: {
                action : "update player", sql : sql
            },
            success: function (response) {
                alert(response);
                location.reload();
            }
        });
    });

    $(".admin-textarea .hidden-action-panel #no-safe-changes").click(function (e) { 
        e.preventDefault();
        $(".admin-textarea").toggle();
        $(".primary-textarea").toggle();
        $(".player-description-header i.fas.fa-pen-square").toggle();
        $(".description-wrapper .description-title i.fas.fa-pen-square").toggle();
    });

    $(".maps-block-wrapper .hidden-action-panel #safe-changes").click(function (e) { 
        e.preventDefault();
        var date=$("#secondary-date").val();
        var time=$("#secondary-time").val();
        var format=$("#secondary-format").val();
        var firstScore=$("#first-team-score").val();
        var secondScore=$("#second-team-score").val();
        var round=$("#secondary-round").val();
        var firstTeam=$("#first-team").val();
        var secondTeam=$("#second-team").val();
        var sql="insert into matches()"
    });

    $(".player-description-wrapper .description-block .admin-textarea .hidden-action-panel #safe-changes").click(function (e) { 
        e.preventDefault();
        var description=$(".admin-textarea textarea").val();
        var sql="update players set description='"+description+"' where idPlayer="+location.href.replace(/http:\/\/localhost\/players1.php\?idplayer=/,'')+" ";
        $.ajax({
            type: "POST",
            url: "classes.php",
            data: {
                action : "update player description", sql : sql
            },
            success: function (response) {
                alert(response);
                location.reload();
            }
        });
    });

    $(".player-info-wrapper #change-player-form .hidden-action-panel #no-safe-changes").click(function (e) { 
        e.preventDefault();
        $("#secondary-name").toggle();
        $("#secondary-nickname").toggle();
        $("#secondary-nickname").css({"margin-top":"1em"});
        $("#secondary-birthday").toggle();
        $("#secondary-team").toggle();
        $("#secondary-role").toggle();
        $("#secondary-line").toggle();
        $("span.numeric-field").toggle();
        $(".primary-field").toggle();
        $("i.fas.fa-file-medical").toggle();
        $(".player-info-block div label").toggle();
        $(".player-info-wrapper label.player-label").attr("for","player-file");
        $(".players-photo").css({"border":"none",
                                "margin":"0"});
        $(".player-info-wrapper .hidden-action-panel").toggle();
        $("#change-player-form i.fas.fa-pen-square").toggle();
    });

    $(".tournament-info-block form .hidden-action-panel #no-safe-changes").click(function (e) { 
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
        var tour=$("#tournament").val();
        var firstTeam=$("#first-team").val();
        var secondTeam=$("#second-team").val();
        var date=$("#date").val();
        var time=$("#time").val();
        var datetime=date+" "+time;
        var now=new Date();
        if(datetime>now){status=-1}else{status=1}
        var sql="insert into matches(idTournament, idFirstTeam, idSecondTeam, date, status) values("+tour+", "+firstTeam+", "+secondTeam+", '"+datetime+"', "+status+")";
        alert(sql);
        $.ajax({
            type: "POST",
            url: "classes.php",
            data: {
                action : "insert match", sql : sql
            },
            success: function (response) {
                alert(response);
                location.reload();
            }
        });
    });

    $("#create-player").click(function (e) { 
        e.preventDefault();
        name=$("#player-name").val();
        nickname=$("#player-nickname").val();
        if($(".image-block").length){photo=$(".image-block").attr("src");}else{photo="";}
        team=$("#player-team").val();
        birthday=$("#player-birthday").val();
        role=$("#player-role").val();
        var sql="insert into players(name, idDiscipline, nickname, birthday, photoRef, idTeam, idRole) values('"+name+"', 1, '"+nickname+"', '"+birthday+"', '"+photo+"', "+team+", '"+role+"')";
        $.ajax({
            type: "POST",
            url: "classes.php",
            data: {
                action : "insert player", sql : sql
            },
            success: function (response) {
                alert(response);
                location.reload();
            }
        });
    });

    $("#create-team").click(function (e) { 
        e.preventDefault();
        var name=$("#team-name").val();
        var appereanceDate=$("#appereanceDate").val();
        if($(".image-block").length){teamLogo=$(".image-block").attr("src");}else{teamLogo="";}
        var sql="insert into teams(idDiscipline, name, logo, appereanceDate) values(1, '"+name+"', '"+teamLogo+"', '"+appereanceDate+"')";
        $.ajax({
            type: "POST",
            url: "classes.php",
            data: {
                action : "insert team", sql : sql
            },
            success: function (response) {
                alert(response);
                location.reload();  
            }
        });
    });

    $(".team-teams-block").click(function (e) { 
        e.preventDefault();
        location.href=$(this).attr("data-href");
    });

    $("a.team-title").click(function (e) { 
        e.preventDefault();
        location.href=$(this).parent().attr("data-href");
    });

    $(".line-up-block").click(function (e) { 
        e.preventDefault();
        location.href=$(this).attr("data-href");
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

    $(".first-team-players-block #first-team").change(function (e) { 
       e.preventDefault();
       $.ajax({
           type: "POST",
           url: "classes.php",
           data: {
               action : "show selected team", idTeam : $(this).val()
           },
           success: function (response) {
                html=JSON.parse(response);
                $(".first-team-players-block .players-wrapper").html(html.player);
                $(".first-team-description .img-wrapper").html(html.country);
           }
       });
   });

   $(".match-description-wrapper i.fas.fa-pen-square").click(function (e) { 
       e.preventDefault();
       $(this).toggle();
       $(".maps-block-wrapper .hidden-action-panel").toggle();
       $(".primary-team").toggle();
       $(".secondary-datetime").toggle();
       $("#secondary-format").toggle();
       $(".secondary-score").toggle();
       $("#secondary-round").toggle();
       $(".primary-field").toggle();
   });

   $(".maps-block-wrapper .hidden-action-panel #no-safe-changes").click(function (e) { 
       e.preventDefault();
       $(".match-description-wrapper i.fas.fa-pen-square").toggle();
       $(".maps-block-wrapper .hidden-action-panel").toggle();
       $(".primary-team").toggle();
       $(".secondary-datetime").toggle();
       $("#secondary-format").toggle();
       $(".secondary-score").toggle();
       $("#secondary-round").toggle();
   });

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

        $("#entrance-form").submit(function (e) { 
            var remember="";
            e.preventDefault();
            var login=$(".login-password input[name='login']").val();
            var password=$(".login-password input[name='password']").val();
            if($(".remember-forgot label input[name='remember']").prop('checked')){remember=1;}else{remember=0;}
            $.ajax({
                type: "POST",
                url: "classes.php",
                data: {
                   action : "enter", remember : remember, login : login, password : password
                },
                success: function (response) {
                    json=JSON.parse(response);
                    $.cookie('user_id', json.user, {path : '/'});
                    $.cookie('login', json.login, {path : '/'});
                    $.cookie('password', json.password, {path : '/'});
                    $.cookie('remember', json.remember, {path : '/'});
                    alert(json.message);
                    if($(".invisible-user").is(":visible")==false){
                        $(".arrow").toggle();
                    }
                    else{
                        $(".arrow").toggle();
                    }
                    console.log($.cookie('remember'));
                }
            });
            $(".login-password input[name='login']").val($.cookie('login'));
            $(".login-password input[name='password']").val($.cookie('password'));
            $(".invisible-user").toggle();
            $(".login-info").toggle();
            $(".enter-invisible").toggle();
            $("span.user-login").text($.cookie('login'));
        });

        $(".invisible-user i.fas.fa-sign-out-alt").click(function (e) { 
            e.preventDefault();
            $.removeCookie('user_id');
            $(".invisible-user").toggle();
            $(".login-info").toggle();
        });

        $("#registration-form").submit(function (e) { 
            e.preventDefault();
            var login=$("#registration-form .login-password input[name='login']").val();
            var password=$("#registration-form .login-password input[name='password']").val();
            var sql="insert into autorization(login, password) value('"+login+"', md5('"+password+"'))";
            $.ajax({
                type: "POST",
                url: "classes.php",
                data: {
                    action : "insert user", sql: sql
                },
                success: function (response) {
                    alert(response);
                }
            });
        });

    $("a.enter").click(function (e) { 
        e.preventDefault();
        if($(".registration-invisible").is(":visible"))
        {
            $(".registration-invisible").toggle();
        }
        $(".enter-invisible").toggle();
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

    $("#team-file").change(function (e) { 
        e.preventDefault();
        var filename=$("#team-file")[0].files[0].name;
        fullpath='./images/teamLogos/'+filename;
        $(".team-info-wrapper label img").attr("src",fullpath);
    });

    $("#player-photo").change(function (e) { 
        e.preventDefault();
        var filename=$("#player-photo")[0].files[0].name;
        fullpath='./images/playerPhotos/'+filename;
        $(".file-label").html("<img class='image-block' src='"+fullpath+"'>");
        $("img.image-block").css({
                                "width":"100%",
                                "height":"100%",
                                "object-fit":"contain"
        });
    });

    $("#team-logo").change(function (e) { 
        e.preventDefault();
        var filename=$("#team-logo")[0].files[0].name;
        fullpath='./images/teamLogos/'+filename;
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
        if(!$(".administration-panel-wrapper").is(":visible")){
            $(".administration-panel-wrapper").css({"display":"flex"});
            $(".admin-form")[0].reset();
            var offset = $(".administration-panel").offset();
            var top = offset.top;
            $("html").animate({scrollTop:top}, 1000);
        }
        else{
            var offset = $(".administration-panel").offset();
            var top = offset.top;
            $("html").animate({scrollTop:top}, 1000);
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
                    table="matches";
                    scriptAction="delete match";
                break;
                
                case "Удалить турнир":
                    if(!$(".checkbox-del-tour").is(":visible")){
                        $(".checkbox-del-tour").show();
                        var offset = $(".tournament-indexx-wrapper").offset();
                        var top = offset.top;
                        $("html").animate({scrollTop:top}, 1000);
                    }
                    table="tournaments";
                    scriptAction="delete tournament";
                break;

                case "Удалить игрока":
                    if(!$(".checkbox-del-player").is(":visible")){
                        $(".checkbox-del-player").show();
                        var offset = $(".player-block-wrapper").offset();
                        var top = offset.top;
                        $("html").animate({scrollTop:top}, 1000);
                    }
                    table="players";
                    scriptAction="delete player";
                break;
                
                case "Удалить команду":
                    if(!$(".checkbox-del-team").is(":visible")){
                        $(".checkbox-del-team").show();
                        var offset = $(".teams-wrapper").offset();
                        var top = offset.top;
                        $("html").animate({scrollTop:top}, 1000);
                    }
                    table="teams";
                    scriptAction="delete team";
                break;

                default:
                    break;
            }
        }
        else{ 
            if(where!="where "){ 
                where=where.substring(0, where.lastIndexOf(" and "));  
                var sql="DELETE FROM "+table+" "+where;
                console.log(sql);
                $.ajax({
                    type: "POST",
                    url: "classes.php",
                    data: {
                        action: scriptAction, sql: sql
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
        if(!$(this).find(".del-match").is(":checked")){
            $(this).find(".fa-check").css({"display":"none"});
            $(this).find(".checkbox-del-match").css({"border":"2px solid #666666"})
            where=where.replace("idMatch="+$(this).children(".teams-tournament-block").attr("data-href").replace("matches1.php?idmatch=",'')+" and ",'');       
        }
        else{
            $(this).find(".fa-check").css({"display":"block"});
            $(this).find(".checkbox-del-match").css({"border":"2px solid rgb(186, 181, 171)"});
            where+="idMatch="+$(this).children(".teams-tournament-block").attr("data-href").replace(/matches1.php\?idmatch=/,'')+" and ";
        }      
    });

    $(".player-index-block").change(function (e) { 
        e.preventDefault();
        if(!$(this).find(".del-player").is(":checked")){
            $(this).find(".fa-check").css({"display":"none"});
            $(this).find(".checkbox-del-player").css({"border":"2px solid #666666"})
            where=where.replace("idPlayer="+$(this).children(".player-list").attr("data-href").replace(/players1.php\?idplayer=/,'')+" and ",'');       
        }
        else{
            $(this).find(".fa-check").css({"display":"block"});
            $(this).find(".checkbox-del-player").css({"border":"2px solid rgb(186, 181, 171)"});
            where+="idPlayer="+$(this).children(".player-list").attr("data-href").replace(/players1.php\?idplayer=/,'')+" and ";
        }      
    });

    $(".teams-block-wrapper").change(function (e) { 
        e.preventDefault();
        if(!$(this).find(".del-team").is(":checked")){
            $(this).find(".fa-check").css({"display":"none"});
            $(this).find(".checkbox-del-team").css({"border":"2px solid #666666"})
            where=where.replace("idTeam="+$(this).children(".team-teams-block").attr("data-href").replace(/teams1.php\?idteam=/,'')+" and ",'');       
        }
        else{
            $(this).find(".fa-check").css({"display":"block"});
            $(this).find(".checkbox-del-team").css({"border":"2px solid rgb(186, 181, 171)"});
            where+="idTeam="+$(this).children(".team-teams-block").attr("data-href").replace(/teams1.php\?idteam=/,'')+" and ";
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

        $(".team").click(function (e) { 
            e.preventDefault();
            location.href=$(this).attr("data-href")
        });

    $(".player").click(function (e) { 
        e.preventDefault();
        location.href=$(this).parent().attr("data-href");
    });

    $(".player-list").click(function (e) { 
        e.preventDefault(); 
        console.log($(this).attr("data-href"));
        //location.href=$(this).attr("data-href");
    });

    
    $(".teams-tournament-block").click(function (e) { 
        e.preventDefault();
        location.href=$(this).attr("data-href");
    });

    /*  настройка google charts */
   /* google.charts.load("current", {packages:["corechart"]});

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
    }*/

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
