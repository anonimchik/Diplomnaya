﻿<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Page Title</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" media="screen" href="styles/main.css">
    <link rel="stylesheet" href="fontawesome-free-5.8.1-web/css/all.css">
    <link rel="stylesheet" href="./OwlCarousel2-2.3.4/docs/assets/owlcarousel/assets/owl.carousel.min.css">
    <link rel="stylesheet" href="./OwlCarousel2-2.3.4/docs/assets/owlcarousel/assets/owl.theme.default.min.css">
    <script language="javascript" rel="javascript" type="text/javascript" src="jquery-3.3.1.min.js"></script>
    <script src="./js/main.js"></script>
</head>
<body>
    <?php 
        include_once('classes.php');
        $db=new Database;
        $db->setDbSettings("localhost", "root", "", "course_database");
        $db->open_connection();
    ?>
    <div class="header">
        <div class="logo"></div>
        <div class="login-info">
            <a href="" class="register">
                <i class="fas fa-user-edit"><span class="register-text">Регистрация</span></i>
            </a>
            <span class="or-text">или</span>
            <a href="" class="enter">
                <i class="fas fa-lock"><span class="enter-text">Вход</span></i>
            </a>
        </div>
    </div>
    <div class="nav-wrapper">
        <nav class="menu">
            <ul>
                <li><a href=""><i class="fas fa-home"></i>Главная</a></li>
                <li><a href=""><i class="fas fa-gamepad"></i>Матчи</a></li>
                <li><a href=""><i class="fas fa-users"></i>Команды</a></li>
                <li><a href=""><i class="fas fa-trophy"></i>Турниры</a></li>
                <li><a href=""><i class="fas fa-film"></i>Видео</a></li>
            </ul>
        </nav>
    </div>
    <div class="video-block">
        <div class="top-layer"></div> 
        <video id="video" src="./EPICENTER XL- Интро [RU].mp4" type="video/mp4" width="100%" loop muted autoplay></video>
    </div>
    
   <div class="main-content">
       <h3 class="news-header"><i class="fas fa-newspaper"></i>Последние новости</h3>
       <div class="owl-carousel">
            <div>
                <a class="news-block" href="">
                    <div class="news-title"><span class="title-text">Тут какой-то заголовок к новости</span></div>
                    <img class="news-image" src="./images/img/dota2.jpg" alt="">    
                </a>
            </div>
            <div>
                <a class="news-block" href="">
                    <div class="news-title"></div>
                    <img class="news-image" src="./images/img/cs_go.jpg" alt="">    
                </a>
            </div>
            <div>
                <a class="news-block" href="">
                    <div class="news-title"></div>
                    <img class="news-image" src="./images/img/cs_go.jpg" alt="">    
                </a>
            </div>
            <div>
                <a class="news-block" href="">
                    <div class="news-title"><span class="title-text">Тут какой-то заголовок к новости</span></div>
                    <img class="news-image" src="./images/img/dota2.jpg" alt="">    
                </a>
            </div>
       </div>
       <h3 class="tournament-header"><i class="fas fa-gamepad"></i>Турниры</h3>
       <div class="tournament-wrapper">
            <div class="tournament-block">
                <span class="tournament-status"><i class="fas fa-clock"></i>Ожидается</span>
                <a class="tournament-href" href="">
                <?php
                    $db->setQuery("select * from tournaments");
                    $db->show_tournaments();
                ?>
                </a>
            </div>
            <div class="tournament-block">
                asd
            </div>
       </div>
       <div class="matches-wrapper">
           <h3 class="matches-header"><i class="fas fa-gamepad"></i>Матчи</h3>
            <div class="matches-block">
            <ul class="tabs">
                <li class="tab-link current" data-tab="tab-1"><a href="">Tab 1</a></li>
                <li class="tab-link" data-tab="tab-2"><a href="">tab 2</a></li>
                <li class="tab-link" data-tab="tab-3"><a href="">tab 3</a></li>
                <li class="tab-link" data-tab="tab-4"><a href="">tab 4</a></li>
            </ul>
            <div id="tab-1" class="tab-content current">
                Содержимое первого tab'a
            </div>
            <div id="tab-2" class="tab-content">
                содержимое второго tab'a
            </div>
            <div id="tab-3" class="tab-content">
                содержимое третьего tab'a
            </div>
            </div>
        </div>
   </div>
   <script src="./OwlCarousel2-2.3.4/docs/assets/owlcarousel/owl.carousel.min.js"></script>
</body>
</html>