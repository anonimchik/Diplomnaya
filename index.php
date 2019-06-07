<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>ggInfo - Главная страница</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" media="screen" href="styles/main.css">
    <link rel="stylesheet" href="fontawesome-free-5.8.1-web/css/all.css">
    <link rel="stylesheet" href="./OwlCarousel2-2.3.4/docs/assets/owlcarousel/assets/owl.carousel.min.css">
    <link rel="stylesheet" href="./OwlCarousel2-2.3.4/docs/assets/owlcarousel/assets/owl.theme.default.min.css">
    <script language="javascript" rel="javascript" type="text/javascript" src="jquery-3.3.1.min.js"></script>
    <script language="javascript" rel="javascript" type="text/javascript" src="jquery-cookie/jquery.cookie.js"></script>
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
        <div class="logo">
            <img src="./images/img/logo.png">
        </div>
        <div class="login-info">
            <a href="" class="registration"><i class="fas fa-edit"><span class="registration-text">Регистрация</span></i></a>
            <span class="or">или</span>
            <a href="" class="enter"><i class="fas fa-lock"><span class="enter-text">Вход</span></i></a>
        </div>
        <div class="enter-invisible">
            <div class="triangle-enter"></div>
            <h3 class="enter-header">Вход <i class="fas fa-times"></i></h3>
            <div class="enter-main">
                <form id="entrance-form">
                    <div class="login-password">
                        <input type="text" name="login" placeholder="Логин" required>
                        <input type="password" name="password" placeholder="Пароль" required>
                    </div>
                    <div class="remember-forgot">
                        <label><input type="checkbox" name="remember"><span>Запомнить меня</span></label>
                        <a href="" class="forgot">Забыли пароль?</a>
                    </div>
                    <input type="submit" value="Войти">
                </form>
            </div>
        </div>
        <div class="registration-invisible">
            <div class="triangle-registration"></div>
            <h3 class="registration-header">Регистрация <i class="fas fa-times"></i></h3>
            <div class="registration-main">
                <form id="registration-form">
                    <div class="login-password">
                        <input type="text" name="login" placeholder="Логин" size="40" required> 
                        <input type="password" name="password" placeholder="Пароль" size="40" required>
                    </div>
                    <input type="submit" value="Зарегистрироваться">
                </form>
            </div>
        </div> 
        <div class="invisible-user">
            <i class="fas fa-user-circle"></i>
            <span class="user-login">asd</span>
            <i class="fas fa-sign-out-alt"></i>
        </div>
    </div>
    <div class="nav-wrapper">
        <nav class="menu">
            <ul>
                <li><a href="#"><i class="fas fa-home"></i>Главная</a></li>
                <li><a href="matches1.php"><i class="fas fa-gamepad"></i>Матчи</a></li>
                <li><a href="teams1.php"><i class="fas fa-users"></i>Команды</a></li>
                <li><a href="players1.php"><i class="fas fa-user"></i>Игроки</a></li>
                <li><a href="tournaments1.php"><i class="fas fa-trophy"></i></i>Турниры</a></li>
            </ul>
        </nav>
    </div>
    <div class="video-block">
        <img src="./images/img/bg.png">
        <div class="top-layer"></div> 
        <video id="video" src="./EPICENTER XL- Интро [RU].mp4" type="video/mp4" width="100%" loop muted autoplay></video>
    </div>
    
   <div class="main-content">
        <div class="mini-admin-panel">
            <button id="add-record"><i class="fas fa-plus"></i>Создать турнир</button>
            <button id="delete-record"><i class="fas fa-minus"></i>Удалить турнир</button>
            <i class="fas fa-angle-double-left"></i>
        </div>
        <div class="arrow">
            <i class="fas fa-angle-double-right"></i>
        </div>
        <div class="matches-transfer-wrapper">
            <div class="matches-block">
                <h3 class="matches-header"><i class="fas fa-gamepad"></i>Матчи</h3>
                <?php
                    $db->getMatchesForMainPage();
                ?>           
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