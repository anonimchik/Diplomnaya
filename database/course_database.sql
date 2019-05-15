-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3006
-- Время создания: Май 15 2019 г., 10:15
-- Версия сервера: 5.6.38
-- Версия PHP: 5.5.38

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `course_database`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`%` PROCEDURE `checkPlayer` (IN `nick` VARCHAR(50))  NO SQL
IF nick in(SELECT players.nickname from players) THEN 
	SIGNAL SQLSTATE '50000'
	SET MESSAGE_TEXT='Такой игрок существует';
END IF$$

CREATE DEFINER=`root`@`%` PROCEDURE `checkTeam` (IN `team` VARCHAR(45))  NO SQL
IF team in(SELECT name from teams) THEN 
	SIGNAL SQLSTATE '50000'
	SET MESSAGE_TEXT='Такая команда существует';
END IF$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `autorization`
--

CREATE TABLE `autorization` (
  `user_id` int(11) NOT NULL,
  `login` varchar(255) NOT NULL COMMENT 'логин',
  `password` varchar(255) NOT NULL COMMENT 'пароль'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='логин и пароль';

--
-- Триггеры `autorization`
--
DELIMITER $$
CREATE TRIGGER `check login` BEFORE INSERT ON `autorization` FOR EACH ROW IF new.login in (SELECT login from autorization)
THEN SIGNAL SQLSTATE '50000'
SET MESSAGE_TEXT="Такой логин уже существует";
end if
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `brackets`
--

CREATE TABLE `brackets` (
  `idBracket` int(11) NOT NULL,
  `bracket` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `brackets`
--

INSERT INTO `brackets` (`idBracket`, `bracket`) VALUES
(1, 'Lower Bracket'),
(2, 'Upper Bracket');

-- --------------------------------------------------------

--
-- Структура таблицы `disciplines`
--

CREATE TABLE `disciplines` (
  `idDiscipline` int(11) NOT NULL COMMENT 'id дисциплины',
  `discipline` varchar(50) NOT NULL COMMENT 'дисциплина'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `disciplines`
--

INSERT INTO `disciplines` (`idDiscipline`, `discipline`) VALUES
(1, 'Dota 2');

-- --------------------------------------------------------

--
-- Структура таблицы `grouptable`
--

CREATE TABLE `grouptable` (
  `idTournament` int(11) NOT NULL COMMENT 'id турнира',
  `idTeam` int(11) NOT NULL COMMENT 'id команды',
  `group` char(1) NOT NULL,
  `totalCountMatches` int(11) NOT NULL COMMENT 'общее количество матчей',
  `countWomMatches` int(11) NOT NULL COMMENT 'количество выигранных матчей',
  `countLoseMatches` int(11) NOT NULL COMMENT 'количество проигранных матчей',
  `score` int(11) NOT NULL COMMENT 'кол-во очков'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `matchdescription`
--

CREATE TABLE `matchdescription` (
  `idMatch` int(11) NOT NULL COMMENT 'id матча',
  `idFormat` int(11) NOT NULL COMMENT 'id формата',
  `firstWinner` int(11) DEFAULT NULL COMMENT 'победитель 1-ой карты',
  `secondWinner` int(11) DEFAULT NULL COMMENT 'победитель 2-ой карты',
  `thirdWinner` int(11) DEFAULT NULL COMMENT 'победитель 3-ей карты',
  `fourthWinner` int(11) DEFAULT NULL COMMENT 'победитель 4-ой карты',
  `fifthWinner` int(11) DEFAULT NULL COMMENT 'победитель 5-ой карты',
  `finalScore` varchar(10) NOT NULL COMMENT 'итоговый счет',
  `firstMapPhoto` varchar(45) DEFAULT NULL,
  `secondMapPhoto` varchar(45) DEFAULT NULL,
  `thirdMapPhoto` varchar(45) DEFAULT NULL,
  `fourthMapPhoto` varchar(45) DEFAULT NULL,
  `fifthMapPhoto` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `matches`
--

CREATE TABLE `matches` (
  `idMatch` int(11) NOT NULL COMMENT 'id матча',
  `idTournament` int(11) NOT NULL COMMENT 'id турнира',
  `idFirstTeam` int(11) NOT NULL COMMENT 'id первой команды',
  `idSecondTeam` int(11) NOT NULL COMMENT 'id второй команды',
  `idMatchFormat` int(11) NOT NULL COMMENT 'id формата',
  `date` datetime NOT NULL COMMENT 'дата проведения матча',
  `round` varchar(50) NOT NULL,
  `status` int(11) NOT NULL COMMENT 'статус матча'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `matchformats`
--

CREATE TABLE `matchformats` (
  `idMatchFormat` int(11) NOT NULL COMMENT 'id формата',
  `matchFormat` varchar(50) NOT NULL COMMENT 'формат'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `matchformats`
--

INSERT INTO `matchformats` (`idMatchFormat`, `matchFormat`) VALUES
(1, 'Best of 1'),
(2, 'Best of 2'),
(3, 'Best of 3'),
(4, 'Best of 5');

-- --------------------------------------------------------

--
-- Структура таблицы `players`
--

CREATE TABLE `players` (
  `idPlayer` int(11) NOT NULL COMMENT 'id игрока',
  `idTeam` int(11) NOT NULL COMMENT 'id команды',
  `idDiscipline` int(11) NOT NULL COMMENT 'id дисциплины',
  `country` varchar(45) NOT NULL COMMENT 'страна',
  `countryFlag` varchar(200) NOT NULL COMMENT 'флаг страны',
  `name` varchar(100) NOT NULL COMMENT 'имя',
  `nickname` varchar(50) NOT NULL COMMENT 'никнейм',
  `description` text NOT NULL COMMENT 'описание',
  `birthday` date NOT NULL COMMENT 'дата рождения',
  `photoRef` varchar(250) DEFAULT NULL COMMENT 'фото',
  `idRole` varchar(3) NOT NULL COMMENT 'id роли',
  `line` varchar(20) NOT NULL COMMENT 'линия',
  `prize` int(11) NOT NULL COMMENT 'сумма призовых'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `players`
--

INSERT INTO `players` (`idPlayer`, `idTeam`, `idDiscipline`, `country`, `countryFlag`, `name`, `nickname`, `description`, `birthday`, `photoRef`, `idRole`, `line`, `prize`) VALUES
(2, 90, 1, 'Австралия', 'images/countryFlags/Австралия.png', 'Nick Capeski', 'Splicko', '', '0000-00-00', 'images/playerPhotos/Splicko.png', '2', 'Mid', 2371),
(3, 90, 1, 'Австралия', 'images/countryFlags/Австралия.png', 'James Lee', 'XemistrY', '', '0000-00-00', 'images/playerPhotos/XemistrY.png', '2', 'Mid', 4211),
(4, 90, 1, 'Австралия', 'images/countryFlags/Австралия.png', 'Tuan Nguyen', 'TEKCOR', '', '0000-00-00', 'images/playerPhotos/TEKCOR.png', '3', 'Hard', 2157),
(5, 92, 1, 'Австралия', 'images/countryFlags/Австралия.png', '&ndash;', 'Reverie', '', '0000-00-00', 'images/playerPhotos/Reverie.png', '2', 'Mid', 219),
(6, 92, 1, 'Австралия', 'images/countryFlags/Австралия.png', 'Justin Yuen', 'xMusiCa', '', '0000-00-00', 'images/playerPhotos/xMusiCa.png', '3', 'Hard', 8111),
(88, 119, 1, 'Перу', 'images/countryFlags/Перу.png', 'Juan Ochoa', 'Atun', '', '0000-00-00', 'images/playerPhotos/Atun.png', '1', 'Safe', 16090),
(89, 119, 1, 'Перу', 'images/countryFlags/Перу.png', 'Jeremy Aguinaga', 'Jeimari', '', '0000-00-00', 'images/playerPhotos/Jeimari.png', '2', 'Mid', 6400),
(91, 88, 1, 'Мексика', 'images/countryFlags/Мексика.png', 'Jose Coronel', 'esk', '', '0000-00-00', 'images/playerPhotos/esk.png', '2', 'Mid', 130),
(92, 88, 1, 'Мексика', 'images/countryFlags/Мексика.png', 'Alejandro Moreno', 'Jano', '', '0000-00-00', 'images/playerPhotos/Jano.png', '3', 'Hard', 130),
(93, 120, 1, 'США', 'images/countryFlags/США.png', '&ndash;', 'AlienManaBanana', '', '0000-00-00', 'images/playerPhotos/AlienManaBanana.png', '2', 'Mid', 100),
(94, 115, 1, 'США', 'images/countryFlags/США.png', 'Chris Usher', 'USH', '', '0000-00-00', 'images/playerPhotos/USH.png', '2', 'Mid', 6187),
(95, 115, 1, 'Перу', 'images/countryFlags/Перу.png', 'Jose Andree Nicosia', 'Sword', '', '0000-00-00', 'images/playerPhotos/Sword.png', '3', 'Hard', 6912),
(116, 79, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', '&ndash;', 'Masaros', '', '0000-00-00', 'images/playerPhotos/Masaros.png', '3', 'Hard', 116),
(118, 151, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Fernando Mendoza', 'Nando', '', '0000-00-00', 'images/playerPhotos/Nando.png', '1', 'Safe', 44076),
(119, 151, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', '&ndash;', 'Pio', '', '0000-00-00', 'images/playerPhotos/Pio.png', '2', 'Mid', 1775),
(120, 151, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', '&ndash;', 'Van', '', '0000-00-00', 'images/playerPhotos/Van.png', '3', 'Hard', 2175),
(145, 139, 1, 'Китай', 'images/countryFlags/Китай.png', '&ndash;', 'Bib', '', '0000-00-00', 'images/playerPhotos/Bib.png', '2', 'Mid', 172),
(147, 97, 1, 'Китай', 'images/countryFlags/Китай.png', 'Mo Jian', 'Veng', '', '0000-00-00', 'images/playerPhotos/Veng.png', '1', 'Safe', 301),
(162, 150, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', '&ndash;', 'Palos', '', '0000-00-00', 'images/playerPhotos/Palos.png', '1', 'Safe', 387),
(163, 150, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Jonas Samonte', 'Nasjo', '', '0000-00-00', 'images/playerPhotos/Nasjo.png', '2', 'Mid', 1087),
(164, 150, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', '&ndash;', 'MOki', '', '0000-00-00', 'images/playerPhotos/MOki.png', '3', 'Hard', 387),
(189, 76, 1, 'Сингапур', 'images/countryFlags/Сингапур.png', 'Leow Chen Kai', 'FiXeRs', '', '0000-00-00', 'images/playerPhotos/FiXeRs.png', '2', 'Mid', 400),
(190, 76, 1, 'Сингапур', 'images/countryFlags/Сингапур.png', 'Yaowen Teo', 'Tudi', '', '0000-00-00', 'images/playerPhotos/Tudi.png', '3', 'Hard', 7201),
(193, 77, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Lee Jia He', 'Chidori~', '', '0000-00-00', 'images/playerPhotos/Chidori~.png', '1', 'Safe', 510),
(194, 78, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', '&ndash;', 'Earnzamax', '', '0000-00-00', 'images/playerPhotos/Earnzamax.png', '2', 'Mid', 116),
(201, 82, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', 'Patipat Nussayateerasarn', 'Peter', '', '0000-00-00', 'images/playerPhotos/Peter.png', '1', 'Safe', 542),
(202, 82, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', 'Posathorn Kasemsawat', 'SoLotic', '', '0000-00-00', 'images/playerPhotos/SoLotic.png', '3', 'Hard', 3327),
(204, 83, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', '&ndash;', 'mn', '', '0000-00-00', 'images/playerPhotos/mn.png', '2', 'Mid', 348),
(256, 1, 1, 'Польша', '/images/countryFlags/Польша.png', 'Михал Янковски', 'Nisha', 'Профессиональный игрок в Dota 2.\r\n\r\nНа про-сцене с 2014 года. Большую часть своей карьеры выступал за польскую команду Let\'s Do It. Коллектив отличался стабильным составом, но очень нестабильной игрой. В 2016 году полякам удалось выиграть несколько ProDotA Cup в Европе. Микс трижды подписывал контракты с организациями, но ни на одном крупном турнире команда не смогла показать хорошего результата. Под тегом Team Kinguin поляки приняли участие в квалификациях на TI8 и потерпели поражение. После этого организация расторгла контракты с игроками, но и сам состав не пережил полосы длительных неудач и распался. В сентябре 2018 года Nisha получил приглашение от Puppey и присоединился к Team Secret.\r\n\r\nЗа свою карьеру Nisha играл на разных ролях - от саппорта до core-позиций. Со временем Мид-линия стала для него основной, но в Team Secret Михалу была доверена роль керри.', '2000-09-28', '/images/playerPhotos/Nisha.png', '1', 'Easy', 253449),
(257, 1, 1, 'Малайзия', '/images/countryFlags/Малайзия.png', 'MidOne', 'Чжэн Йек Най', 'Профессиональный игрок из Малайзии. \r\n\r\nДостиг 7 700 MMR в Dota 2 ещё до вступления в ряды Fnatic. Предпочитает играть в центре и выполняет роль мидлейнера. Успел поиграть в таких командах, как aG.Psk, PsK, IMBS-PsK и Dot.CyberCafe. Был стендином в командах Panglima и Mineski. В декабре 2015 года встал на защиту мид-линии команды Fnatic. \r\n\r\nНа Ti6 добрался до 4-го места, но после турнира покинул коллектив и неожиданно оказался в Team Secret.', '1996-06-03', '/images/playerPhotos/MidOne.png', '2', 'Mid', 487350),
(258, 1, 1, 'Швеция', '/images/countryFlags/Швеция.png', 'Людвиг Уолберг', 'zai', 'Профессиональный игрок в Dota 2 из Швеции.\r\n\r\nУспел поиграть в Heroes of Newerth, где добился высоких результатов, после чего перешел на Dota 2. Произошло это в 2013 году. Некоторое время он выступал за американский микс Stay Free, а в ноябре принял участие в Star Ladder Star Series Season 8 с командой Super Strong Dinosaurs. Команде не хватило буквально одной победы, чтобы претендовать на выход в плейофф. Но микс начал разваливаться уже по ходу сезона. Тогда zai играл на саппорт-героях в паре с ppd, и они показывали достаточно хорошую игру, чтобы их заметил Fear и пригласил в свой микс S A D B O Y S. В феврале 2014 года EG подписали этот состав и довольно быстро стали претендовать на место в топе.\r\n\r\nУже тогда пара zai-ppd считалась одной из самых сильных саппорт-связок на профессиональной сцене. EG победила на The Summit 1, а на TI4 добрались до \"бронзы\". К концу года команда стала буксовать. Перемены коснулись zai, лучшая пара саппортов оказалась разорвана - ppd остался с EG, а Людвиг перешёл в Team Secret. Некоторое время потребовалось чтобы понять, на какой роли будет играть молодой игрок, но zai остановился на героях сложной линии. В Team Secret zai окончательно реализовался как оффлейнер, встав в один ряд с сильнейшими игроками этой позиции. Победив на ряде Premium турниров Team Secret уверенно подошли к TI5, но на самом турнире игра команды расстроилась, и коллектив остановился на 7-8 месте.\r\n\r\nПосле этого Людвиг решил временно приостановить карьеру, сосредоточив усилия на учебе. Однако он числился запасным игроком в Evil Geniuses до тех пор, пока полноценно не вернулся на профессиональную сцену в мае 2016 года, войдя в состав Kaipi. Уже в июне провалившиеся на The Manila Major 2016 Evil Geniuses позвали zai обратно в основной состав. В августе 2017 год zai покинул команду. Вместе с ppd они основали микс The Dire, который в сентябре подписал контракты с OpTic Gaming.\r\n\r\nzai отличается редким трудолюбием. Он старается оттачивать исполнение на нужных героях до идеала.', '1997-08-05', '/images/playerPhotos/Zai.png', '3', 'Offlane', 1346189),
(259, 1, 1, 'Эстония', '/images/countryFlags/Эстония.png', 'Клемент Иванов', 'Puppey', 'Профессиональный игрок в Dota 2.Чемпион Мира 2011 года (в составе Natus Vincere).\r\n\r\nКлемент считается одним из сильнейших капитанов и аналитиков в Dota 2. Свою карьеру он начал в 2007 году неизвестным пабером в команде XsK, но в 2008 году заслужил уважение профессиональных игроков после 3 места на ESL Major Series. Дуэт с KuroKy в Kingsurf.int стал одним из самых знаковых в истории Доты. К 2011 Клемент был уже опытным игроком, от которого бы не отказалась любая команда. Однако повезло украинской организации Natus Vincere. Готовя свою команду к первому в истории The International, Na\'Vi переманили к себе сильнейших на тот момент игроков СНГ. 17 июня 2011 Puppey перешёл под флаги \"жёлто-чёрных\", а в августе Na\'Vi взяли первое место на TI1. После ухода из Na\'Vi ArtStyle капитанский слот переходит к Puppey. 2011-14 годы безусловно можно назвать \"эрой Puppey\" в команде. До 2012 у Natus Vincere просто не было соперника.\r\n\r\nВ феврале 2013 года Puppey приглашает в Na\'Vi своего старого товарища KuroKy. Количество титулов только на топовых турнирах превысило десятку — семикратные чемпионы StarLadder, двукратные вице-чемпионы The International, победители множества крупных онлайн-турниров. И хотя у команды не всегда всё шло гладко, именно несгибаемая воля капитана Puppey позволяла в нужный момент собраться и показать зрелищную и сильную Доту. В начале 2014 года \"магия\" стала улетучиваться. После победы на Star Ladder Star Series Season 8 команда так и не смогла выиграть ни одного Лана. В сторону Puppey усиливается критика, под сомнение ставится как желание Клемента играть в команде, так и драфт. На TI4 команда впервые не попадает в Гранд-финал и занимает 7-8 место. После этого Puppey и KuroKy покидают Na\'Vi и основывают звёздный микс Team Secret.\r\n\r\nНовая команда Puppey занимает лидирующие позиции в Европе и мире, однако взять турнир Premium класса им удалось только в мае 2015 года, после ряда замен в команде. Это была победа на The Summit 3. На TI5 Team Secret приехали фаворитами, но в команде на тот момент уже назревал конфликт. После первого же поражения в плей-оффе стало понятно, что Team Secret уязвимы, что и доказали Virtus.pro, сенсационно выбив команду Puppey с турнира и оставив им довольствоваться 7-8 местом. После TI5 Puppey полностью заменил состав. В этот раз он был не таким звёздным, но команда потеряла стабильность, побед стало меньше, а TI6 стал и вовсе провальным - 13-16 место.\r\n\r\nPuppey не только гениальный капитан, но и сильный игрок на лесных героях. Не раз его единоличные решения по игре и команде подвергались критике. Кроме того, Puppey известен своим скептическим отношением к киберспортивным организациям.', '1990-03-06', '/images/playerPhotos/Puppey.png', '4-5', 'Easy', 1061761),
(260, 1, 1, 'Иордания', '/images/countryFlags/Иордания.png', 'Язид Жарадат', 'YapzOr', 'Иорданский профессиональный игрок в Dota 2.\r\n\r\nКарьера YapzOr складывалась неровно и началась ещё во времена DotA Allstars.В 2011 году он выступал за команду WhyAre. Перейдя на Dota 2, он выступал за многие миксы, но эти коллективы разваливались слишком быстро и YapzOr так и не получил признания.\r\n\r\nНекоторую известность пришла после присоединения к Balkan Bears в конце 2014 года. Команде даже удалось съездить на свой единственный ивент в апреле 2015 года — joinDOTA MLG Pro League Season 1 и занять там 5-6 место. Скоро команда распалась и YapzOr снова вернулся к малоперспективным, но куда более известным миксам: Monkey Freedom Fighters, NO-VASELINE, Mamas Boys. В феврале 2016 года его призвал в ряды своей команды известный комментатор, в прошлом — про-игрок, syndereN, а в мае 2017 года Язид получил приглашение от Puppey и присоединился к Team Secret.', '1994-10-17', '/images/playerPhotos/YapZor.png', '4-5', 'Hard', 478393);

--
-- Триггеры `players`
--
DELIMITER $$
CREATE TRIGGER `checkFields` BEFORE INSERT ON `players` FOR EACH ROW IF new.idDiscipline='' or new.nickname='' THEN
	SIGNAL SQLSTATE '50000'
    set MESSAGE_TEXT='Заполните все поля';
END IF
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `playertransfers`
--

CREATE TABLE `playertransfers` (
  `idTransfer` int(11) NOT NULL COMMENT 'id трансфера',
  `idPlayer` int(11) NOT NULL COMMENT 'id игрока',
  `action` tinyint(1) NOT NULL COMMENT 'действие (присоединился - 1 / ушел -0)',
  `idTeam` int(11) NOT NULL COMMENT 'id команды',
  `date` date NOT NULL COMMENT 'дата трансфера'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `prognoz`
--

CREATE TABLE `prognoz` (
  `idUser` int(11) NOT NULL,
  `idTeam` int(11) NOT NULL,
  `idMatch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `regions`
--

CREATE TABLE `regions` (
  `idRegion` int(11) NOT NULL COMMENT 'id региона',
  `region` varchar(20) NOT NULL COMMENT 'регион'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `regions`
--

INSERT INTO `regions` (`idRegion`, `region`) VALUES
(1, 'North America'),
(2, 'South America'),
(3, 'Europe'),
(4, 'CIS'),
(5, 'China'),
(6, 'Southeast Asia');

-- --------------------------------------------------------

--
-- Структура таблицы `relatedtournaments`
--

CREATE TABLE `relatedtournaments` (
  `idTournament` int(11) NOT NULL,
  `idRelatedTournament` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `roles`
--

CREATE TABLE `roles` (
  `idRole` varchar(3) NOT NULL COMMENT 'id роли',
  `role` varchar(50) NOT NULL COMMENT 'роль',
  `idDiscipline` int(11) NOT NULL COMMENT 'id дисциплины'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `roles`
--

INSERT INTO `roles` (`idRole`, `role`, `idDiscipline`) VALUES
('1', 'Carry', 1),
('2', 'MId', 1),
('3', 'Offlane', 1),
('4-5', 'Support', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `rounds`
--

CREATE TABLE `rounds` (
  `idRound` int(11) NOT NULL,
  `idBracket` int(11) NOT NULL,
  `round` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `rounds`
--

INSERT INTO `rounds` (`idRound`, `idBracket`, `round`) VALUES
(1, 1, 'Round 1'),
(2, 1, 'Round 2'),
(3, 1, 'Round 3'),
(4, 1, 'Round 4'),
(5, 1, 'Semifinal'),
(6, 1, 'Final'),
(7, 2, 'Quaterfinal'),
(8, 2, 'Semifinal'),
(9, 2, 'Final');

-- --------------------------------------------------------

--
-- Структура таблицы `substitutions`
--

CREATE TABLE `substitutions` (
  `idSubstitution` int(11) NOT NULL COMMENT 'id замены',
  `idPlayer` int(11) DEFAULT NULL COMMENT 'id игрока, которого заменили',
  `idPlayer1` int(11) DEFAULT NULL COMMENT 'id заменившего игрока',
  `idMatch` int(11) DEFAULT NULL COMMENT 'id матча',
  `idTeam` int(11) DEFAULT NULL COMMENT 'id команды / id команды, которую заменили',
  `idTeam1` int(11) DEFAULT NULL COMMENT 'id заменившей команды',
  `idTournament` int(11) DEFAULT NULL COMMENT 'id турнира'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `teams`
--

CREATE TABLE `teams` (
  `idTeam` int(11) NOT NULL COMMENT 'id команды',
  `idDiscipline` int(11) NOT NULL COMMENT 'id дисциплины',
  `name` varchar(255) NOT NULL COMMENT 'название команды',
  `logo` varchar(1500) NOT NULL COMMENT 'путь к лого',
  `countryFlag` varchar(500) NOT NULL COMMENT 'флаг страны',
  `country` varchar(100) NOT NULL COMMENT 'страна',
  `appearenceDate` year(4) NOT NULL COMMENT 'дата основания',
  `site` varchar(1500) NOT NULL COMMENT 'сайт',
  `prize` decimal(11,0) DEFAULT NULL COMMENT 'сумма призовых',
  `description` text NOT NULL COMMENT 'описание'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `teams`
--

INSERT INTO `teams` (`idTeam`, `idDiscipline`, `name`, `logo`, `countryFlag`, `country`, `appearenceDate`, `site`, `prize`, `description`) VALUES
(1, 1, 'Secret', '/images/teamLogos/Secret.png', '/images/countryFlags/Европа.png', 'Европа', 2014, 'http://www.teamsecret.gg', '7538432', '  Европейская профессиональная команда в Dota 2.  Чемпион The Shanghai Major 2016, DreamLeague Season 8, Captains Draft 4.0 и DreamLeague Season 9.'),
(73, 0, 'Athletico Esports', 'images/teamLogos/Athletico Esports.png', 'images/countryFlags/Австралия', 'Австралия', 0000, '', '10784', ''),
(74, 0, 'Dark Sided', 'images/teamLogos/Dark Sided.png', 'images/countryFlags/Австралия', 'Австралия', 0000, '', '1093', ''),
(75, 0, 'Vici Gaming', 'images/teamLogos/Vici Gaming.png', 'images/countryFlags/Китай', 'Китай', 0000, '', '6524848', ''),
(76, 0, 'Gambit Esports', 'images/teamLogos/Gambit Esports.png', 'images/countryFlags/Россия', 'Россия', 0000, '', '354300', ''),
(77, 0, 'Ninjas in Pyjamas', 'images/teamLogos/Ninjas in Pyjamas.png', 'images/countryFlags/Швеция', 'Швеция', 0000, '', '577495', ''),
(78, 0, 'LGD Gaming', 'images/teamLogos/LGD Gaming.png', 'images/countryFlags/Китай', 'Китай', 0000, '', '12422278', ''),
(79, 0, 'Invictus Gaming', 'images/teamLogos/Invictus Gaming.png', 'images/countryFlags/Китай', 'Китай', 0000, '', '4851022', ''),
(80, 0, 'Team Liquid', 'images/teamLogos/Team Liquid.png', 'images/countryFlags/Европа', 'Европа', 0000, '', '17769833', ''),
(81, 0, 'Evil Geniuses', 'images/teamLogos/Evil Geniuses.png', 'images/countryFlags/США', 'США', 0000, '', '18219850', ''),
(82, 0, 'Team Secret', 'images/teamLogos/Team Secret.png', 'images/countryFlags/Европа', 'Европа', 0000, '', '8228615', ''),
(83, 0, 'The Alliance', 'images/teamLogos/The Alliance.png', 'images/countryFlags/Швеция', 'Швеция', 0000, '', '3548402', ''),
(84, 0, 'Forward Gaming', 'images/teamLogos/Forward Gaming.png', 'images/countryFlags/США', 'США', 0000, '', '84500', ''),
(85, 0, 'Keen Gaming', 'images/teamLogos/Keen Gaming.png', 'images/countryFlags/Китай', 'Китай', 0000, '', '651016', ''),
(86, 0, 'TnC Predator', 'images/teamLogos/TnC Predator.png', 'images/countryFlags/Филиппины', 'Филиппины', 0000, '', '3071033', ''),
(87, 0, 'Virtus.Pro', 'images/teamLogos/Virtus.Pro.png', 'images/countryFlags/Россия', 'Россия', 0000, '', '8360644', ''),
(88, 0, 'Natus Vincere', 'images/teamLogos/Natus Vincere.png', 'images/countryFlags/Украина', 'Украина', 0000, '', '4048826', ''),
(89, 0, 'old but gold', 'images/teamLogos/old but gold.png', 'images/countryFlags/Россия', 'Россия', 0000, '', '35000', ''),
(90, 0, 'Team Empire', 'images/teamLogos/Team Empire.png', 'images/countryFlags/Россия', 'Россия', 0000, '', '1981545', ''),
(91, 0, 'Winstrike Team', 'images/teamLogos/Winstrike Team.png', 'images/countryFlags/Россия', 'Россия', 0000, '', '383864', ''),
(92, 0, 'The Final Tribe', 'images/teamLogos/The Final Tribe.png', 'images/countryFlags/Швеция', 'Швеция', 0000, '', '69500', ''),
(93, 0, 'Vega Squadron', 'images/teamLogos/Vega Squadron.png', 'images/countryFlags/Европа', 'Европа', 0000, '', '490329', ''),
(94, 0, 'Team Singularity', 'images/teamLogos/Team Singularity.png', 'images/countryFlags/Европа', 'Европа', 0000, '', '17241', ''),
(95, 0, 'Thunder Predator', 'images/teamLogos/Thunder Predator.png', 'images/countryFlags/Перу', 'Перу', 0000, '', '38200', ''),
(96, 0, 'Team Xolotl', 'images/teamLogos/Team Xolotl.png', 'images/countryFlags/Мексика', 'Мексика', 0000, '', '650', ''),
(97, 0, 'Gorillaz-Pride', 'images/teamLogos/Gorillaz-Pride.png', 'images/countryFlags/Перу', 'Перу', 0000, '', '17000', ''),
(98, 0, 'Neon Esports', 'images/teamLogos/Neon Esports.png', 'images/countryFlags/Филиппины', 'Филиппины', 0000, '', '34645', ''),
(99, 0, 'Execration', 'images/teamLogos/Execration.png', 'images/countryFlags/Филиппины', 'Филиппины', 0000, '', '338482', ''),
(100, 0, '496 Production', 'images/teamLogos/496 Production.png', 'images/countryFlags/Вьетнам', 'Вьетнам', 0000, '', '3170', ''),
(101, 0, 'Alpha Red', 'images/teamLogos/Alpha Red.png', 'images/countryFlags/Тайланд', 'Тайланд', 0000, '', '21804', ''),
(102, 0, 'Geek Fam', 'images/teamLogos/Geek Fam.png', 'images/countryFlags/Малайзия', 'Малайзия', 0000, '', '132131', ''),
(103, 0, 'Exclamation Mark', 'images/teamLogos/Exclamation Mark.png', 'images/countryFlags/Тайланд', 'Тайланд', 0000, '', '9862', ''),
(104, 0, 'Dragon Gaming', 'images/teamLogos/Dragon Gaming.png', 'images/countryFlags/Малайзия', 'Малайзия', 0000, '', '2000', ''),
(105, 0, 'Cignal Ultra', 'images/teamLogos/Cignal Ultra.png', 'images/countryFlags/Филиппины', 'Филиппины', 0000, '', '8877', ''),
(106, 0, 'Flaming Cyborg Alpha', 'images/teamLogos/Flaming Cyborg Alpha.png', 'images/countryFlags/Китай', 'Китай', 0000, '', '4320', ''),
(107, 0, 'iG Vitality', 'images/teamLogos/iG Vitality.png', 'images/countryFlags/Китай', 'Китай', 0000, '', '915053', ''),
(108, 0, 'Keen Gaming.Luminous', 'images/teamLogos/Keen Gaming.Luminous.png', 'images/countryFlags/Китай', 'Китай', 0000, '', '22316', ''),
(109, 0, 'Team EVER', 'images/teamLogos/Team EVER.png', 'images/countryFlags/Китай', 'Китай', 0000, '', '16115', ''),
(110, 0, 'Team Sincere', 'images/teamLogos/Team Sincere.png', 'images/countryFlags/Китай', 'Китай', 0000, '', '4440', ''),
(111, 0, 'TSG.JZONE.XH', 'images/teamLogos/TSG.JZONE.XH.png', 'images/countryFlags/Китай', 'Китай', 0000, '', '5794', ''),
(112, 0, 'Vampire Gaming', 'images/teamLogos/Vampire Gaming.png', 'images/countryFlags/Китай', 'Китай', 0000, '', '1440', ''),
(113, 0, 'Avalon Gaming', 'images/teamLogos/Avalon Gaming.png', 'images/countryFlags/Китай', 'Китай', 0000, '', '10366', ''),
(114, 0, 'Photon Gaming', 'images/teamLogos/Photon Gaming.png', 'images/countryFlags/Китай', 'Китай', 0000, '', '3500', ''),
(115, 0, 'ReckoninG Esports', 'images/teamLogos/ReckoninG Esports.png', 'images/countryFlags/Мьянма', 'Мьянма', 0000, '', '5094', ''),
(116, 0, 'PG.Barracx', 'images/teamLogos/PG.Barracx.png', 'images/countryFlags/Индонезия', 'Индонезия', 0000, '', '37640', ''),
(117, 0, 'compLexity', 'images/teamLogos/compLexity.png', 'images/countryFlags/США', 'США', 0000, '', '859368', ''),
(118, 0, 'beastcoast', 'images/teamLogos/beastcoast.png', 'images/countryFlags/США', 'США', 0000, '', '10000', ''),
(119, 0, 'paiN Gaming', 'images/teamLogos/paiN Gaming.png', 'images/countryFlags/Бразилия', 'Бразилия', 0000, '', '629127', ''),
(120, 0, 'Chaos Esports Club', 'images/teamLogos/Chaos Esports Club.png', 'images/countryFlags/Интернациональная', 'Интернациональная', 0000, '', '47500', ''),
(121, 0, 'OG', 'images/teamLogos/OG.png', 'images/countryFlags/Европа', 'Европа', 0000, '', '17703843', ''),
(122, 0, 'Fnatic', 'images/teamLogos/Fnatic.png', 'images/countryFlags/Малайзия', 'Малайзия', 0000, '', '3319506', ''),
(123, 0, 'Mineski', 'images/teamLogos/Mineski.png', 'images/countryFlags/Филиппины', 'Филиппины', 0000, '', '1521181', '');

-- --------------------------------------------------------

--
-- Структура таблицы `tournamentmembers`
--

CREATE TABLE `tournamentmembers` (
  `idTournament` int(11) NOT NULL COMMENT 'id турнира',
  `idTeam` int(11) NOT NULL COMMENT 'id команды',
  `invited` varchar(45) DEFAULT NULL COMMENT 'приглашен или прошел квалы'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `tournamentresults`
--

CREATE TABLE `tournamentresults` (
  `idTournament` int(11) NOT NULL COMMENT 'id турнира',
  `idTeam` int(11) NOT NULL COMMENT 'id команды',
  `place` varchar(50) NOT NULL COMMENT 'призовое место',
  `prize` int(11) NOT NULL COMMENT 'сумма призовых',
  `slot` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `tournaments`
--

CREATE TABLE `tournaments` (
  `idTournament` int(11) NOT NULL COMMENT 'id турнира',
  `event` varchar(45) NOT NULL,
  `tournamentLogo` varchar(50) NOT NULL COMMENT 'логотип турнира',
  `miniTournamentLogo` varchar(100) NOT NULL COMMENT 'мини логотип',
  `seria` varchar(100) NOT NULL COMMENT 'серия',
  `description` varchar(1500) NOT NULL COMMENT 'описание ',
  `prize` int(11) NOT NULL COMMENT 'сумма призовых',
  `dateBegin` date NOT NULL COMMENT 'дата начала турнира',
  `dateEnd` date NOT NULL COMMENT 'дата окончания турнира',
  `location` varchar(100) NOT NULL COMMENT 'локация',
  `idRegion` int(11) DEFAULT NULL COMMENT 'id региона'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `autorization`
--
ALTER TABLE `autorization`
  ADD PRIMARY KEY (`user_id`);

--
-- Индексы таблицы `brackets`
--
ALTER TABLE `brackets`
  ADD PRIMARY KEY (`idBracket`);

--
-- Индексы таблицы `disciplines`
--
ALTER TABLE `disciplines`
  ADD PRIMARY KEY (`idDiscipline`);

--
-- Индексы таблицы `grouptable`
--
ALTER TABLE `grouptable`
  ADD KEY `groupTable_ibfk_1_idx` (`idTournament`),
  ADD KEY `groupTable_ibfk_2_idx` (`idTeam`);

--
-- Индексы таблицы `matchdescription`
--
ALTER TABLE `matchdescription`
  ADD KEY `matchDesctiption_ibfk_1_idx` (`idMatch`),
  ADD KEY `matchDesctiption_ibfk_2_idx` (`idFormat`),
  ADD KEY `matchDesctiption_ibfk_4_idx` (`secondWinner`),
  ADD KEY `matchDesctiption_ibfk_3_idx` (`firstWinner`),
  ADD KEY `matchDesctiption_ibfk_5_idx` (`thirdWinner`),
  ADD KEY `matchDesctiption_ibfk_6_idx` (`fourthWinner`),
  ADD KEY `matchDesctiption_ibfk_7_idx` (`fifthWinner`);

--
-- Индексы таблицы `matches`
--
ALTER TABLE `matches`
  ADD PRIMARY KEY (`idMatch`),
  ADD KEY `matches_ibfk_1_idx` (`idTournament`),
  ADD KEY `matches_ibfk_2_idx` (`idFirstTeam`),
  ADD KEY `matches_ibfk_3_idx` (`idSecondTeam`);

--
-- Индексы таблицы `matchformats`
--
ALTER TABLE `matchformats`
  ADD PRIMARY KEY (`idMatchFormat`);

--
-- Индексы таблицы `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`idPlayer`),
  ADD KEY `players_ibfk_1_idx` (`idTeam`),
  ADD KEY `players_ibfk_2_idx` (`idDiscipline`),
  ADD KEY `idRole` (`idRole`);

--
-- Индексы таблицы `playertransfers`
--
ALTER TABLE `playertransfers`
  ADD PRIMARY KEY (`idTransfer`),
  ADD KEY `playerTransfers_ibfk_1_idx` (`idPlayer`),
  ADD KEY `playerTransfers_ibfk_2_idx` (`idTeam`);

--
-- Индексы таблицы `prognoz`
--
ALTER TABLE `prognoz`
  ADD PRIMARY KEY (`idUser`);

--
-- Индексы таблицы `regions`
--
ALTER TABLE `regions`
  ADD PRIMARY KEY (`idRegion`);

--
-- Индексы таблицы `relatedtournaments`
--
ALTER TABLE `relatedtournaments`
  ADD KEY `relatedtournaments_ibfk_1` (`idRelatedTournament`),
  ADD KEY `relatedtournaments_ibfk_2` (`idTournament`);

--
-- Индексы таблицы `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`idRole`),
  ADD KEY `roles_ibfk_1_idx` (`idDiscipline`);

--
-- Индексы таблицы `rounds`
--
ALTER TABLE `rounds`
  ADD PRIMARY KEY (`idRound`),
  ADD KEY `rounds_ibfk_1_idx` (`idBracket`);

--
-- Индексы таблицы `substitutions`
--
ALTER TABLE `substitutions`
  ADD PRIMARY KEY (`idSubstitution`),
  ADD KEY `subsitutions_ibfk_1_idx` (`idPlayer`),
  ADD KEY `substitutions_ibfk_2_idx` (`idPlayer1`),
  ADD KEY `substitutions_ibfk_3_idx` (`idMatch`),
  ADD KEY `substitutions_ibfk4_idx` (`idTeam`),
  ADD KEY `substitutions_ibfk_5_idx` (`idTeam1`),
  ADD KEY `substitutions_ibfk_6_idx` (`idTournament`);

--
-- Индексы таблицы `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`idTeam`),
  ADD KEY `teams_ibfk_1_idx` (`idDiscipline`);

--
-- Индексы таблицы `tournamentmembers`
--
ALTER TABLE `tournamentmembers`
  ADD KEY `tournamentMembers_ibfk_1_idx` (`idTournament`),
  ADD KEY `tournamentMembers_ibfk_2_idx` (`idTeam`);

--
-- Индексы таблицы `tournamentresults`
--
ALTER TABLE `tournamentresults`
  ADD PRIMARY KEY (`idTournament`),
  ADD KEY `tournamentResults_ibfk_2_idx` (`idTeam`),
  ADD KEY `idTournament` (`idTournament`);

--
-- Индексы таблицы `tournaments`
--
ALTER TABLE `tournaments`
  ADD PRIMARY KEY (`idTournament`),
  ADD KEY `tournaments_ibfk_1_idx` (`idRegion`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `autorization`
--
ALTER TABLE `autorization`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `brackets`
--
ALTER TABLE `brackets`
  MODIFY `idBracket` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `disciplines`
--
ALTER TABLE `disciplines`
  MODIFY `idDiscipline` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id дисциплины', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `matches`
--
ALTER TABLE `matches`
  MODIFY `idMatch` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id матча';

--
-- AUTO_INCREMENT для таблицы `matchformats`
--
ALTER TABLE `matchformats`
  MODIFY `idMatchFormat` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id формата', AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `players`
--
ALTER TABLE `players`
  MODIFY `idPlayer` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id игрока', AUTO_INCREMENT=261;

--
-- AUTO_INCREMENT для таблицы `playertransfers`
--
ALTER TABLE `playertransfers`
  MODIFY `idTransfer` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id трансфера';

--
-- AUTO_INCREMENT для таблицы `prognoz`
--
ALTER TABLE `prognoz`
  MODIFY `idUser` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `regions`
--
ALTER TABLE `regions`
  MODIFY `idRegion` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id региона', AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `rounds`
--
ALTER TABLE `rounds`
  MODIFY `idBracket` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `substitutions`
--
ALTER TABLE `substitutions`
  MODIFY `idSubstitution` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id замены';

--
-- AUTO_INCREMENT для таблицы `teams`
--
ALTER TABLE `teams`
  MODIFY `idTeam` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id команды', AUTO_INCREMENT=124;

--
-- AUTO_INCREMENT для таблицы `tournaments`
--
ALTER TABLE `tournaments`
  MODIFY `idTournament` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id турнира';

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `grouptable`
--
ALTER TABLE `grouptable`
  ADD CONSTRAINT `groupTable_ibfk_1` FOREIGN KEY (`idTournament`) REFERENCES `tournaments` (`idtournament`),
  ADD CONSTRAINT `groupTable_ibfk_2` FOREIGN KEY (`idTeam`) REFERENCES `teams` (`idteam`);

--
-- Ограничения внешнего ключа таблицы `matchdescription`
--
ALTER TABLE `matchdescription`
  ADD CONSTRAINT `matchDesctiption_ibfk_1` FOREIGN KEY (`idMatch`) REFERENCES `matches` (`idMatch`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `matchDesctiption_ibfk_2` FOREIGN KEY (`idFormat`) REFERENCES `matchformats` (`idMatchFormat`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `matchDesctiption_ibfk_3` FOREIGN KEY (`firstWinner`) REFERENCES `teams` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `matchDesctiption_ibfk_4` FOREIGN KEY (`secondWinner`) REFERENCES `teams` (`idteam`),
  ADD CONSTRAINT `matchDesctiption_ibfk_5` FOREIGN KEY (`thirdWinner`) REFERENCES `teams` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `matchDesctiption_ibfk_6` FOREIGN KEY (`fourthWinner`) REFERENCES `teams` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `matchDesctiption_ibfk_7` FOREIGN KEY (`fifthWinner`) REFERENCES `teams` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `matches`
--
ALTER TABLE `matches`
  ADD CONSTRAINT `matches_ibfk_1` FOREIGN KEY (`idTournament`) REFERENCES `tournaments` (`idTournament`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `matches_ibfk_2` FOREIGN KEY (`idFirstTeam`) REFERENCES `teams` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `matches_ibfk_3` FOREIGN KEY (`idSecondTeam`) REFERENCES `teams` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`idTeam`) REFERENCES `teams` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `players_ibfk_2` FOREIGN KEY (`idDiscipline`) REFERENCES `disciplines` (`idDiscipline`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `players_ibfk_3` FOREIGN KEY (`idRole`) REFERENCES `roles` (`idRole`);

--
-- Ограничения внешнего ключа таблицы `playertransfers`
--
ALTER TABLE `playertransfers`
  ADD CONSTRAINT `playerTransfers_ibfk_2` FOREIGN KEY (`idTeam`) REFERENCES `teams` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `playertransfers_ibfk_1` FOREIGN KEY (`idPlayer`) REFERENCES `players` (`idPlayer`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `relatedtournaments`
--
ALTER TABLE `relatedtournaments`
  ADD CONSTRAINT `relatedtournaments_ibfk_1` FOREIGN KEY (`idRelatedTournament`) REFERENCES `tournaments` (`idTournament`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `relatedtournaments_ibfk_2` FOREIGN KEY (`idTournament`) REFERENCES `tournaments` (`idTournament`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `roles`
--
ALTER TABLE `roles`
  ADD CONSTRAINT `roles_ibfk_1` FOREIGN KEY (`idDiscipline`) REFERENCES `disciplines` (`idDiscipline`);

--
-- Ограничения внешнего ключа таблицы `rounds`
--
ALTER TABLE `rounds`
  ADD CONSTRAINT `rounds_ibfk_1` FOREIGN KEY (`idBracket`) REFERENCES `brackets` (`idBracket`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `substitutions`
--
ALTER TABLE `substitutions`
  ADD CONSTRAINT `substitutions_ibfk_3` FOREIGN KEY (`idMatch`) REFERENCES `matches` (`idMatch`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `substitutions_ibfk_4` FOREIGN KEY (`idTeam`) REFERENCES `teams` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `substitutions_ibfk_6` FOREIGN KEY (`idTournament`) REFERENCES `tournaments` (`idTournament`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `substitutions_ibfk_7` FOREIGN KEY (`idTeam1`) REFERENCES `teams` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `substitutions_ibfk_8` FOREIGN KEY (`idPlayer`) REFERENCES `players` (`idPlayer`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `substitutions_ibfk_9` FOREIGN KEY (`idPlayer1`) REFERENCES `players` (`idPlayer`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `tournamentmembers`
--
ALTER TABLE `tournamentmembers`
  ADD CONSTRAINT `tournamentMembers_ibfk_1` FOREIGN KEY (`idTournament`) REFERENCES `tournaments` (`idTournament`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tournamentMembers_ibfk_2` FOREIGN KEY (`idTeam`) REFERENCES `teams` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `tournamentresults`
--
ALTER TABLE `tournamentresults`
  ADD CONSTRAINT `tournamentResults_ibfk_2` FOREIGN KEY (`idTeam`) REFERENCES `teams` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tournamentresults_ibfk_1` FOREIGN KEY (`idTournament`) REFERENCES `tournaments` (`idTournament`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `tournaments`
--
ALTER TABLE `tournaments`
  ADD CONSTRAINT `tournaments_ibfk_1` FOREIGN KEY (`idRegion`) REFERENCES `regions` (`idRegion`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
