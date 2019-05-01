<!DOCTYPE html>
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
        require_once('classes.php');
        $db=new Database;
        $db->setDbSettings("localhost", "root", "", "course_database");
        $db->open_connection();
    ?>
    <div class="header">
        <div class="logo"></div>
        <div class="login-info">
            <a href="" class="registration"><i class="fas fa-edit"><span class="registration-text">Регистрация</span></i></a>
            <span class="or">или</span>
            <a href="" class="enter"><i class="fas fa-lock"><span class="enter-text">Вход</span></i></a>
        </div>
        <div class="enter-invisible">
                <div class="triangle-enter"></div>
                <h3 class="enter-header">Вход <i class="fas fa-times"></i></h3>
                <div class="enter-main">
                    <div class="login-password">
                        <input type="text" name="login" placeholder="Логин">
                        <input type="password" name="password" placeholder="Пароль">
                    </div>
                    <div class="remember-forgot">
                        <label><input type="checkbox" name="remember"><span>Запомнить меня</span></label>
                        <a href="" class="forgot">Забыли пароль?</a>
                    </div>
                    <input type="button" value="Войти">
                </div>
            </div>
            <div class="registration-invisible">
            <div class="triangle-registration"></div>
            <h3 class="registration-header">Регистрация <i class="fas fa-times"></i></h3>
            <div class="registration-main">
                <div class="login-password">
                    <input type="text" name="login" placeholder="Логин" size="40">
                    <input type="password" name="password" placeholder="Пароль" size="40">
                </div>
                <input type="button" value="Зарегистрироваться">
            </div>
        </div>  
    </div>
    <div class="nav-wrapper">
        <nav class="menu">
            <ul>
                <li><a href="#"><i class="fas fa-home"></i>Главная</a></li>
                <li><a href="matches.php"><i class="fas fa-gamepad"></i>Матчи</a></li>
                <li><a href=""><i class="fas fa-users"></i>Команды</a></li>
                <li><a href="tournament.php"><i class="fas fa-trophy"></i>Турниры</a></li>
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
        <div class="administration-panel-block">
            <button type="button" name="add-tournament" class="add-tournament"><i class="fas fa-plus-circle">Добавить турнир</i></button>
            <button type="bytton" name="delete-tournament" class="delete-tournament "><i class="fas fa-minus-circle">Удалить турнир</i></button>
            <div class="administration-panel-wrapper">
                <form action="" class="administration-panel" method="post">
                    <h3 class="administration-panel-title">Создание турнира</h3>
                    <ul class="admin-form">
                        <li>
                            <label for="name-tournament" class="name-tournament">Наименование турнира</label>
                            <input type="text" id="name-tournament">
                        </li>
                        <li>
                            <label for="logo-tournament" class="logo-tournament">Логотип турнира</label>
                            <label class="file-label" for="logo-tournament">
                                <i class="fas fa-file-upload"><span>Добавить изображение</span></i>
                            </label>
                            <input type="file" id="logo-tournament" accept="image/*">
                        </li>
                        <li>
                            <label for="tournament-date-begin">Дата начала</label>
                            <input type="date" id="tournament-date-begin">
                        </li>
                        <li>
                            <label for="tournament-date-end">Дата завершения</label>
                            <input type="date" id="tournament-date-end">
                        </li>
                        <li>
                            <label for="tournament-prize">Сумма призовых ($)</label>
                            <div class="numeric-field">
                                <i class="fas fa-minus-circle"></i>
                                <input type="number" min="0" id="tournament-prize">
                                <i class="fas fa-plus-circle"></i>
                            </div>
                        </li>
                        <li>
                            <button type="reset">Очистить поля</button>
                            <button id="preview">Предварительный просмотр</button>
                            <button type="submit" id="create-tournament">Добавить турнир</button>
                        </li>
                    </ul>
                </form>
                <div class="preview-window-wrapper">
                    <h3 class="preview-window-title"><i class="fas fa-eye"></i>Предварительный просмотр</h3>
                    <div class="tournament-block">
                        <div class="tournament-title-img">
                            <img src="" class="tournament-img">
                            <span class="tournament-name"></span>
                        </div>
                        <div class="date-prize">
                            <span class="date"></span>
                            <span class="prize"></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="matches-transfer-wrapper">
            <div class="matches-block">
                <h3 class="matches-header"><i class="fas fa-gamepad"></i>Матчи</h3>
                <div class="match-wrapper">
                    <div class="match-href">
                        <div class="translation-wrapper">
                            <i class="fas fa-video"></i>
                        </div>
                        <div class="teams-wrapper">
                            <span class="first-team">TBD</span>
                            <span class="country-flag"></span>
                            <i class="vs">vs</i>
                            <span class="second-team">TBD</span>
                            <span class="country-flag"></span>
                        </div>
                        <div class="tournament-match-wrapper">
                            <span class="date">дд.мм.гггг</span>
                            <span class="time">чч:мм</span>
                            <a class="tournament-href" href="">
                                <img src="./images/img/pic-20190311-1000x500-3096092874.jpeg" alt="" class="tournament-image">
                            </a>
                        </div>
                    </div>
                </div>                
            </div>
            <div class="transfer-block">
                <h3 class="transfer-header"><i class="fas fa-exchange-alt"></i>Трансферы</h3>
                <a href="" class="transfer-href">
                    <div class="player-block">
                        <img src="./images/playerPhotos/9pasha.png" alt="" class="player-photo">
                    </div>
                    <div class="discipline-name">
                        <span class="name">TBD</span>
                        <span class="discipline">Dota-2</span>
                    </div>
                    <div class="transfer">
                            <span class="team-from">TBD</span>
                            <i class="fas fa-angle-double-right"></i>
                            <span class="team-to">TBD</span>
                    </div>
                    <div class="date-wrapper">
                        <span class="date">xx.xx</span>
                    </div>
                </a>
            </div>
        </div>
       <div class="tournament-facts-wrapper">
            <div class="tournament-index-wrapper">
                <h3 class="tournament-header"><i class="fas fa-trophy"></i>Турниры</h3>
                <?php
                    $query="select idTournament, event, tournamentLogo, DATE_FORMAT(dateBegin, '%e'), DATE_FORMAT(dateBegin, '%c'), DATE_FORMAT(dateBegin, '%Y'), prize 
                    from tournaments limit 10";
                    $db->setQuery($query);
                    $db->show_tournaments();
                ?>
            </div>
            <div class="facts">
                <h3 class="tournament-header"><i class="fas fa-star"></i>Интересные факты</h3>
                <div class="fact-wrapper">
                    <h3 class="fact-title">Команда ботов OPENAI победила в 99,4% матчей</h3>
                    С 18 по 21 апреля любой желающий мог собрать команду и сразиться с OPENAI FIVE. Из 7257 матчей команды людей смогли выиграть только 42.
                    Наибольший успех показала команда из СНГ под руководством Александра "AINODEHKA" Колясева, она выиграла 10 матчей. 
                </div> 
            </div>
       </div>
   </div>
   <div class="footer">
       &copy; 2019 gginfo - все для любителей киберспорта.
   </div>
   <script src="./OwlCarousel2-2.3.4/docs/assets/owlcarousel/owl.carousel.min.js"></script>
   <!--<iframe width="560" height="315" src="https://www.youtube.com/embed/hacY_WnG8QU" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>--->
</body>
</html>