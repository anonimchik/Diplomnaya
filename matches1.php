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
            <a href="" class="enter"><i class="fas fa-lock"><span class="enter-text">Вход</span></i></a>
        </div>
        <div class="enter-invisible">
                <div class="triangle-enter"></div>
                <h3 class="enter-header">Вход <i class="fas fa-times"></i></h3>
                <div class="enter-main">
                    <div class="login-password">
                        <input type="text" name="login" placeholder="Логин" size="40">
                        <input type="password" name="password" placeholder="Пароль" size="40">
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
                <li><a href="index1.php"><i class="fas fa-home"></i>Главная</a></li>
                <li><a href="matches1.php"><i class="fas fa-gamepad"></i>Матчи</a></li>
                <li><a href="teams1.php"><i class="fas fa-users"></i>Команды</a></li>
                <li><a href="players1.php"><i class="fas fa-user"></i>Игроки</a></li>
                <li><a href="tournaments1.php"><i class="fas fa-trophy"></i></i>Турниры</a></li>
            </ul>
        </nav>
    </div>
    <div class="tournament-bg-wrapper">
        <?php 
            $db->getMatchName($_GET['idmatch']);
        ?>
        <div class="tournament-bg"></div>
    </div>
    <div class="administration-panel-block">
        <button type="button" name="add-match" class="add-record"><i class="fas fa-plus-circle">Добавить турнир</i></button>
        <button type="bytton" name="delete-match" class="delete-record"><i class="fas fa-minus-circle">Удалить турнир</i></button>
        <button class="hide-administration-panel"><i class="far fa-eye">Показать панель администратора</i></button>
        <div class="administration-panel-wrapper">
            <form action="" class="administration-panel" method="post">
                <h3 class="administration-panel-title">Создание матча</h3>
                <ul class="admin-form">
                    <li>
                        <label for="tournament" class="name-tournament">Наименование турнира</label>
                        <select id="tournament">
                            <option selected>Выберите турнир</option>
                            <?php
                                $query="SELECT idTournament, event FROM tournaments ORDER BY event";
                                $db->getOptionsForSelect($query, "idTournament", "event");
                            ?>
                        </select>
                    </li>
                    <li>
                        <label for="first-team">Первая команда</label>
                        <select id="first-team">
                            <option selected>Выберите команду</option>
                            <?php
                                $query="SELECT idTeam, name FROM teams ORDER BY name";
                                $db->getOptionsForSelect($query, "idTeam", "name");
                            ?>
                        </select>
                    </li>
                    <li>
                        <label for="second-team">Вторая команда</label>
                        <select id="second-team">
                            <option selected>Выберите команду</option>
                            <?php
                                $query="SELECT idTeam, name FROM teams ORDER BY name";
                                $db->getOptionsForSelect($query, "idTeam", "name");
                            ?>
                        </select>
                    </li>
                    <li>
                        <label for="datetime">Время встречи</label>
                        <div>
                            <input id="date" type="date">
                            <input id="time" type="time">
                        </div>
                    </li>
                    <li>
                        <button type="reset">Очистить поля</button>
                        <button type="submit" id="create-match">Добавить турнир</button>
                    </li>
                </ul>
            </form>
        </div>
    </div>
    <div class="main-content">
        <!--<div class="maps-block-wrapepr">
            <ul class="maps-tab">
                <li class="map-link current" data-tab="tab-1"><a href="">Прошедшие</a></li>
                <li class="map-link" data-tab="tab-2"><a href="">Текущие</a></li>
                <li class="map-link" data-tab="tab-3"><a href="">Будущие</a></li>
            </ul>
            <div id="tab-1" class="tab-content current">1</div>
            <div id="tab-2" class="tab-content">2</div>
            <div id="tab-3" class="tab-content">3</div>
        </div>-->
        <?php
            $db->getMatchPage($_GET['idmatch']);
        ?>
    </div>
    <!---<div class="chart_wrap">
        <div id="donutchart" style="width: 100%; height: 250px;"></div>
    </div>-->
    <div class="footer">
       &copy; 2019 gginfo - все для любителей киберспорта.
    </div>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
</body>
</html>