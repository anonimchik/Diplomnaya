<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Турниры</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" media="screen" href="styles/main.css">
    <link rel="stylesheet" href="fontawesome-free-5.8.1-web/css/all.css">
    <link rel="stylesheet" href="OwlCarousel2-2.3.4/docs/assets/owlcarousel/assets/owl.carousel.min.css">
    <link rel="stylesheet" href="OwlCarousel2-2.3.4/docs/assets/owlcarousel/assets/owl.theme.default.min.css">
    <script language="javascript" rel="javascript" type="text/javascript" src="jquery-3.3.1.min.js"></script>
    <script language="javascript" rel="javascript" type="text/javascript" src="jquery-cookie/jquery.cookie.js"></script>
    <script src="js/main.js"></script>
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
            <span class="user-login">asdasd</span>
            <i class="fas fa-sign-out-alt"></i>
        </div>
    </div>
    <div class="nav-wrapper">
        <nav class="menu">
            <ul>
                <li><a href="index.php"><i class="fas fa-home"></i>Главная</a></li>
                <li><a href="matches1.php"><i class="fas fa-gamepad"></i>Матчи</a></li>
                <li><a href="teams1.php"><i class="fas fa-users"></i>Команды</a></li>
                <li><a href="players1.php"><i class="fas fa-user"></i>Игроки</a></li>
                <li><a href="tournaments1.php"><i class="fas fa-trophy"></i></i>Турниры</a></li>
            </ul>
        </nav>
    </div>
    <div class="tournament-bg-wrapper">
        <?php 
            $db->getTournamentName($_GET['idtour']);
        ?>
        <div class="tournament-bg"></div>
    </div>
    <div class="mini-admin-panel">
        <button id="add-record"><i class="fas fa-plus"></i>Создать турнир</button>
        <button id="delete-record"><i class="fas fa-minus"></i>Удалить турнир</button>
        <i class="fas fa-angle-double-left"></i>
    </div>
    <div class="arrow">
        <i class="fas fa-angle-double-right"></i>
    </div>
    <div class="administration-panel-index-block">
        <div class="administration-panel-wrapper">
            <form id="admin-form" class="administration-panel" method="post">
                <h3 class="administration-panel-title">Создание турнира</h3>
                <ul class="admin-form">
                    <li>
                        <label for="name-tournament" class="name-tournament">Наименование турнира</label>
                        <input type="text" id="name-tournament" required autocomplete="off">
                    </li>
                    <li>
                        <label for="logo-tournament" class="logo-tournament">Логотип турнира</label>
                        <label class="file-label" for="logo-tournament">
                            <i class="fas fa-file-upload"><span>Добавить изображение</span></i>
                        </label>
                        <input type="file" id="logo-tournament" required accept="image/*">
                    </li>
                    <li>
                        <label for="tournament-date-begin">Дата начала</label>
                        <input type="date" required id="tournament-date-begin">
                    </li>
                    <li>
                        <label for="tournament-date-end">Дата завершения</label>
                        <input type="date" required id="tournament-date-end">
                    </li>
                    <li>
                        <label for="tournament-prize">Сумма призовых ($)</label>
                        <div class="numeric-field">
                            <i class="fas fa-minus-circle"></i>
                            <input type="number" required min="0" id="tournament-prize">
                            <i class="fas fa-plus-circle"></i>
                        </div>
                    </li>
                    <li>
                        <button type="reset">Очистить поля</button>
                        <button type="submit" id="create-tournament">Добавить турнир</button>
                    </li>
                </ul>
            </form>
        </div>
    </div>
    <div class="main-content">
        <?php
            $db->getTournamentPage($_GET['idtour']);
        ?>
    </div>
    <div class="footer">
       &copy; 2019 ggInfo - все для любителей киберспорта.
    </div>
</body>
</html>