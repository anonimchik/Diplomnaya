-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3006
-- Время создания: Июн 10 2019 г., 20:49
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
CREATE DEFINER=`root`@`%` PROCEDURE `checkMatchField` (IN `tournament` INT, IN `firstTeam` INT, IN `secondTeam` INT, IN `datetime` VARCHAR(19), IN `status` INT, IN `format` VARCHAR(3))  NO SQL
IF tournament<>'' or firstTeam<>'' or secondTeam<>'' or format<>'' or datetime<>'' THEN 
    INSERT INTO matches(idTournament, idFirstTeam, idSecondTeam, date, status) VALUES(tournament, firstTeam, secondTeam, datetime, status);
SET @last_id:=last_insert_id();
INSERT INTO matchdescription(idMatch, idFormat) VALUES(@last_id, format);
ELSE
	SIGNAL SQLSTATE '50000'
    SET MESSAGE_TEXT='Заполните все необходимые поля';
END IF$$

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

CREATE DEFINER=`root`@`%` PROCEDURE `checkTeams` (IN `firstTeam` INT, IN `secondTeam` INT)  NO SQL
IF secondTeam=firstTeam THEN 
    SIGNAL SQLSTATE '50000'
    SET MESSAGE_TEXT='Участниками не может быть одна и таже команда';
END IF$$

CREATE DEFINER=`root`@`%` PROCEDURE `checkTournamentMember` (IN `idTeam` INT)  NO SQL
IF idTeam in(SELECT idTeam from tournamentmembers) THEN 
	SIGNAL SQLSTATE '50000'
	SET MESSAGE_TEXT='Такой участник уже существует';
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
-- Дамп данных таблицы `autorization`
--

INSERT INTO `autorization` (`user_id`, `login`, `password`) VALUES
(1, 'admin', '21232f297a57a5a743894a0e4a801fc3');

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
  `round` varchar(50) NOT NULL COMMENT 'раунд матча',
  `firstWinner` int(11) DEFAULT NULL COMMENT 'победитель 1-ой карты',
  `secondWinner` int(11) DEFAULT NULL COMMENT 'победитель 2-ой карты',
  `thirdWinner` int(11) DEFAULT NULL COMMENT 'победитель 3-ей карты',
  `fourthWinner` int(11) DEFAULT NULL COMMENT 'победитель 4-ой карты',
  `fifthWinner` int(11) DEFAULT NULL COMMENT 'победитель 5-ой карты',
  `firstFinalScore` int(11) NOT NULL COMMENT 'итоговый счет первой команды',
  `secondFinalScore` int(11) NOT NULL COMMENT 'итоговый счет второй команды',
  `firstMapPhoto` varchar(45) DEFAULT NULL,
  `secondMapPhoto` varchar(45) DEFAULT NULL,
  `thirdMapPhoto` varchar(45) DEFAULT NULL,
  `fourthMapPhoto` varchar(45) DEFAULT NULL,
  `fifthMapPhoto` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `matchdescription`
--

INSERT INTO `matchdescription` (`idMatch`, `idFormat`, `round`, `firstWinner`, `secondWinner`, `thirdWinner`, `fourthWinner`, `fifthWinner`, `firstFinalScore`, `secondFinalScore`, `firstMapPhoto`, `secondMapPhoto`, `thirdMapPhoto`, `fourthMapPhoto`, `fifthMapPhoto`) VALUES
(3, 3, 'Playoff, Lower Bracket, Round 1', 33, 33, NULL, NULL, NULL, 0, 2, './images/mapscore/211419-1-9564.jpg', './images/mapscore/211419-2-3839.jpg', NULL, NULL, NULL),
(4, 3, '', NULL, NULL, NULL, NULL, NULL, 2, 1, NULL, NULL, NULL, NULL, NULL),
(8, 3, 'Playoff, Lower Bracket, Round 1', 21, 21, NULL, NULL, NULL, 0, 2, './images/mapscore/211424-1-4162.jpg', './images/mapscore/211424-2-6783.jpg', NULL, NULL, NULL),
(10, 3, 'Group Stage, Group B', NULL, NULL, NULL, NULL, NULL, 2, 0, './images/mapscore/211127-1-6467.jpg', './images/mapscore/211127-2-656.jpg', NULL, NULL, NULL),
(11, 2, 'Group Stage, Group B', NULL, NULL, NULL, NULL, NULL, 2, 0, './images/mapscore/211129-1-5155.jpg', './images/mapscore/211129-2-4919.jpg', NULL, NULL, NULL),
(12, 2, 'Group Stage, Group B', NULL, NULL, NULL, NULL, NULL, 0, 2, './images/mapscore/211128-1-260.jpg', './images/mapscore/211128-2-9394.jpg', NULL, NULL, NULL),
(13, 2, 'Group Stage, Group B', NULL, NULL, NULL, NULL, NULL, 1, 1, './images/mapscore/211130-1-8153.jpg', './images/mapscore/211130-2-1025.jpg', NULL, NULL, NULL),
(14, 2, 'Group Stage, Group A', NULL, NULL, NULL, NULL, NULL, 2, 0, './images/mapscore/211133-1-7044.jpg', './images/mapscore/211133-2-7166.jpg', NULL, NULL, NULL),
(15, 2, 'Group Stage, Group A', NULL, NULL, NULL, NULL, NULL, 0, 2, './images/mapscore/211131-1-4841.jpg', './images/mapscore/211131-2-2342.jpg', NULL, NULL, NULL),
(16, 2, 'Group Stage, Group A', NULL, NULL, NULL, NULL, NULL, 1, 1, './images/mapscore/211132-1-8676.jpg', './images/mapscore/211132-2-294.jpg', '', '', ''),
(17, 2, 'Group Stage, Group B', NULL, NULL, NULL, NULL, NULL, 2, 0, './images/mapscore/211136-1-4825.jpg', './images/mapscore/211136-2-2664.jpg', '', '', '');

-- --------------------------------------------------------

--
-- Структура таблицы `matches`
--

CREATE TABLE `matches` (
  `idMatch` int(11) NOT NULL COMMENT 'id матча',
  `idTournament` int(11) NOT NULL COMMENT 'id турнира',
  `idFirstTeam` int(11) NOT NULL COMMENT 'id первой команды',
  `idSecondTeam` int(11) NOT NULL COMMENT 'id второй команды',
  `date` datetime NOT NULL COMMENT 'дата проведения матча',
  `status` int(11) NOT NULL COMMENT 'статус матча'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `matches`
--

INSERT INTO `matches` (`idMatch`, `idTournament`, `idFirstTeam`, `idSecondTeam`, `date`, `status`) VALUES
(3, 13, 6, 33, '2019-05-18 15:02:00', 1),
(4, 9, 33, 12, '2019-05-21 00:00:00', 1),
(8, 13, 20, 21, '2019-05-18 13:03:00', 1),
(10, 5, 12, 7, '2019-05-29 19:28:00', 1),
(11, 5, 7, 5, '2019-05-29 22:04:00', 1),
(12, 5, 12, 10, '2019-05-29 22:06:00', 1),
(13, 5, 1, 14, '2019-05-29 22:22:00', 1),
(14, 5, 4, 13, '2019-05-30 14:00:00', 1),
(15, 5, 6, 15, '2019-05-30 14:00:00', 1),
(16, 5, 9, 33, '2019-05-30 14:01:00', 1),
(17, 5, 1, 12, '2019-06-30 00:00:00', 1);

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
(256, 1, 1, 'Польша', '/images/countryFlags/Польша.png', 'Михал Янковски', 'Nisha', 'Профессиональный игрок в Dota 2.\r\n\r\nНа про-сцене с 2014 года. Большую часть своей карьеры выступал за польскую команду Let\'s Do It. Коллектив отличался стабильным составом, но очень нестабильной игрой. В 2016 году полякам удалось выиграть несколько ProDotA Cup в Европе. Микс трижды подписывал контракты с организациями, но ни на одном крупном турнире команда не смогла показать хорошего результата. Под тегом Team Kinguin поляки приняли участие в квалификациях на TI8 и потерпели поражение. После этого организация расторгла контракты с игроками, но и сам состав не пережил полосы длительных неудач и распался. В сентябре 2018 года Nisha получил приглашение от Puppey и присоединился к Team Secret.\r\n\r\nЗа свою карьеру Nisha играл на разных ролях - от саппорта до core-позиций. Со временем Мид-линия стала для него основной, но в Team Secret Михалу была доверена роль керри.', '2000-09-28', '/images/playerPhotos/Nisha.png', '1', 'Easy', 253449),
(257, 1, 1, 'Малайзия', '/images/countryFlags/Малайзия.png', 'Чжэн Йек Най', 'MidOne', 'Профессиональный игрок из Малайзии. \r\n\r\nДостиг 7 700 MMR в Dota 2 ещё до вступления в ряды Fnatic. Предпочитает играть в центре и выполняет роль мидлейнера. Успел поиграть в таких командах, как aG.Psk, PsK, IMBS-PsK и Dot.CyberCafe. Был стендином в командах Panglima и Mineski. В декабре 2015 года встал на защиту мид-линии команды Fnatic. \r\n\r\nНа Ti6 добрался до 4-го места, но после турнира покинул коллектив и неожиданно оказался в Team Secret.', '1996-06-03', '/images/playerPhotos/MidOne.png', '2', 'Mid', 487350),
(258, 1, 1, 'Швеция', '/images/countryFlags/Швеция.png', 'Людвиг Уолберг', 'zai', 'Профессиональный игрок в Dota 2 из Швеции.\r\n\r\nУспел поиграть в Heroes of Newerth, где добился высоких результатов, после чего перешел на Dota 2. Произошло это в 2013 году. Некоторое время он выступал за американский микс Stay Free, а в ноябре принял участие в Star Ladder Star Series Season 8 с командой Super Strong Dinosaurs. Команде не хватило буквально одной победы, чтобы претендовать на выход в плейофф. Но микс начал разваливаться уже по ходу сезона. Тогда zai играл на саппорт-героях в паре с ppd, и они показывали достаточно хорошую игру, чтобы их заметил Fear и пригласил в свой микс S A D B O Y S. В феврале 2014 года EG подписали этот состав и довольно быстро стали претендовать на место в топе.\r\n\r\nУже тогда пара zai-ppd считалась одной из самых сильных саппорт-связок на профессиональной сцене. EG победила на The Summit 1, а на TI4 добрались до \"бронзы\". К концу года команда стала буксовать. Перемены коснулись zai, лучшая пара саппортов оказалась разорвана - ppd остался с EG, а Людвиг перешёл в Team Secret. Некоторое время потребовалось чтобы понять, на какой роли будет играть молодой игрок, но zai остановился на героях сложной линии. В Team Secret zai окончательно реализовался как оффлейнер, встав в один ряд с сильнейшими игроками этой позиции. Победив на ряде Premium турниров Team Secret уверенно подошли к TI5, но на самом турнире игра команды расстроилась, и коллектив остановился на 7-8 месте.\r\n\r\nПосле этого Людвиг решил временно приостановить карьеру, сосредоточив усилия на учебе. Однако он числился запасным игроком в Evil Geniuses до тех пор, пока полноценно не вернулся на профессиональную сцену в мае 2016 года, войдя в состав Kaipi. Уже в июне провалившиеся на The Manila Major 2016 Evil Geniuses позвали zai обратно в основной состав. В августе 2017 год zai покинул команду. Вместе с ppd они основали микс The Dire, который в сентябре подписал контракты с OpTic Gaming.\r\n\r\nzai отличается редким трудолюбием. Он старается оттачивать исполнение на нужных героях до идеала.', '1997-08-05', '/images/playerPhotos/Zai.png', '3', 'Offlane', 1346189),
(259, 1, 1, 'Эстония', '/images/countryFlags/Эстония.png', 'Клемент Иванов', 'Puppey', 'Профессиональный игрок в Dota 2.Чемпион Мира 2011 года (в составе Natus Vincere).\r\n\r\nКлемент считается одним из сильнейших капитанов и аналитиков в Dota 2. Свою карьеру он начал в 2007 году неизвестным пабером в команде XsK, но в 2008 году заслужил уважение профессиональных игроков после 3 места на ESL Major Series. Дуэт с KuroKy в Kingsurf.int стал одним из самых знаковых в истории Доты. К 2011 Клемент был уже опытным игроком, от которого бы не отказалась любая команда. Однако повезло украинской организации Natus Vincere. Готовя свою команду к первому в истории The International, Na\'Vi переманили к себе сильнейших на тот момент игроков СНГ. 17 июня 2011 Puppey перешёл под флаги \"жёлто-чёрных\", а в августе Na\'Vi взяли первое место на TI1. После ухода из Na\'Vi ArtStyle капитанский слот переходит к Puppey. 2011-14 годы безусловно можно назвать \"эрой Puppey\" в команде. До 2012 у Natus Vincere просто не было соперника.\r\n\r\nВ феврале 2013 года Puppey приглашает в Na\'Vi своего старого товарища KuroKy. Количество титулов только на топовых турнирах превысило десятку — семикратные чемпионы StarLadder, двукратные вице-чемпионы The International, победители множества крупных онлайн-турниров. И хотя у команды не всегда всё шло гладко, именно несгибаемая воля капитана Puppey позволяла в нужный момент собраться и показать зрелищную и сильную Доту. В начале 2014 года \"магия\" стала улетучиваться. После победы на Star Ladder Star Series Season 8 команда так и не смогла выиграть ни одного Лана. В сторону Puppey усиливается критика, под сомнение ставится как желание Клемента играть в команде, так и драфт. На TI4 команда впервые не попадает в Гранд-финал и занимает 7-8 место. После этого Puppey и KuroKy покидают Na\'Vi и основывают звёздный микс Team Secret.\r\n\r\nНовая команда Puppey занимает лидирующие позиции в Европе и мире, однако взять турнир Premium класса им удалось только в мае 2015 года, после ряда замен в команде. Это была победа на The Summit 3. На TI5 Team Secret приехали фаворитами, но в команде на тот момент уже назревал конфликт. После первого же поражения в плей-оффе стало понятно, что Team Secret уязвимы, что и доказали Virtus.pro, сенсационно выбив команду Puppey с турнира и оставив им довольствоваться 7-8 местом. После TI5 Puppey полностью заменил состав. В этот раз он был не таким звёздным, но команда потеряла стабильность, побед стало меньше, а TI6 стал и вовсе провальным - 13-16 место.\r\n\r\nPuppey не только гениальный капитан, но и сильный игрок на лесных героях. Не раз его единоличные решения по игре и команде подвергались критике. Кроме того, Puppey известен своим скептическим отношением к киберспортивным организациям.', '1990-03-06', '/images/playerPhotos/Puppey.png', '4-5', 'Easy', 1061761),
(260, 1, 1, 'Иордания', '/images/countryFlags/Иордания.png', 'Язид Жарадат', 'YapzOr', 'Иорданский профессиональный игрок в Dota 2.\r\n\r\nКарьера YapzOr складывалась неровно и началась ещё во времена DotA Allstars.В 2011 году он выступал за команду WhyAre. Перейдя на Dota 2, он выступал за многие миксы, но эти коллективы разваливались слишком быстро и YapzOr так и не получил признания.\r\n\r\nНекоторую известность пришла после присоединения к Balkan Bears в конце 2014 года. Команде даже удалось съездить на свой единственный ивент в апреле 2015 года — joinDOTA MLG Pro League Season 1 и занять там 5-6 место. Скоро команда распалась и YapzOr снова вернулся к малоперспективным, но куда более известным миксам: Monkey Freedom Fighters, NO-VASELINE, Mamas Boys. В феврале 2016 года его призвал в ряды своей команды известный комментатор, в прошлом — про-игрок, syndereN, а в мае 2017 года Язид получил приглашение от Puppey и присоединился к Team Secret.', '1994-10-17', '/images/playerPhotos/YapZor.png', '4-5', 'Hard', 478393),
(296, 2, 1, 'Австралия', './images/countryFlags/Австралия.png', 'Nick Capeski', 'Splicko', '', '0000-00-00', './images/playerPhotos/Splicko.png', '2', 'Mid', 2371),
(297, 2, 1, 'Австралия', './images/countryFlags/Австралия.png', 'James Lee', 'XemistrY', '', '0000-00-00', './images/playerPhotos/XemistrY.png', '2', 'Mid', 4211),
(298, 2, 1, 'Австралия', './images/countryFlags/Австралия.png', 'Tuan Nguyen', 'TEKCOR', '', '0000-00-00', './images/playerPhotos/TEKCOR.png', '3', 'Hard', 2157),
(299, 3, 1, 'Австралия', './images/countryFlags/Австралия.png', '&ndash;', 'Reverie', '', '0000-00-00', './images/playerPhotos/Reverie.png', '2', 'Mid', 219),
(300, 3, 1, 'Австралия', './images/countryFlags/Австралия.png', 'Justin Yuen', 'xMusiCa', '', '0000-00-00', './images/playerPhotos/xMusiCa.png', '3', 'Hard', 8111),
(302, 4, 1, 'Китай', './images/countryFlags/Китай.png', 'Zhang Chengjun', 'Paparazi', '', '0000-00-00', './images/playerPhotos/Paparazi.png', '1', 'Safe', 543237),
(303, 4, 1, 'Китай', './images/countryFlags/Китай.png', 'Zeng Jiaoyang', 'Ori', '', '0000-00-00', './images/playerPhotos/Ori.png', '2', 'Mid', 381302),
(304, 4, 1, 'Китай', './images/countryFlags/Китай.png', 'Zhou Haiyang', 'Yang', '', '0000-00-00', './images/playerPhotos/Yang.png', '3', 'Hard', 391569),
(306, 5, 1, 'Россия', './images/countryFlags/Россия.png', 'Nikita Kuzmin', 'Daxak', '', '0000-00-00', './images/playerPhotos/Daxak.png', '1', 'Safe', 72900),
(307, 5, 1, 'Россия', './images/countryFlags/Россия.png', 'Andrey Afonin', 'Afoninje', '', '0000-00-00', './images/playerPhotos/Afoninje.png', '2', 'Mid', 114132),
(308, 5, 1, 'Россия', './images/countryFlags/Россия.png', 'Vasilii Shishkin', 'Afterlife', '', '0000-00-00', './images/playerPhotos/Afterlife.png', '3', 'Hard', 115708),
(311, 6, 1, 'Дания', './images/countryFlags/Дания.png', 'Marcus Hoelgaard', 'Ace', '', '0000-00-00', './images/playerPhotos/Ace.png', '1', 'Safe', 676390),
(313, 7, 1, 'Китай', './images/countryFlags/Китай.png', 'Wang Chunyu', 'Ame', '', '0000-00-00', './images/playerPhotos/Ame.png', '1', 'Safe', 1574220),
(314, 7, 1, 'Китай', './images/countryFlags/Китай.png', 'Yang Shenyi', 'Chalice', '', '0000-00-00', './images/playerPhotos/Chalice.png', '3', 'Hard', 1154544),
(317, 8, 1, 'Китай', './images/countryFlags/Китай.png', 'Lin Zikai', 'doodle', '', '0000-00-00', './images/playerPhotos/doodle.png', '1', 'Safe', 13132),
(318, 8, 1, 'Китай', './images/countryFlags/Китай.png', 'Zhou Yi', 'Emo', '', '0000-00-00', './images/playerPhotos/Emo.png', '2', 'Mid', 15088),
(319, 8, 1, 'Малайзия', './images/countryFlags/Малайзия.png', 'Thiay Jun Wen', 'JT-', '', '0000-00-00', './images/playerPhotos/JT-.png', '3', 'Hard', 27060),
(322, 9, 1, 'Финляндия', './images/countryFlags/Финляндия.png', 'Lasse Urpalainen', 'MATUMBAMAN', '', '0000-00-00', './images/playerPhotos/MATUMBAMAN.png', '2', 'Mid', 3528414),
(325, 10, 1, 'Канада', './images/countryFlags/Канада.png', 'Artour Babaev', 'Arteezy', '', '0000-00-00', './images/playerPhotos/Arteezy.png', '1', 'Safe', 1594121),
(326, 10, 1, 'Пакистан', './images/countryFlags/Пакистан.png', 'Syed Sumail Hassan', 'Sumail', '', '0000-00-00', './images/playerPhotos/Sumail.png', '2', 'Mid', 3283828),
(327, 10, 1, 'Швеция', './images/countryFlags/Швеция.png', 'Gustav Magnusson', 's4', '', '0000-00-00', './images/playerPhotos/s4.png', '3', 'Hard', 2132168),
(330, 12, 1, 'Швеция', './images/countryFlags/Швеция.png', 'Micke Nguyen', 'miCKe', '', '0000-00-00', './images/playerPhotos/miCKe.png', '1', 'Safe', 21909),
(331, 12, 1, 'Германия', './images/countryFlags/Германия.png', 'Max Broecker', 'qojqva', '', '0000-00-00', './images/playerPhotos/qojqva.png', '2', 'Mid', 86254),
(332, 12, 1, 'Швеция', './images/countryFlags/Швеция.png', 'Samuel Svahn', 'boxi', '', '0000-00-00', './images/playerPhotos/boxi.png', '3', 'Hard', 28109),
(334, 13, 1, 'Пакистан', './images/countryFlags/Пакистан.png', 'Yawar Hassan', 'YawaR', '', '0000-00-00', './images/playerPhotos/YawaR.png', '1', 'Safe', 216933),
(335, 13, 1, 'США', './images/countryFlags/США.png', 'Jingjun Wu', 'Sneyking', '', '0000-00-00', './images/playerPhotos/Sneyking.png', '3', 'Hard', 221205),
(338, 14, 1, 'Китай', './images/countryFlags/Китай.png', 'Zhai Jingkai', 'Ying', '', '0000-00-00', './images/playerPhotos/Ying.png', '2', 'Mid', 134329),
(339, 15, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Kim Villafuerte Santos', 'Gabbi', '', '0000-00-00', './images/playerPhotos/Gabbi.png', '1', 'Safe', 148656),
(340, 15, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Armel Paul Tabios', 'Armel', '', '0000-00-00', './images/playerPhotos/Armel.png', '2', 'Mid', 193887),
(341, 15, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Carlo Palad', 'Kuku', '', '0000-00-00', './images/playerPhotos/Kuku.png', '3', 'Hard', 489599),
(344, 16, 1, 'Украина', './images/countryFlags/Украина.png', 'Vladimir Minenko', 'No[o]ne', '', '0000-00-00', './images/playerPhotos/No[o]ne.png', '2', 'Mid', 1384228),
(347, 17, 1, 'Украина', './images/countryFlags/Украина.png', 'Vladislav Krystanek', 'Crystallize', '', '0000-00-00', './images/playerPhotos/Crystallize.png', '1', 'Safe', 97600),
(349, 17, 1, 'Кыргызстан', './images/countryFlags/Кыргызстан.png', 'Evgenii Ri', 'Blizzy', '', '0000-00-00', './images/playerPhotos/Blizzy.png', '3', 'Hard', 53671),
(355, 18, 1, 'Россия', './images/countryFlags/Россия.png', 'Ilya Pivcaev', 'Illidan', '', '0000-00-00', './images/playerPhotos/Illidan.png', '3', 'Safe', 351988),
(358, 19, 1, 'Беларусь', './images/countryFlags/Беларусь.png', 'Nikita Grinkevich', 'Palantimos', '', '0000-00-00', './images/playerPhotos/Palantimos.png', '1', 'Safe', 18858),
(359, 19, 1, 'Украина', './images/countryFlags/Украина.png', 'Yaroslav Vasilenko', 'Pikachu', '', '0000-00-00', './images/playerPhotos/Pikachu.png', '2', 'Mid', 12857),
(360, 19, 1, 'Беларусь', './images/countryFlags/Беларусь.png', 'Eugene Kastrama', 'chshrct', '', '0000-00-00', './images/playerPhotos/chshrct.png', '3', 'Hard', 23478),
(363, 20, 1, 'Россия', './images/countryFlags/Россия.png', 'Konstantin Kogaj', 'kodos', '', '0000-00-00', './images/playerPhotos/kodos.png', '2', 'Mid', 6721),
(364, 20, 1, 'Россия', './images/countryFlags/Россия.png', 'Igor Modenov', 'Maden', '', '0000-00-00', './images/playerPhotos/Maden.png', '3', 'Hard', 13068),
(367, 21, 1, 'Россия', './images/countryFlags/Россия.png', 'Airat Gaziev', 'Silent', '', '0000-00-00', './images/playerPhotos/Silent.png', '1', 'Safe', 266328),
(368, 21, 1, 'Россия', './images/countryFlags/Россия.png', 'Zaur Shakhmurzaev', 'Cooman', '', '0000-00-00', './images/playerPhotos/Cooman.png', '2', 'Mid', 16928),
(369, 21, 1, 'Россия', './images/countryFlags/Россия.png', 'Aleksey Vasiliev', 'nongrataaa', '', '0000-00-00', './images/playerPhotos/nongrataaa.png', '3', 'Hard', 103073),
(372, 22, 1, 'Швеция', './images/countryFlags/Швеция.png', 'Rasmus Blomdin', 'Chessie', '', '0000-00-00', './images/playerPhotos/Chessie.png', '2', 'Mid', 108974),
(373, 22, 1, 'Швеция', './images/countryFlags/Швеция.png', 'Andreas Ragnemalm', 'Xibbe', '', '0000-00-00', './images/playerPhotos/Xibbe.png', '3', 'Hard', 233),
(376, 24, 1, 'Швеция', './images/countryFlags/Швеция.png', 'Steve Zi Shan Ye', 'Xcalibur', '', '0000-00-00', './images/playerPhotos/Xcalibur.png', '1', 'Safe', 18686),
(377, 24, 1, 'Словения', './images/countryFlags/Словения.png', 'Jure Plešej', 'Pingvincek', '', '0000-00-00', './images/playerPhotos/Pingvincek.png', '2', 'Mid', 7790),
(378, 24, 1, 'Россия', './images/countryFlags/Россия.png', 'Maxim Abramovskikh', 'Shachlo', '', '0000-00-00', './images/playerPhotos/Shachlo.png', '3', 'Hard', 15544),
(382, 25, 1, 'Греция', './images/countryFlags/Греция.png', 'Kharis Zafeiriou', 'SkyLark', '', '0000-00-00', './images/playerPhotos/SkyLark.png', '3', 'Hard', 165510),
(385, 26, 1, 'Перу', './images/countryFlags/Перу.png', 'Juan Ochoa', 'Atun', '', '0000-00-00', './images/playerPhotos/Atun.png', '1', 'Safe', 16090),
(386, 26, 1, 'Перу', './images/countryFlags/Перу.png', 'Jeremy Aguinaga', 'Jeimari', '', '0000-00-00', './images/playerPhotos/Jeimari.png', '2', 'Mid', 6400),
(388, 27, 1, 'Мексика', './images/countryFlags/Мексика.png', 'Jose Coronel', 'esk', '', '0000-00-00', './images/playerPhotos/esk.png', '2', 'Mid', 130),
(389, 27, 1, 'Мексика', './images/countryFlags/Мексика.png', 'Alejandro Moreno', 'Jano', '', '0000-00-00', './images/playerPhotos/Jano.png', '3', 'Hard', 130),
(390, 28, 1, 'США', './images/countryFlags/США.png', '&ndash;', 'AlienManaBanana', '', '0000-00-00', './images/playerPhotos/AlienManaBanana.png', '2', 'Mid', 100),
(392, 29, 1, 'США', './images/countryFlags/США.png', 'Chris Usher', 'USH', '', '0000-00-00', './images/playerPhotos/USH.png', '2', 'Mid', 6187),
(393, 29, 1, 'Перу', './images/countryFlags/Перу.png', 'Jose Andree Nicosia', 'Sword', '', '0000-00-00', './images/playerPhotos/Sword.png', '3', 'Hard', 6912),
(398, 32, 1, 'Бразилия', './images/countryFlags/Бразилия.png', 'Leonardo Santos Viana Da Guarda', 'Mandy', '', '0000-00-00', './images/playerPhotos/Mandy.png', '1', 'Safe', 5338),
(399, 32, 1, 'Бразилия', './images/countryFlags/Бразилия.png', 'Adriano Machado', '4dr', '', '0000-00-00', './images/playerPhotos/4dr.png', '2', 'Mid', 61073),
(400, 32, 1, 'Бразилия', './images/countryFlags/Бразилия.png', 'Rodrigo Lelis', 'Liposa', '', '0000-00-00', './images/playerPhotos/Liposa.png', '3', 'Hard', 32293),
(404, 33, 1, 'Австралия', './images/countryFlags/Австралия.png', 'Anathan Pham', 'ana', 'Профессиональный игрок в Dota 2. Чемпион Мира 2018 года (в составе OG).  Несмотря на то, что первые свои профессиональные игры Анатан сыграл ещё в 2013 году, он долгое время был неизвестен дота-комьюнити. После провала китайских команд на The Shanghai Major 2016 прошли крупные решафлы, и Ana оказался в составе iG, но на позиции запасного игрока. Тем не менее, иногда ему удавалось и сыграть, и он показывал неплохие результаты. В июле 2016 года он помог выиграть своей команде National Electronic Arena 2016, нанеся поражение Newbee со счётом 2-0.  В августе 2016 года неожиданно оказался в европейской команде OG, что вызвало немалый переполох на дота-сцене. Вместе с командой он стал двукратным Чемпионом турниров Major. Со временем игрок подвергался все большей критике и после TI7 покинул команду. Но дела у команды пошли еще хуже, и в июне 2018 года, накануне квалификаций к TI8 ana вернулся в OG и помог коллективу не только пройти на турнир, но и сенсационно выиграть на нём.', '1999-10-26', './images/playerPhotos/ana.png', '1', 'Hard', 2861154),
(405, 33, 1, 'Финляндия', './images/countryFlags/Финляндия.png', 'Topics Taavitsainen', 'Topson', 'Профессиональный игрок в Dota 2. Чемпион Мира 2018 года (в составе OG).  Молодой финский игрок. На про-сцене впервые засветился в коллективе SFTe-sports. Некоторое время выступал за финский микс 5 Anchors No Captain. Но до июня 2018 года практически не был известен. Именно тогда разваливающая OG пригласила его на место покинувшего команду s4. Коллектив прошел квалификации и Topson \"с места в карьер\" попадает на главный турнир года, где сенсационно берет первое место.', '0000-00-00', './images/playerPhotos/Topson.png', '2', 'Mid', 2276455),
(406, 33, 1, 'Франция', './images/countryFlags/Франция.png', 'Sebastien Debs', '7ckngMad', 'Французский профессиональный игрок в Dota 2 и тренер. Чемпион Мира 2018 года (в составе OG).  Известность и признание получил во время выступлений за Western Wolves и mTw в 2012 году. За свою карьеру француз скитался по многим средним командам и миксам, но нигде надолго не задерживался. Во времена игры за Sigma.int засветился на мировой сцене и поиграл на крупных турнирах. Из-за частой смены команд не смог добиться больших успехов на европейской сцене. Непродолжительное время играл за The Alliance.   Себастьян являлся тренером команды OG два года - с 2016 по 2018 годы. Под его руководством команда выиграла три турнира статуса Major. Сезон 2017-18 годов выдался неудачным. 7ckngMad был вынужден занять место мидера в коллективе в качестве игрока замены, а в июне 2018 года официально занял слот игрока, пересев на саппорта. На TI8 команда совершила сенсацию и, показывая яркую эмоциональную игру заняла первое место.', '1992-11-05', './images/playerPhotos/7ckngMad.png', '3', 'Safe', 2328143),
(413, 34, 1, 'Китай', './images/countryFlags/Китай.png', 'Du Peng', 'Monet', '', '0000-00-00', './images/playerPhotos/Monet.png', '1', 'Safe', 617779),
(414, 34, 1, 'Китай', './images/countryFlags/Китай.png', 'Gao Zhenxiong', 'Setsu', '', '0000-00-00', './images/playerPhotos/Setsu.png', '2', 'Mid', 19791),
(415, 34, 1, 'Китай', './images/countryFlags/Китай.png', 'Su Lei', 'Flyby', '', '0000-00-00', './images/playerPhotos/Flyby.png', '3', 'Hard', 23087),
(419, 35, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'Oc', '', '0000-00-00', './images/playerPhotos/Oc.png', '3', 'Hard', 405),
(420, 36, 1, 'Китай', './images/countryFlags/Китай.png', 'Zhou Shiyuan', 'Dust', '', '0000-00-00', './images/playerPhotos/Dust.png', '1', 'Hard', 2203),
(421, 36, 1, 'Китай', './images/countryFlags/Китай.png', 'Ni Weijie', 'ButterflyEffect', '', '0000-00-00', './images/playerPhotos/ButterflyEffect.png', '2', 'Mid', 2203),
(422, 36, 1, 'Китай', './images/countryFlags/Китай.png', 'Zhao Shungeng', 'black.z', '', '0000-00-00', './images/playerPhotos/black.z.png', '1', 'Safe', 32709),
(424, 37, 1, 'Китай', './images/countryFlags/Китай.png', 'Yang Shaohan', 'Erica', '', '0000-00-00', './images/playerPhotos/Erica.png', '1', 'Safe', 1589),
(425, 37, 1, 'Китай', './images/countryFlags/Китай.png', 'Xu Ziliang', 'Blood', '', '0000-00-00', './images/playerPhotos/Blood.png', '2', 'Mid', 576),
(428, 41, 1, 'Китай', './images/countryFlags/Китай.png', 'Liu Ningbo', 'bobo', '', '0000-00-00', './images/playerPhotos/bobo.png', '1', 'Hard', 1723),
(429, 41, 1, 'Китай', './images/countryFlags/Китай.png', 'Pan Shuaifang', 'yChen', '', '0000-00-00', './images/playerPhotos/yChen.png', '2', 'Mid', 36074),
(431, 44, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'Orion', '', '0000-00-00', './images/playerPhotos/Orion.png', '1', 'Safe', 888),
(433, 45, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'SJ', '', '0000-00-00', './images/playerPhotos/SJ.png', '1', 'Safe', 288),
(434, 45, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'ssyy', '', '0000-00-00', './images/playerPhotos/ssyy.png', '3', 'Hard', 288),
(437, 47, 1, 'Китай', './images/countryFlags/Китай.png', 'Deng Lei', 'Dstones', '', '0000-00-00', './images/playerPhotos/Dstones.png', '2', 'Mid', 11194),
(438, 47, 1, 'Китай', './images/countryFlags/Китай.png', 'Zheng Jie', 'ghost', '', '0000-00-00', './images/playerPhotos/ghost.png', '3', 'Hard', 17119),
(440, 49, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Marc Mamales', 'Marc', '', '0000-00-00', './images/playerPhotos/Marc.png', '2', 'Mid', 4240),
(443, 50, 1, 'Филиппины', './images/countryFlags/Филиппины.png', '&ndash;', 'Japoy', '', '0000-00-00', './images/playerPhotos/Japoy.png', '1', 'Safe', 774),
(444, 50, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'James Palatolon John', 'CartMaN', '', '0000-00-00', './images/playerPhotos/CartMaN.png', '2', 'Mid', 30856),
(445, 50, 1, 'Филиппины', './images/countryFlags/Филиппины.png', '&ndash;', 'Bhm', '', '0000-00-00', './images/playerPhotos/Bhm.png', '3', 'Hard', 1074),
(448, 51, 1, 'Вьетнам', './images/countryFlags/Вьетнам.png', '&ndash;', 'TrEdO', '', '0000-00-00', './images/playerPhotos/TrEdO.png', '3', 'Hard', 734),
(451, 53, 1, 'Тайланд', './images/countryFlags/Тайланд.png', 'Poomipat Trisiripanit', 'Fearless', '', '0000-00-00', './images/playerPhotos/Fearless.png', '2', 'Mid', 3523),
(452, 53, 1, 'Тайланд', './images/countryFlags/Тайланд.png', 'Kittikorn Inngoen', 'MyPro', '', '0000-00-00', './images/playerPhotos/MyPro.png', '3', 'Mid', 6931),
(455, 54, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Marc Polo Luis Fausto', 'Raven', '', '0000-00-00', './images/playerPhotos/Raven.png', '1', 'Safe', 562068),
(456, 54, 1, 'Малайзия', './images/countryFlags/Малайзия.png', 'Chai Yee Fung', 'Mushi', '', '0000-00-00', './images/playerPhotos/Mushi.png', '2', 'Mid', 683994),
(457, 54, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Rolen Andrei Gabriel Ong', 'Skemberlu', '', '0000-00-00', './images/playerPhotos/Skemberlu.png', '3', 'Hard', 39574),
(461, 56, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'John Linuel Abanto', 'Teehee', '', '0000-00-00', './images/playerPhotos/Teehee.png', '1', 'Safe', 168762),
(462, 56, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Julius Galeon', 'JG', '', '0000-00-00', './images/playerPhotos/JG.png', '2', 'Mid', 2354),
(463, 56, 1, 'Южная Африка', './images/countryFlags/Южная Африка.png', 'Charl Geldenhuys', 'Welp', '', '0000-00-00', './images/playerPhotos/Welp.png', '3', 'Hard', 1972),
(466, 57, 1, 'Тайланд', './images/countryFlags/Тайланд.png', '&ndash;', 'Nevermine', '', '0000-00-00', './images/playerPhotos/Nevermine.png', '3', 'Hard', 78),
(469, 58, 1, 'Вьетнам', './images/countryFlags/Вьетнам.png', 'Trần Duy Anh', 'Sadboy', '', '0000-00-00', './images/playerPhotos/Sadboy.png', '1', 'Safe', 100),
(470, 59, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'michiko', '', '0000-00-00', './images/playerPhotos/michiko.png', '1', 'Safe', 400),
(471, 59, 1, 'Казахстан', './images/countryFlags/Казахстан.png', '&ndash;', 'Ginger', '', '0000-00-00', './images/playerPhotos/Ginger.png', '2', 'Mid', 400),
(472, 59, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'dyson', '', '0000-00-00', './images/playerPhotos/dyson.png', '3', 'Hard', 400),
(474, 61, 1, 'Тайланд', './images/countryFlags/Тайланд.png', '&ndash;', 'Masaros', '', '0000-00-00', './images/playerPhotos/Masaros.png', '3', 'Hard', 116),
(476, 62, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Fernando Mendoza', 'Nando', '', '0000-00-00', './images/playerPhotos/Nando.png', '1', 'Safe', 44076),
(477, 62, 1, 'Филиппины', './images/countryFlags/Филиппины.png', '&ndash;', 'Van', '', '0000-00-00', './images/playerPhotos/Van.png', '3', 'Hard', 2175),
(480, 64, 1, 'Индия', './images/countryFlags/Индия.png', 'Krish Gupta', 'Moon-', '', '0000-00-00', './images/playerPhotos/Moon-.png', '2', 'Mid', 1019),
(482, 68, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'jester', '', '0000-00-00', './images/playerPhotos/jester.png', '1', 'Safe', 700),
(483, 68, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'tomato', '', '0000-00-00', './images/playerPhotos/tomato.png', '2', 'Mid', 700),
(484, 68, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'lustrous', '', '0000-00-00', './images/playerPhotos/lustrous.png', '3', 'Hard', 700),
(488, 72, 1, 'Китай', './images/countryFlags/Китай.png', 'Mo Jian', 'Veng', '', '0000-00-00', './images/playerPhotos/Veng.png', '3', 'Safe', 301),
(491, 74, 1, 'Сингапур', './images/countryFlags/Сингапур.png', '&ndash;', 'boyan', '', '0000-00-00', './images/playerPhotos/boyan.png', '1', 'Safe', 120),
(493, 75, 1, 'Малайзия', './images/countryFlags/Малайзия.png', 'Yeong Shi Jie', 'Mercury', '', '0000-00-00', './images/playerPhotos/Mercury.png', '1', 'Safe', 2171),
(494, 75, 1, 'Малайзия', './images/countryFlags/Малайзия.png', 'Chua Soon Khong', 'KaNG', '', '0000-00-00', './images/playerPhotos/KaNG.png', '3', 'Hard', 47029),
(499, 78, 1, 'Мьянма', './images/countryFlags/Мьянма.png', 'Myint Myat Zaw', 'InsaNe', '', '0000-00-00', './images/playerPhotos/InsaNe.png', '1', 'Safe', 550),
(500, 78, 1, 'Мьянма', './images/countryFlags/Мьянма.png', '&ndash;', 'Leo', '', '0000-00-00', './images/playerPhotos/Leo.png', '2', 'Mid', 550),
(501, 78, 1, 'Мьянма', './images/countryFlags/Мьянма.png', 'Aung Myat Soe ti', 'ShowT', '', '0000-00-00', './images/playerPhotos/ShowT.png', '3', 'Hard', 550),
(504, 80, 1, 'Индонезия', './images/countryFlags/Индонезия.png', '&ndash;', 'Ifr1t!', '', '0000-00-00', './images/playerPhotos/Ifr1t!.png', '1', 'Safe', 3647),
(505, 80, 1, 'Индонезия', './images/countryFlags/Индонезия.png', 'Muhammad Lutfi', 'Azur4', '', '0000-00-00', './images/playerPhotos/Azur4.png', '2', 'Mid', 3925),
(506, 80, 1, 'Индонезия', './images/countryFlags/Индонезия.png', '&ndash;', 'Vinz', '', '0000-00-00', './images/playerPhotos/Vinz.png', '3', 'Hard', 47),
(513, 81, 1, 'Сингапур', './images/countryFlags/Сингапур.png', '&ndash;', 'doubt', '', '0000-00-00', './images/playerPhotos/doubt.png', '2', 'Mid', 200),
(520, 85, 1, 'Кыргызстан', './images/countryFlags/Кыргызстан.png', 'Duulat Subankulov', 'StormC4t', '', '0000-00-00', './images/playerPhotos/StormC4t.png', '2', 'Mid', 6421),
(522, 86, 1, 'Кыргызстан', './images/countryFlags/Кыргызстан.png', 'Ilgiz Dzhunushaliev', 'NapaleoshQa', '', '0000-00-00', './images/playerPhotos/NapaleoshQa.png', '3', 'Hard', 7171),
(523, 86, 1, 'Кыргызстан', './images/countryFlags/Кыргызстан.png', 'Bektur Kulov', 'Runec', '', '0000-00-00', './images/playerPhotos/Runec.png', '2', 'Mid', 4121),
(524, 88, 1, 'Китай', './images/countryFlags/Китай.png', 'Li Zhiwen', 'ASD', '', '0000-00-00', './images/playerPhotos/ASD.png', '2', 'Mid', 51840),
(532, 107, 1, 'Малайзия', './images/countryFlags/Малайзия.png', 'Fua Hsien Wan', 'Lance', '', '0000-00-00', './images/playerPhotos/Lance.png', '1', 'Safe', 6200),
(533, 107, 1, 'Малайзия', './images/countryFlags/Малайзия.png', 'Kok Yi Liong', 'ddz', '', '0000-00-00', './images/playerPhotos/ddz.png', '2', 'Mid', 6640),
(534, 107, 1, 'Малайзия', './images/countryFlags/Малайзия.png', '&ndash;', 'Bored', '', '0000-00-00', './images/playerPhotos/Bored.png', '3', 'Hard', 555),
(536, 109, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Justine Ryan Evangelista Grimaldo', 'Tino', '', '0000-00-00', './images/playerPhotos/Tino.png', '1', 'Safe', 4082),
(537, 109, 1, 'Малайзия', './images/countryFlags/Малайзия.png', 'Hiew Teck Yoong', 'AlaCrity', '', '0000-00-00', './images/playerPhotos/AlaCrity.png', '2', 'Mid', 7790),
(539, 112, 1, 'Сингапур', './images/countryFlags/Сингапур.png', 'Leow Chen Kai', 'FiXeRs', '', '0000-00-00', './images/playerPhotos/FiXeRs.png', '2', 'Mid', 400),
(540, 112, 1, 'Сингапур', './images/countryFlags/Сингапур.png', 'Yaowen Teo', 'Tudi', '', '0000-00-00', './images/playerPhotos/Tudi.png', '3', 'Hard', 7201),
(543, 113, 1, 'Малайзия', './images/countryFlags/Малайзия.png', 'Lee Jia He', 'Chidori~', '', '0000-00-00', './images/playerPhotos/Chidori~.png', '1', 'Safe', 510),
(544, 114, 1, 'Тайланд', './images/countryFlags/Тайланд.png', '&ndash;', 'Earnzamax', '', '0000-00-00', './images/playerPhotos/Earnzamax.png', '2', 'Mid', 116),
(551, 117, 1, 'Тайланд', './images/countryFlags/Тайланд.png', 'Patipat Nussayateerasarn', 'Peter', '', '0000-00-00', './images/playerPhotos/Peter.png', '1', 'Safe', 542),
(552, 117, 1, 'Тайланд', './images/countryFlags/Тайланд.png', 'Posathorn Kasemsawat', 'SoLotic', '', '0000-00-00', './images/playerPhotos/SoLotic.png', '3', 'Hard', 3327),
(554, 118, 1, 'Тайланд', './images/countryFlags/Тайланд.png', '&ndash;', 'mn', '', '0000-00-00', './images/playerPhotos/mn.png', '2', 'Mid', 348),
(560, 120, 1, 'Австралия', './images/countryFlags/Австралия.png', '&ndash;', 'idealism', '', '0000-00-00', './images/playerPhotos/idealism.png', '1', 'Hard', 2054),
(561, 120, 1, 'Австралия', './images/countryFlags/Австралия.png', 'Daniel Arnous', 'balla', '', '0000-00-00', './images/playerPhotos/balla.png', '1', 'Safe', 4065),
(565, 121, 1, 'Австралия', './images/countryFlags/Австралия.png', '&ndash;', 'Lon', '', '0000-00-00', './images/playerPhotos/Lon.png', '3', 'Hard', 45),
(705, 3, 1, 'Австралия', './images/countryFlags/Австралия.png', '&ndash;', 'Poyo', '', '0000-00-00', './images/playerPhotos/Poyo.png', '4-5', 'Hard', 292),
(706, 4, 1, 'Китай', './images/countryFlags/Китай.png', 'Pan Yi', 'Fade', '', '0000-00-00', './images/playerPhotos/Fade.png', '4-5', 'Safe', 312768),
(707, 5, 1, 'Беларусь', './images/countryFlags/Беларусь.png', 'Artem Barshack', 'fng', '', '0000-00-00', './images/playerPhotos/fng.png', '4-5', 'Safe', 463184),
(708, 5, 1, 'Россия', './images/countryFlags/Россия.png', 'Alexander Hmelevskoy', 'Immersion', '', '0000-00-00', './images/playerPhotos/Immersion.png', '4-5', 'Hard', 63350),
(709, 6, 1, 'Македония', './images/countryFlags/Македония.png', 'Martin Sazdov', 'Saksa', '', '0000-00-00', './images/playerPhotos/Saksa.png', '4-5', 'Hard', 923900),
(710, 7, 1, 'Китай', './images/countryFlags/Китай.png', 'Xu Linsen', 'fy', '', '0000-00-00', './images/playerPhotos/fy.png', '4-5', 'Hard', 2136297),
(711, 7, 1, 'Малайзия', './images/countryFlags/Малайзия.png', 'Yap Jian Wei', 'xNova', '', '0000-00-00', './images/playerPhotos/xNova.png', '4-5', 'Safe', 1179741),
(712, 8, 1, 'Китай', './images/countryFlags/Китай.png', 'Gao Tianpeng', 'Dogf1ghts', '', '0000-00-00', './images/playerPhotos/Dogf1ghts.png', '4-5', 'Hard', 189450),
(713, 8, 1, 'Малайзия', './images/countryFlags/Малайзия.png', 'Chan Chon Kien', 'Oli', '', '0000-00-00', './images/playerPhotos/Oli.png', '4-5', 'Safe', 28990),
(714, 9, 1, 'Германия', './images/countryFlags/Германия.png', 'Kuro Salehi Takhasomi', 'KuroKy', 'Профессиональный игрок в Dota 2. Чемпион Мира 2017 года (в составе Team Liquid). \n\nНачал свою карьеру ещё во времена Warcraft. В 2009 году его коллектив Kingsurf.int был признан лучшей командой года, а сам KuroKy — лучшим керри.  В Dota 2 KuroKy вошёл в составе команды GosuGamers. На The International 2011 она заняла последнее место, после чего приказала долго жить. \n\nЗа 2012 год успел поиграть в Virtus.pro, в качестве замены побывал на TI2 с mousesports в роли саппорта, а позже стал полноправным игроком mouz, но уже в роли керри.  В феврале 2013 года немецкий легионер подписал контракт с украинской организацией Natus Vincere. Вместе с командой он пережил новый взлёт. Его сигнатурного Rubick соперник нередко отправлял в респект-бан. На TI3 Na`Vi дошли до финала, где в драматичном матче всё же уступили Alliance. Пошли слухи о распаде команды, однако игроки продолжили выступать вместе. Постепенно уровень игры падал, всё чаще можно было услышать критику в сторону KuroKy. Некоторые аналитики считали, что Na`Vi нужно избавиться от европейского легионера по причине языкового барьера. После неудачного выступления на TI4 Куро покинул команду. \n\nСезон 2014-2015 года он провёл в звёздном миксе Team Secret. Там KuroKy снова попробовал себя в роли керри, но позже ему пришлось вернуться на позицию саппорта. Команда претендовала на лидерство в мировой Доте, однако на TI5 оступилась и заняла только 7-8 место. Выяснилось, что к началу турнира в команде был разлад между KuroKy и эмоциональным молодым керри Arteezy. После TI5 конфликт вылился наружу. Игроки сказали друг о друге много нелестных слов в социальных сетях и оба покинули команду. Ходили слухи, что KuroKy хочет собрать немецкий стак игроков, однако в его новом коллективе 5Jungz были игроки разных национальностей. Команда показывала неплохие результаты, и 9 октября 2015 года организация Team Liquid подписала с ней контракт.\n\nПод новым тегом коллектив одержал много побед, дважды доходил до Финала на турнирах Major, и, наконец, взял \"золото\" на главном турнире 2017 года - The International.', '1992-10-28', './images/playerPhotos/KuroKy.png', '4-5', 'Hard', 3994205),
(715, 9, 1, 'Ливан', './images/countryFlags/Ливан.png', 'Maroun Merhej', 'GH', '', '0000-00-00', './images/playerPhotos/GH.png', '4-5', 'Hard', 3147980),
(716, 10, 1, 'Дания', './images/countryFlags/Дания.png', 'Andreas Franck Nielsen', 'Cr1t', '', '0000-00-00', './images/playerPhotos/Cr1t.png', '4-5', 'Hard', 1619731),
(717, 10, 1, 'Израиль', './images/countryFlags/Израиль.png', 'Tal Aizik', 'Fly', '', '0000-00-00', './images/playerPhotos/Fly.png', '4-5', 'Safe', 1995035),
(718, 12, 1, 'Швеция', './images/countryFlags/Швеция.png', 'Aydin Sarkohi', 'iNSaNiA', '', '0000-00-00', './images/playerPhotos/iNSaNiA.png', '4-5', 'Hard', 30222),
(719, 13, 1, 'Швеция', './images/countryFlags/Швеция.png', 'Johan Åström', 'pieliedie', '', '0000-00-00', './images/playerPhotos/pieliedie.png', '4-5', 'Safe', 650164),
(720, 13, 1, 'США', './images/countryFlags/США.png', 'Arif Anwar', 'MSS', '', '0000-00-00', './images/playerPhotos/MSS.png', '4-5', 'Safe', 295227),
(721, 15, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Nico Barcelon', 'Eyyou', '', '0000-00-00', './images/playerPhotos/Eyyou.png', '4-5', 'Safe', 221031),
(722, 15, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Timothy Randrup', 'Tims', '', '0000-00-00', './images/playerPhotos/Tims.png', '4-5', 'Hard', 470668),
(723, 16, 1, 'Россия', './images/countryFlags/Россия.png', 'Alexei Berezin', 'Solo', '', '0000-00-00', './images/playerPhotos/Solo.png', '4-5', 'Safe', 1576331),
(724, 16, 1, 'Россия', './images/countryFlags/Россия.png', 'Vladimir Nikogosyan', 'RodjER', '', '0000-00-00', './images/playerPhotos/RodjER.png', '4-5', 'Roaming', 1128009),
(725, 17, 1, 'Вьетнам', './images/countryFlags/Вьетнам.png', 'Huỳnh Hữu Nghĩa', 'Magical', '', '0000-00-00', './images/playerPhotos/Magical.png', '4-5', 'Safe', 200),
(726, 17, 1, 'Россия', './images/countryFlags/Россия.png', 'Akbar Butaev', 'SoNNeikO', '', '0000-00-00', './images/playerPhotos/SoNNeikO.png', '4-5', 'Safe', 207200),
(727, 17, 1, 'Кыргызстан', './images/countryFlags/Кыргызстан.png', 'Bakyt Emilzhanov', 'Zayac', '', '0000-00-00', './images/playerPhotos/Zayac.png', '4-5', 'Hard', 28501),
(728, 18, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'G!', '', '0000-00-00', './images/playerPhotos/G!.png', '4-5', 'Hard', 291),
(729, 18, 1, 'Россия', './images/countryFlags/Россия.png', 'Ivan Skorokhod', 'VANSKOR', '', '0000-00-00', './images/playerPhotos/VANSKOR.png', '4-5', 'Safe', 117574),
(730, 18, 1, 'Россия', './images/countryFlags/Россия.png', 'Fedor Rusihin', 'velheor', '', '0000-00-00', './images/playerPhotos/velheor.png', '4-5', 'Roaming', 11687),
(731, 19, 1, 'Украина', './images/countryFlags/Украина.png', 'Danil Shehovtsov', 'Bignum', '', '0000-00-00', './images/playerPhotos/Bignum.png', '4-5', 'Hard', 20514),
(732, 19, 1, 'Казахстан', './images/countryFlags/Казахстан.png', 'Vladislav Ivashchenko', 'BLACKARXANGEL', '', '0000-00-00', './images/playerPhotos/BLACKARXANGEL.png', '4-5', 'Safe', 4430),
(733, 20, 1, 'Россия', './images/countryFlags/Россия.png', 'Renat Abdullin', 'KingR', '', '0000-00-00', './images/playerPhotos/KingR.png', '4-5', 'Safe', 87411),
(734, 20, 1, 'Россия', './images/countryFlags/Россия.png', 'Oleg Kalembet', 'sayuw', '', '0000-00-00', './images/playerPhotos/sayuw.png', '4-5', 'Hard', 9099),
(735, 21, 1, 'Россия', './images/countryFlags/Россия.png', 'Churochkin Alexander', 'NoFear', '', '0000-00-00', './images/playerPhotos/NoFear.png', '4-5', 'Safe', 172242),
(736, 21, 1, 'Украина', './images/countryFlags/Украина.png', 'Ilya Ilyuk', 'Lil', '', '0000-00-00', './images/playerPhotos/Lil.png', '4-5', 'Hard', 892804),
(737, 22, 1, 'Швеция', './images/countryFlags/Швеция.png', 'Adrian Kryeziu', 'Era', '', '0000-00-00', './images/playerPhotos/Era.png', '4-5', 'Safe', 80038),
(738, 22, 1, 'Швеция', './images/countryFlags/Швеция.png', 'Simon Haag', 'Handsken', '', '0000-00-00', './images/playerPhotos/Handsken.png', '4-5', 'Hard', 172037),
(739, 24, 1, 'Швеция', './images/countryFlags/Швеция.png', 'Jerry Lundkvist', 'EGM', '', '0000-00-00', './images/playerPhotos/EGM.png', '4-5', 'Hard', 580415),
(740, 24, 1, 'Россия', './images/countryFlags/Россия.png', 'Yaroslav Naidenov', 'Miposhka', '', '0000-00-00', './images/playerPhotos/Miposhka.png', '4-5', 'Safe', 211278),
(741, 25, 1, 'Греция', './images/countryFlags/Греция.png', 'Tasos Michailidis', 'Focus', '', '0000-00-00', './images/playerPhotos/Focus.png', '4-5', 'Hard', 30600),
(742, 25, 1, 'Греция', './images/countryFlags/Греция.png', 'Giorgos Giannakopoulos', 'SsaSpartan', '', '0000-00-00', './images/playerPhotos/SsaSpartan.png', '4-5', 'Safe', 165975),
(743, 26, 1, 'Перу', './images/countryFlags/Перу.png', 'Sergio Toribio', 'Prada', '', '0000-00-00', './images/playerPhotos/Prada.png', '4-5', 'Safe', 5452),
(744, 28, 1, 'США', './images/countryFlags/США.png', 'Jason Teodosio', 'Jason', '', '0000-00-00', './images/playerPhotos/Jason.png', '4-5', 'Safe', 4573),
(745, 29, 1, 'Перу', './images/countryFlags/Перу.png', 'Christian Cruz', 'Accel', '', '0000-00-00', './images/playerPhotos/Accel.png', '4-5', 'Safe', 81738),
(746, 29, 1, 'Перу', './images/countryFlags/Перу.png', 'Joel Mori Ozambela', 'MoOz', '', '0000-00-00', './images/playerPhotos/MoOz.png', '4-5', 'Hard', 11170),
(747, 32, 1, 'Бразилия', './images/countryFlags/Бразилия.png', 'Thiago Cordeiro', 'Thiolicor', '', '0000-00-00', './images/playerPhotos/Thiolicor.png', '4-5', 'Hard', 23293),
(748, 33, 1, 'Дания', './images/countryFlags/Дания.png', 'Johan Sundstein', 'N0tail', 'Профессиональный игрок в Dota 2. Чемпион Мира 2018 года (в составе OG).  Один из самых ярких и харизматичных киберспортсменов в Европе. Кроме того, Юхан способен отыгрывать на любой роли и был одним из первых на про-сцене, кто стал играть на Meepo.  n0tail познакомился с Dota 2 в 2012 году, когда перешёл в неё из Heroes of Newerth вместе с командой Fnatic. Команда уверенно держалась наверху Дота-сцены в Европе. Игроки нередко входили в число лучших на турнирах, а на Thor Open 2012 даже обошли nTh, взяв первое «золото». Самый стабильный состав в истории Dota 2 распался в августе 2014 года.  Присоединился к новому миксу, состоящему из звёзд — Team Secret. И хотя команда играла неплохо, в коллективе назрели противоречия. Юхан покинул его в декабре 2014 и остаток сезона доиграл в Cloud9. С ними же он поехал на TI5, где остановился на 9-12 месте. В августе 2015 года решил собрать свою команду, которая скоро получила название OG. Он объединил усилия с бывшим тиммейтом Fly и дополнил коллектив опытными, но не титулованными игроками.  В ноябре 2015 OG стала первой командой, победившей на Major-турнире от Valve, и в дальнейшем трижды повторяла это достижение. На TI8, несмотря на трудный и драматичный сезон, OG смогла совершить невероятное и стала Чемпионом Мира.', '1993-10-08', './images/playerPhotos/N0tail.png', '4-5', 'Hard', 3676192),
(749, 33, 1, 'Финляндия', './images/countryFlags/Финляндия.png', 'Jesse Vainikka', 'JerAx', 'Профессиональный игрок в Dota 2. Чемпион Мира 2018 года (в составе OG).  Ранее JerAx выступал в дисциплине Heroes Of Newerth, однако после возвращения из армии он решил сменить дисциплину на Dota 2. Киберспортсмен вошёл в состав финского полупрофессионального коллектива Rat in the dark. В марте 2013 года Джесси заметил известный игрок SingSing и пригласил в команду QPAD Red Pandas, где молодой саппорт играл до декабря. После этого JerAx почти на год покинул профессиональную сцену.  Возвращение произошло в сентябре 2014 года, когда Trixi, игрок распавшихся Fnatic, собрал финский микс 4Anchors. В команду вошли малоизвестные игроки, и JerAx порой приходилось брать на себя и капитанские функции. В январе 2015 года игрок возвращается к SingSing, на этот раз в команду Team Tinker. Однако взор игрока уже был нацелен на восток, в Корею, ведь быстро развивающаяся корейская сцена привлекла целый ряд легионеров разного уровня. Решил испытать свою судьбу в Корее и JerAx: он присоединился к коллективу MVP Hot6ix. Ребятам удалось пройти квалификации на TI5, но на турнире команда заняла одно из последних мест, после чего финн вернулся в Европу и вошёл в новую команду 5Jungz. 9 октября 2015 года микс был подписан Team Liquid.  Игроки провели неплохой сезон, не раз встречаясь со своими заклятыми соперниками OG и стали одной из сильнейших команд Европы. Триумфальная победа на EPICENTER в Москве сулила хороший результат на главном турнире года. Но на TI6 слаженный механизм дал сбой, и Team Liquid с трудом вырывая победы в матчах смогли дойти до 7-8 места.  После турнира JerAx покинул команду и перешёл в стан своих \"врагов\" - OG. В новом коллективе он стал двукратным Чемпионом турниров Major. В сезоне 2017-18 году коллектив вступил в полосу кризиса и пережил несколько тяжелых решафлов. Тем не менее, JerAx не бросил коллектив в трудный период. OG не без труда прошла на TI8, и сенсационно одержала победу на турнире.', '1992-05-07', './images/playerPhotos/JerAx.png', '4-5', 'Hard', 3327898),
(750, 34, 1, 'Китай', './images/countryFlags/Китай.png', 'Zhang Zhicheng', 'LaNm', '', '0000-00-00', './images/playerPhotos/LaNm.png', '4-5', 'Hard', 850947),
(751, 36, 1, 'Китай', './images/countryFlags/Китай.png', 'Li Zimeng', 'mianmian', '', '0000-00-00', './images/playerPhotos/mianmian.png', '4-5', 'Hard', 2203),
(752, 37, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'kui', '', '0000-00-00', './images/playerPhotos/kui.png', '4-5', 'Hard', 576),
(753, 39, 1, 'Китай', './images/countryFlags/Китай.png', 'Fu Bin', 'Q', '', '0000-00-00', './images/playerPhotos/Q.png', '4-5', 'Safe', 1067820),
(754, 43, 1, 'Малайзия', './images/countryFlags/Малайзия.png', 'Law Chee Hoong', 'Nj', '', '0000-00-00', './images/playerPhotos/Nj.png', '4-5', 'Hard', 2668),
(755, 44, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'detachment', '', '0000-00-00', './images/playerPhotos/detachment.png', '4-5', 'Hard', 1753),
(756, 45, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'NeaR', '', '0000-00-00', './images/playerPhotos/NeaR.png', '4-5', 'Safe', 4917),
(757, 46, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'Flecher', '', '0000-00-00', './images/playerPhotos/Flecher.png', '4-5', 'Safe', 725),
(758, 48, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'QAZ', '', '0000-00-00', './images/playerPhotos/QAZ.png', '4-5', 'Hard', 288),
(759, 49, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Job Real Ramos', 'jobeeEZy', '', '0000-00-00', './images/playerPhotos/jobeeEZy.png', '4-5', 'Hard', 150),
(760, 49, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Ralph Richard Peñano', 'RR', '', '0000-00-00', './images/playerPhotos/RR.png', '4-5', 'Hard', 52559),
(761, 50, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Kimuel Rodis', 'Kim0', '', '0000-00-00', './images/playerPhotos/Kim0.png', '4-5', 'Safe', 56891),
(762, 50, 1, 'Филиппины', './images/countryFlags/Филиппины.png', '&ndash;', 'Yaha', '', '0000-00-00', './images/playerPhotos/Yaha.png', '4-5', 'Hard', 900),
(763, 51, 1, 'Вьетнам', './images/countryFlags/Вьетнам.png', 'Nguyễn Châu Lôi', 'Yasy', '', '0000-00-00', './images/playerPhotos/Yasy.png', '4-5', 'Hard', 534),
(764, 51, 1, 'Вьетнам', './images/countryFlags/Вьетнам.png', 'Vương Thiện Tài', 'SeeL', '', '0000-00-00', './images/playerPhotos/SeeL.png', '4-5', 'Safe', 1481),
(765, 53, 1, 'Тайланд', './images/countryFlags/Тайланд.png', 'Anurat Praianun', 'Boombell', '', '0000-00-00', './images/playerPhotos/Boombell.png', '4-5', 'Hard', 4631),
(766, 53, 1, 'Тайланд', './images/countryFlags/Тайланд.png', 'Peerapat Butta', 'Tigger', '', '0000-00-00', './images/playerPhotos/Tigger.png', '4-5', 'Safe', 430),
(767, 54, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Prieme Ejay Banquil', 'PlayHard', '', '0000-00-00', './images/playerPhotos/PlayHard.png', '4-5', 'Safe', 18840),
(768, 54, 1, 'Индонезия', './images/countryFlags/Индонезия.png', 'Kenny Deo', 'Xepher', '', '0000-00-00', './images/playerPhotos/Xepher.png', '4-5', 'Hard', 38767),
(769, 55, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Marvin Rushton', 'Boombacs', '', '0000-00-00', './images/playerPhotos/Boombacs.png', '4-5', 'Hard', 17879),
(770, 56, 1, 'Дания', './images/countryFlags/Дания.png', 'Danny Mørch Junget', 'NoiA', '', '0000-00-00', './images/playerPhotos/NoiA.png', '4-5', 'Safe', 105093),
(771, 56, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Frederico Mampusti', 'Derp', '', '0000-00-00', './images/playerPhotos/Derp.png', '4-5', 'Hard', 1972),
(772, 57, 1, 'Малайзия', './images/countryFlags/Малайзия.png', 'Ahmad Syazwan Bin Anuar', 'ADTR', '', '0000-00-00', './images/playerPhotos/ADTR.png', '4-5', 'Safe', 1430),
(773, 57, 1, 'Тайланд', './images/countryFlags/Тайланд.png', 'Thanathorn Sriiamkoon', 'tnt', '', '0000-00-00', './images/playerPhotos/tnt.png', '4-5', 'Hard', 4512),
(774, 59, 1, 'Малайзия', './images/countryFlags/Малайзия.png', '&ndash;', 'valeska', '', '0000-00-00', './images/playerPhotos/valeska.png', '4-5', 'Safe', 400),
(776, 61, 1, 'Тайланд', './images/countryFlags/Тайланд.png', 'Supanut Chow', 'LionaX', '', '0000-00-00', './images/playerPhotos/LionaX.png', '4-5', 'Safe', 3045),
(777, 62, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Erice Guerra', 'Erice', '', '0000-00-00', './images/playerPhotos/Erice.png', '4-5', 'Hard', 3635),
(778, 62, 1, 'Филиппины', './images/countryFlags/Филиппины.png', 'Jomari Anis', 'Grimzx', '', '0000-00-00', './images/playerPhotos/Grimzx.png', '4-5', 'Safe', 10775),
(779, 65, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'jera', '', '0000-00-00', './images/playerPhotos/jera.png', '4-5', 'Safe', 15617),
(780, 68, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'cefzon', '', '0000-00-00', './images/playerPhotos/cefzon.png', '4-5', 'Hard', 700),
(781, 68, 1, 'Китай', './images/countryFlags/Китай.png', '&ndash;', 'Madeca', '', '0000-00-00', './images/playerPhotos/Madeca.png', '4-5', 'Safe', 700),
(783, 74, 1, 'Индия', './images/countryFlags/Индия.png', 'Shahab Saleha', 'Divine', '', '0000-00-00', './images/playerPhotos/Divine.png', '4-5', 'Safe', 1019),
(784, 75, 1, 'Малайзия', './images/countryFlags/Малайзия.png', 'Cheong Zhi Ying', 'czy', '', '0000-00-00', './images/playerPhotos/czy.png', '4-5', 'Safe', 1610),
(785, 75, 1, 'Малайзия', './images/countryFlags/Малайзия.png', 'Tan Kai Soon', 'TrazaM', '', '0000-00-00', './images/playerPhotos/TrazaM.png', '4-5', 'Hard', 2121),
(786, 78, 1, 'Мьянма', './images/countryFlags/Мьянма.png', '&ndash;', 'KENJI', '', '0000-00-00', './images/playerPhotos/KENJI.png', '4-5', 'Safe', 550),
(787, 78, 1, 'Мьянма', './images/countryFlags/Мьянма.png', '&ndash;', 'raprap', '', '0000-00-00', './images/playerPhotos/raprap.png', '4-5', 'Hard', 550),
(788, 80, 1, 'Индонезия', './images/countryFlags/Индонезия.png', 'Fahmi Choirul', 'Huppey', '', '0000-00-00', './images/playerPhotos/Huppey.png', '4-5', 'Hard', 3603),
(789, 80, 1, 'Индонезия', './images/countryFlags/Индонезия.png', '&ndash;', 'SPACEMAN', '', '0000-00-00', './images/playerPhotos/SPACEMAN.png', '4-5', 'Hard', 3575);
INSERT INTO `players` (`idPlayer`, `idTeam`, `idDiscipline`, `country`, `countryFlag`, `name`, `nickname`, `description`, `birthday`, `photoRef`, `idRole`, `line`, `prize`) VALUES
(790, 81, 1, 'Сингапур', './images/countryFlags/Сингапур.png', '&ndash;', 'Dian', '', '0000-00-00', './images/playerPhotos/Dian.png', '4-5', 'Safe', 200),
(791, 81, 1, 'Сингапур', './images/countryFlags/Сингапур.png', '&ndash;', 'iagger', '', '0000-00-00', './images/playerPhotos/iagger.png', '4-5', 'Hard', 200),
(792, 82, 1, 'Казахстан', './images/countryFlags/Казахстан.png', 'Ernar Urazbaev', 'Mantis', '', '0000-00-00', './images/playerPhotos/Mantis.png', '4-5', 'Safe', 2748),
(793, 86, 1, 'Китай', './images/countryFlags/Китай.png', 'Zhang Yiping', 'y`', '', '0000-00-00', './images/playerPhotos/y`.png', '4-5', 'Safe', 2014190),
(794, 98, 1, 'Австралия', './images/countryFlags/Австралия.png', '&ndash;', 'roger', '', '0000-00-00', './images/playerPhotos/roger.png', '4-5', 'Safe', 36),
(795, 106, 1, 'Вьетнам', './images/countryFlags/Вьетнам.png', 'Dương Phan Nhật Toàn', 'TenGu', '', '0000-00-00', './images/playerPhotos/TenGu.png', '4-5', 'Safe', 660),
(796, 107, 1, 'Малайзия', './images/countryFlags/Малайзия.png', 'Goh Choo Jian', 'MoZuN', '', '0000-00-00', './images/playerPhotos/MoZuN.png', '4-5', 'Safe', 6742),
(797, 109, 1, 'Малайзия', './images/countryFlags/Малайзия.png', 'Pang Jian Zhe', 'BrayaNt', '', '0000-00-00', './images/playerPhotos/BrayaNt.png', '4-5', 'Safe', 6801),
(799, 112, 1, 'Сингапур', './images/countryFlags/Сингапур.png', 'Clement Tan', 'InsidiousC', '', '0000-00-00', './images/playerPhotos/InsidiousC.png', '4-5', 'Hard', 500),
(800, 114, 1, 'Тайланд', './images/countryFlags/Тайланд.png', '&ndash;', 'reNniw', '', '0000-00-00', './images/playerPhotos/reNniw.png', '4-5', 'Hard', 348),
(801, 117, 1, 'Тайланд', './images/countryFlags/Тайланд.png', 'Kanokkorn Hirungue', 'Varen', '', '0000-00-00', './images/playerPhotos/Varen.png', '4-5', 'Hard', 1200),
(802, 118, 1, 'Тайланд', './images/countryFlags/Тайланд.png', 'Rungpetch Yuenying', 'Rpyy', '', '0000-00-00', './images/playerPhotos/Rpyy.png', '4-5', 'Roaming', 113),
(803, 118, 1, 'Тайланд', './images/countryFlags/Тайланд.png', 'Saharat Thawornsusin', 'divasa', '', '0000-00-00', './images/playerPhotos/divasa.png', '4-5', 'Hard', 61),
(804, 119, 1, 'Филиппины', './images/countryFlags/Филиппины.png', '&ndash;', 'Goaty', '', '0000-00-00', './images/playerPhotos/Goaty.png', '4-5', 'Safe', 100),
(805, 120, 1, 'Австралия', './images/countryFlags/Австралия.png', 'Phuc Nguyen', 'lordboonz', '', '0000-00-00', './images/playerPhotos/lordboonz.png', '4-5', 'Hard', 3115),
(806, 120, 1, 'Австралия', './images/countryFlags/Австралия.png', 'Cameron Thornton', 'RogerDodger', '', '0000-00-00', './images/playerPhotos/RogerDodger.png', '4-5', 'Hard', 1774),
(807, 121, 1, 'Австралия', './images/countryFlags/Австралия.png', '&ndash;', 'spag', '', '0000-00-00', './images/playerPhotos/spag.png', '4-5', 'Safe', 138),
(817, 16, 1, '', '', 'Roman Kushnarev', 'RAMZES666', '', '1999-04-25', './images/playerPhotos/Ramzes666.png', '1', '', 0);

--
-- Триггеры `players`
--
DELIMITER $$
CREATE TRIGGER `checkFields` BEFORE INSERT ON `players` FOR EACH ROW IF new.idDiscipline='' or new.nickname='' or new.name='' or new.idTeam='' THEN
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
('2', 'Mid', 1),
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
  `prize` int(11) DEFAULT NULL COMMENT 'сумма призовых',
  `description` text NOT NULL COMMENT 'описание'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `teams`
--

INSERT INTO `teams` (`idTeam`, `idDiscipline`, `name`, `logo`, `countryFlag`, `country`, `appearenceDate`, `site`, `prize`, `description`) VALUES
(1, 1, 'Secret', './images/teamLogos/Team Secret.png', './images/countryFlags/Европа.png', 'Европа', 2014, 'http://www.teamsecret.gg', 0, '  Европейская профессиональная команда в Dota 2.  Чемпион The Shanghai Major 2016, DreamLeague Season 8, Captains Draft 4.0 и DreamLeague Season 9.'),
(2, 0, 'Athletico Esports', 'images/teamLogos/Athletico Esports.png', './images/countryFlags/Австралия.png', 'Австралия', 0000, '', 10784, ''),
(3, 0, 'Dark Sided', 'images/teamLogos/Dark Sided.png', './images/countryFlags/Австралия.png', 'Австралия', 0000, '', 1093, ''),
(4, 0, 'Vici Gaming', 'images/teamLogos/Vici Gaming.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', 6524848, ''),
(5, 0, 'Gambit Esports', 'images/teamLogos/Gambit Esports.png', './images/countryFlags/Россия.png', 'Россия', 0000, '', 354300, ''),
(6, 0, 'Ninjas in Pyjamas', 'images/teamLogos/Ninjas in Pyjamas.png', './images/countryFlags/Швеция.png', 'Швеция', 0000, '', 577495, ''),
(7, 0, 'LGD Gaming', 'images/teamLogos/LGD Gaming.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', 12422278, ''),
(8, 0, 'Invictus Gaming', 'images/teamLogos/Invictus Gaming.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', 4851022, ''),
(9, 0, 'Team Liquid', 'images/teamLogos/Team Liquid.png', './images/countryFlags/Европа.png', 'Европа', 0000, '', 17769833, ''),
(10, 0, 'Evil Geniuses', 'images/teamLogos/Evil Geniuses.png', './images/countryFlags/США.png', 'США', 2011, 'http://www.evilgeniuses.net', 18219850, '  Профессиональная команда из США в Dota 2.  Чемпион The International 2015 и StarLadder i-League Invitational Season 4.'),
(12, 1, 'The Alliance', 'images/teamLogos/The Alliance.png', './images/countryFlags/Швеция.png', 'Швеция', 0000, '', 3548402, ''),
(13, 0, 'Forward Gaming', 'images/teamLogos/Forward Gaming.png', './images/countryFlags/США.png', 'США', 0000, '', 84500, ''),
(14, 0, 'Keen Gaming', 'images/teamLogos/Keen Gaming.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', 651016, ''),
(15, 0, 'TnC Predator', 'images/teamLogos/TnC Predator.png', './images/countryFlags/Филиппины.png', 'Филиппины', 0000, '', 3071033, ''),
(16, 0, 'Virtus.Pro', 'images/teamLogos/Virtus.Pro.png', './images/countryFlags/Россия.png', 'Россия', 0000, '', 8360644, ''),
(17, 0, 'Natus Vincere', 'images/teamLogos/Natus Vincere.png', './images/countryFlags/Украина.png', 'Украина', 0000, '', 4048826, ''),
(18, 0, 'Team Spirit', 'images/teamLogos/Team Spirit.png', './images/countryFlags/Россия.png', 'Россия', 0000, '', 233612, ''),
(19, 0, 'Black Hornets Gaming', 'images/teamLogos/Black Hornets Gaming.png', './images/countryFlags/Интернациональная.png', 'Интернациональная', 0000, '', NULL, ''),
(20, 0, 'Team Empire', 'images/teamLogos/Team Empire.png', './images/countryFlags/Россия.png', 'Россия', 0000, '', 1981545, ''),
(21, 0, 'Winstrike Team', 'images/teamLogos/Winstrike Team.png', './images/countryFlags/Россия.png', 'Россия', 0000, '', 383864, ''),
(22, 0, 'The Final Tribe', 'images/teamLogos/The Final Tribe.png', './images/countryFlags/Швеция.png', 'Швеция', 0000, '', 69500, ''),
(23, 0, 'Vega Squadron', 'images/teamLogos/Vega Squadron.png', './images/countryFlags/Европа.png', 'Европа', 0000, '', 490329, ''),
(24, 0, 'Team Singularity', 'images/teamLogos/Team Singularity.png', './images/countryFlags/Европа.png', 'Европа', 0000, '', 17241, ''),
(25, 0, 'SexyAsFuck', 'images/teamLogos/SexyAsFuck.png', './images/countryFlags/Греция.png', 'Греция', 0000, '', NULL, ''),
(26, 0, 'Thunder Predator', 'images/teamLogos/Thunder Predator.png', './images/countryFlags/Перу.png', 'Перу', 0000, '', 38200, ''),
(27, 0, 'Team Xolotl', 'images/teamLogos/Team Xolotl.png', './images/countryFlags/Мексика.png', 'Мексика', 0000, '', 650, ''),
(28, 0, 'WitchDoctorGG', 'images/teamLogos/WitchDoctorGG.png', './images/countryFlags/США.png', 'США', 0000, '', NULL, ''),
(29, 0, 'Gorillaz-Pride', 'images/teamLogos/Gorillaz-Pride.png', './images/countryFlags/Перу.png', 'Перу', 0000, '', 17000, ''),
(30, 0, 'Glazed Gaming', 'images/teamLogos/Glazed Gaming.png', './images/countryFlags/США.png', 'США', 0000, '', NULL, ''),
(31, 0, 'Golden Mulas', 'images/teamLogos/Golden Mulas.png', './images/countryFlags/Перу.png', 'Перу', 0000, '', NULL, ''),
(32, 0, 'paiN Gaming', 'images/teamLogos/paiN Gaming.png', './images/countryFlags/Бразилия.png', 'Бразилия', 0000, '', 629127, ''),
(33, 0, 'OG', 'images/teamLogos/OG.png', './images/countryFlags/Европа.png', 'Европа', 2015, '', 17703843, 'Европейская профессиональная команда в Dota 2.  Чемпион The International 2018, The Frankfurt Major 2015, The Manila Major 2016, The Boston Major 2016, The Kiev Major 2017 и MDL Macau.'),
(34, 0, 'Royal Never Give Up', 'images/teamLogos/Royal Never Give Up.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', 65000, ''),
(35, 0, 'EPOCH', 'images/teamLogos/EPOCH.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', NULL, ''),
(36, 0, 'iG Vitality', 'images/teamLogos/iG Vitality.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', 915053, ''),
(37, 0, 'Keen Gaming.Luminous', 'images/teamLogos/Keen Gaming.Luminous.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', 22316, ''),
(38, 0, 'Revenge Gaming', 'images/teamLogos/Revenge Gaming.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', NULL, ''),
(39, 0, 'Team Destiny', 'images/teamLogos/Team Destiny.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', NULL, ''),
(40, 0, 'Team Ethereal', 'images/teamLogos/Team Ethereal.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', NULL, ''),
(41, 0, 'Team EVER', 'images/teamLogos/Team EVER.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', 16115, ''),
(42, 0, 'Team Galaxy', 'images/teamLogos/Team Galaxy.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', NULL, ''),
(43, 0, 'Team QS', 'images/teamLogos/Team QS.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', 1440, ''),
(44, 0, 'Team Sincere', 'images/teamLogos/Team Sincere.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', 4440, ''),
(45, 0, 'Team X', 'images/teamLogos/Team X.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', 1440, ''),
(46, 0, 'Trump Gamers', 'images/teamLogos/Trump Gamers.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', NULL, ''),
(47, 0, 'TSG.JZONE.XH', 'images/teamLogos/TSG.JZONE.XH.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', 5794, ''),
(48, 0, 'Vampire Gaming', 'images/teamLogos/Vampire Gaming.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', 1440, ''),
(49, 0, 'Neon Esports', 'images/teamLogos/Neon Esports.png', './images/countryFlags/Филиппины.png', 'Филиппины', 0000, '', 34645, ''),
(50, 0, 'Execration', 'images/teamLogos/Execration.png', './images/countryFlags/Филиппины.png', 'Филиппины', 0000, '', 338482, ''),
(51, 0, '496 Production', 'images/teamLogos/496 Production.png', './images/countryFlags/Вьетнам.png', 'Вьетнам', 0000, '', 3170, ''),
(52, 0, 'LFS.ph', 'images/teamLogos/LFS.ph.png', './images/countryFlags/Филиппины.png', 'Филиппины', 0000, '', NULL, ''),
(53, 0, 'Alpha Red', 'images/teamLogos/Alpha Red.png', './images/countryFlags/Тайланд.png', 'Тайланд', 0000, '', 21804, ''),
(54, 0, 'Geek Fam', 'images/teamLogos/Geek Fam.png', './images/countryFlags/Малайзия.png', 'Малайзия', 0000, '', 132131, ''),
(55, 0, 'Team Adroit', 'images/teamLogos/Team Adroit.png', './images/countryFlags/Филиппины.png', 'Филиппины', 0000, '', NULL, ''),
(56, 0, 'Exclamation Mark', 'images/teamLogos/Exclamation Mark.png', './images/countryFlags/Тайланд.png', 'Тайланд', 0000, '', 9862, ''),
(57, 0, 'MSCerberus', 'images/teamLogos/MSCerberus.png', './images/countryFlags/Тайланд.png', 'Тайланд', 0000, '', NULL, ''),
(58, 0, 'SEVEN SEEDS', 'images/teamLogos/SEVEN SEEDS.png', './images/countryFlags/Вьетнам.png', 'Вьетнам', 0000, '', NULL, ''),
(59, 0, 'Dragon Gaming', 'images/teamLogos/Dragon Gaming.png', './images/countryFlags/Малайзия.png', 'Малайзия', 0000, '', 2000, ''),
(60, 0, 'Team Edition', 'images/teamLogos/Team Edition.png', './images/countryFlags/Малайзия.png', 'Малайзия', 0000, '', NULL, ''),
(61, 0, 'Buriram United', 'images/teamLogos/Buriram United.png', './images/countryFlags/Тайланд.png', 'Тайланд', 0000, '', NULL, ''),
(62, 0, 'Cignal Ultra', 'images/teamLogos/Cignal Ultra.png', './images/countryFlags/Филиппины.png', 'Филиппины', 0000, '', 8877, ''),
(63, 0, 'Poseidon.Esports', 'images/teamLogos/Poseidon.Esports.png', './images/countryFlags/Филиппины.png', 'Филиппины', 0000, '', NULL, ''),
(64, 0, 'Avalon Gaming', 'images/teamLogos/Avalon Gaming.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', 10366, ''),
(65, 0, 'Death Squad', 'images/teamLogos/Death Squad.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', NULL, ''),
(66, 0, 'Hot Pot Brothers', 'images/teamLogos/Hot Pot Brothers.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', NULL, ''),
(67, 0, 'Team Authentic', 'images/teamLogos/Team Authentic.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', NULL, ''),
(68, 0, 'Photon Gaming', 'images/teamLogos/Photon Gaming.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', 3500, ''),
(69, 0, 'Proud Trooper', 'images/teamLogos/Proud Trooper.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', NULL, ''),
(70, 0, 'Sun-Rise', 'images/teamLogos/Sun-Rise.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', NULL, ''),
(71, 0, 'Speed Gaming', 'images/teamLogos/Speed Gaming.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', NULL, ''),
(72, 0, 'Zeus Gaming', 'images/teamLogos/Zeus Gaming.png', './images/countryFlags/Китай.png', 'Китай', 0000, '', NULL, ''),
(73, 0, 'AOES.K2SURF', 'images/teamLogos/AOES.K2SURF.png', './images/countryFlags/Малайзия.png', 'Малайзия', 0000, '', NULL, ''),
(74, 0, 'Chunky Monkeys', 'images/teamLogos/Chunky Monkeys.png', './images/countryFlags/Сингапур.png', 'Сингапур', 0000, '', NULL, ''),
(75, 0, 'Unicorn', 'images/teamLogos/Unicorn.png', './images/countryFlags/Малайзия.png', 'Малайзия', 0000, '', NULL, ''),
(76, 0, 'King Panda Gaming', 'images/teamLogos/King Panda Gaming.png', './images/countryFlags/Мьянма.png', 'Мьянма', 0000, '', NULL, ''),
(77, 0, 'Tiny Airlines', 'images/teamLogos/Tiny Airlines.png', './images/countryFlags/Малайзия.png', 'Малайзия', 0000, '', NULL, ''),
(78, 0, 'ReckoninG Esports', 'images/teamLogos/ReckoninG Esports.png', './images/countryFlags/Мьянма.png', 'Мьянма', 0000, '', 5094, ''),
(79, 0, 'PondokGaming Orca', 'images/teamLogos/PondokGaming Orca.png', './images/countryFlags/Индонезия.png', 'Индонезия', 0000, '', NULL, ''),
(80, 0, 'PG.Barracx', 'images/teamLogos/PG.Barracx.png', './images/countryFlags/Индонезия.png', 'Индонезия', 0000, '', 37640, ''),
(81, 0, 'Lamb Warrior', 'images/teamLogos/Lamb Warrior.png', './images/countryFlags/Сингапур.png', 'Сингапур', 0000, '', NULL, ''),
(82, 0, 'MAGIC HANDS', 'images/teamLogos/MAGIC HANDS.png', './images/countryFlags/Россия.png', 'Россия', 0000, '', NULL, ''),
(83, 0, 'Lightning strikes', 'images/teamLogos/Lightning strikes.png', './images/countryFlags/Россия.png', 'Россия', 0000, '', NULL, ''),
(84, 0, 'Frendly Team', 'images/teamLogos/Frendly Team.png', './images/countryFlags/Россия.png', 'Россия', 0000, '', NULL, ''),
(85, 0, 'uchiha', 'images/teamLogos/uchiha.png', './images/countryFlags/Кыргызстан.png', 'Кыргызстан', 0000, '', NULL, ''),
(86, 0, 'x@x@x@x@x@x@', 'images/teamLogos/x@x@x@x@x@x@.png', './images/countryFlags/Кыргызстан.png', 'Кыргызстан', 0000, '', NULL, ''),
(87, 0, 'nRa+4', 'images/teamLogos/nRa+4.png', './images/countryFlags/Кыргызстан.png', 'Кыргызстан', 0000, '', NULL, ''),
(88, 0, 'Darling', 'images/teamLogos/Darling.png', './images/countryFlags/Кыргызстан.png', 'Кыргызстан', 0000, '', NULL, ''),
(89, 0, 'Оливье', 'images/teamLogos/Оливье.png', './images/countryFlags/Кыргызстан.png', 'Кыргызстан', 0000, '', NULL, ''),
(90, 0, 'ALBARSTY GAMING', 'images/teamLogos/ALBARSTY GAMING.png', './images/countryFlags/Кыргызстан.png', 'Кыргызстан', 0000, '', NULL, ''),
(91, 0, 'Kyrgyzcha', 'images/teamLogos/Kyrgyzcha.png', './images/countryFlags/Кыргызстан.png', 'Кыргызстан', 0000, '', NULL, ''),
(92, 0, 'kastrol+4', 'images/teamLogos/kastrol+4.png', './images/countryFlags/Кыргызстан.png', 'Кыргызстан', 0000, '', NULL, ''),
(93, 0, 'MMR ASSASSIN', 'images/teamLogos/MMR ASSASSIN.png', './images/countryFlags/Кыргызстан.png', 'Кыргызстан', 0000, '', NULL, ''),
(94, 0, 'beeline.kg', 'images/teamLogos/beeline.kg.png', './images/countryFlags/Кыргызстан.png', 'Кыргызстан', 0000, '', NULL, ''),
(95, 0, 'ONE PUNCH MANS', 'images/teamLogos/ONE PUNCH MANS.png', './images/countryFlags/Кыргызстан.png', 'Кыргызстан', 0000, '', NULL, ''),
(96, 0, 'Artwaga', 'images/teamLogos/Artwaga.png', './images/countryFlags/Кыргызстан.png', 'Кыргызстан', 0000, '', NULL, ''),
(97, 0, 'Pizza', 'images/teamLogos/Pizza.png', './images/countryFlags/Кыргызстан.png', 'Кыргызстан', 0000, '', NULL, ''),
(98, 0, 'Secretniye', 'images/teamLogos/Secretniye.png', './images/countryFlags/Кыргызстан.png', 'Кыргызстан', 0000, '', NULL, ''),
(99, 0, 'Team Enslevers', 'images/teamLogos/Team Enslevers.png', './images/countryFlags/Кыргызстан.png', 'Кыргызстан', 0000, '', NULL, ''),
(100, 0, 'Luckily+4', 'images/teamLogos/Luckily+4.png', './images/countryFlags/Кыргызстан.png', 'Кыргызстан', 0000, '', NULL, ''),
(101, 0, 'NoMidas', 'images/teamLogos/NoMidas.png', './images/countryFlags/Вьетнам.png', 'Вьетнам', 0000, '', NULL, ''),
(102, 0, '23CreativeVN', 'images/teamLogos/23CreativeVN.png', './images/countryFlags/Вьетнам.png', 'Вьетнам', 0000, '', NULL, ''),
(103, 0, 'StarsBoba Young', 'images/teamLogos/StarsBoba Young.png', './images/countryFlags/Вьетнам.png', 'Вьетнам', 0000, '', NULL, ''),
(104, 0, 'Pango Gaming', 'images/teamLogos/Pango Gaming.png', './images/countryFlags/Вьетнам.png', 'Вьетнам', 0000, '', NULL, ''),
(105, 0, 'Sleepy Ash', 'images/teamLogos/Sleepy Ash.png', './images/countryFlags/Вьетнам.png', 'Вьетнам', 0000, '', NULL, ''),
(106, 0, 'Super Saiyan God', 'images/teamLogos/Super Saiyan God.png', './images/countryFlags/Вьетнам.png', 'Вьетнам', 0000, '', NULL, ''),
(107, 0, 'Flower Gaming', 'images/teamLogos/Flower Gaming.png', './images/countryFlags/Малайзия.png', 'Малайзия', 0000, '', NULL, ''),
(108, 0, 'Team Lagenda', 'images/teamLogos/Team Lagenda.png', './images/countryFlags/Малайзия.png', 'Малайзия', 0000, '', NULL, ''),
(109, 0, 'Umbrella Academy', 'images/teamLogos/Umbrella Academy.png', './images/countryFlags/Малайзия.png', 'Малайзия', 0000, '', NULL, ''),
(110, 0, 'P1 Gaming', 'images/teamLogos/P1 Gaming.png', './images/countryFlags/Малайзия.png', 'Малайзия', 0000, '', NULL, ''),
(111, 0, 'Junior Gaming', 'images/teamLogos/Junior Gaming.png', './images/countryFlags/Малайзия.png', 'Малайзия', 0000, '', NULL, ''),
(112, 0, 'Team X Singapore', 'images/teamLogos/Team X Singapore.png', './images/countryFlags/Сингапур.png', 'Сингапур', 0000, '', NULL, ''),
(113, 0, 'Team DotaHero', 'images/teamLogos/Team DotaHero.png', './images/countryFlags/Малайзия.png', 'Малайзия', 0000, '', NULL, ''),
(114, 0, '5iwns', 'images/teamLogos/5iwns.png', './images/countryFlags/Тайланд.png', 'Тайланд', 0000, '', NULL, ''),
(115, 0, 'Cipher', 'images/teamLogos/Cipher.png', './images/countryFlags/Тайланд.png', 'Тайланд', 0000, '', NULL, ''),
(116, 0, 'Xunwu Teamwork', 'images/teamLogos/Xunwu Teamwork.png', './images/countryFlags/Тайланд.png', 'Тайланд', 0000, '', NULL, ''),
(117, 0, 'Astro Esports', 'images/teamLogos/Astro Esports.png', './images/countryFlags/Тайланд.png', 'Тайланд', 0000, '', NULL, ''),
(118, 0, 'LYNX TH', 'images/teamLogos/LYNX TH.png', './images/countryFlags/Тайланд.png', 'Тайланд', 0000, '', NULL, ''),
(119, 0, 'Bren Epro', 'images/teamLogos/Bren Epro.png', './images/countryFlags/Филиппины.png', 'Филиппины', 0000, '', NULL, ''),
(120, 0, '5pd', 'images/teamLogos/5pd.png', './images/countryFlags/Австралия.png', 'Австралия', 0000, '', NULL, ''),
(121, 0, 'Blue Cactus', 'images/teamLogos/Blue Cactus.png', './images/countryFlags/Австралия.png', 'Австралия', 0000, '', NULL, '');

-- --------------------------------------------------------

--
-- Структура таблицы `tournamentmembers`
--

CREATE TABLE `tournamentmembers` (
  `idRecord` int(11) NOT NULL COMMENT 'id записи',
  `idTournament` int(11) NOT NULL COMMENT 'id турнира',
  `idTeam` int(11) NOT NULL COMMENT 'id команды',
  `invited` varchar(45) DEFAULT NULL COMMENT 'приглашен или прошел квалы'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `tournamentmembers`
--

INSERT INTO `tournamentmembers` (`idRecord`, `idTournament`, `idTeam`, `invited`) VALUES
(1, 5, 4, 'Direct Invite'),
(2, 5, 5, 'Direct Invite'),
(3, 5, 6, 'Direct Invite'),
(4, 5, 7, 'Direct Invite'),
(5, 5, 8, 'Dirrect Invite'),
(6, 5, 9, 'Direct Invite'),
(7, 5, 10, 'Direct Invite'),
(8, 5, 12, 'Europe Qualifier'),
(9, 5, 13, 'North America Qualifier'),
(10, 5, 14, 'China Qualifier'),
(11, 5, 15, 'Southeast Asia Qualifier'),
(12, 9, 16, NULL),
(13, 9, 17, NULL),
(14, 9, 10, NULL),
(15, 9, 18, NULL),
(16, 10, 19, NULL),
(17, 10, 20, NULL),
(18, 10, 21, NULL),
(19, 10, 22, NULL),
(20, 10, 23, NULL),
(21, 10, 24, NULL),
(22, 10, 25, NULL),
(23, 13, 13, NULL),
(24, 13, 32, NULL),
(25, 13, 9, NULL),
(26, 13, 33, NULL),
(27, 13, 5, NULL),
(28, 13, 7, NULL),
(29, 13, 34, NULL),
(30, 13, 15, NULL),
(35, 21, 85, NULL),
(36, 21, 86, NULL),
(37, 21, 87, NULL),
(38, 21, 88, NULL),
(39, 21, 89, NULL),
(40, 21, 90, NULL),
(41, 21, 91, NULL),
(42, 21, 92, NULL),
(43, 21, 93, NULL),
(44, 21, 94, NULL),
(45, 21, 95, NULL),
(46, 21, 96, NULL),
(47, 21, 97, NULL),
(48, 21, 98, NULL),
(49, 21, 99, NULL),
(50, 21, 100, NULL),
(51, 22, 58, NULL),
(52, 22, 101, NULL),
(53, 22, 102, NULL),
(54, 22, 103, NULL),
(55, 22, 104, NULL),
(56, 22, 105, NULL),
(57, 22, 51, NULL),
(58, 22, 106, NULL),
(59, 24, 114, NULL),
(60, 24, 61, NULL),
(61, 24, 57, NULL),
(62, 24, 53, NULL),
(63, 24, 115, NULL),
(64, 24, 116, NULL),
(65, 24, 117, NULL),
(66, 24, 118, NULL),
(68, 5, 1, 'Direct Invite'),
(69, 19, 117, 'Direct Invite');

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
  `tournamentLogo` varchar(500) NOT NULL COMMENT 'логотип турнира',
  `miniTournamentLogo` varchar(200) NOT NULL COMMENT 'мини логотип',
  `seria` varchar(100) NOT NULL COMMENT 'серия',
  `description` varchar(1500) NOT NULL COMMENT 'описание ',
  `prize` int(11) NOT NULL COMMENT 'сумма призовых',
  `dateBegin` date NOT NULL COMMENT 'дата начала турнира',
  `dateEnd` date NOT NULL COMMENT 'дата окончания турнира',
  `location` varchar(100) NOT NULL COMMENT 'локация',
  `idRegion` int(11) DEFAULT NULL COMMENT 'id региона',
  `status` int(11) NOT NULL COMMENT 'статус турнира'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `tournaments`
--

INSERT INTO `tournaments` (`idTournament`, `event`, `tournamentLogo`, `miniTournamentLogo`, `seria`, `description`, `prize`, `dateBegin`, `dateEnd`, `location`, `idRegion`, `status`) VALUES
(1, 'The International 2019', 'images/tournamentLogos/The International 2019.png', './images/tournamentLogos/miniLogos/The International 2019.png', 'The International', 'The International 2019 пройдет в августе 2019 года в Шанхае, Китай. Призовой фонд предыдущего турнира составил $25,000,000. Квалификации на турнир пройдут во всех регионах в июне 2019 года', 1000000, '2019-08-16', '0000-00-00', '', NULL, 1),
(2, 'World Cyber Games 2019', 'images/tournamentLogos/World Cyber Games 2019.png', './images/tournamentLogos/miniLogos/World Cyber Games 2019.png', 'World Cyber Games', '', 0, '2019-07-18', '0000-00-00', '', NULL, 1),
(3, 'StarLadder ImbaTV Dota 2 Minor Season 2', 'images/tournamentLogos/StarLadder ImbaTV Dota 2 Minor Season 2.png', './images/tournamentLogos/miniLogos/StarLadder ImbaTV Dota 2 Minor Season 2.png', 'SL i-League StarSeries', '', 300000, '2019-06-10', '0000-00-00', '', NULL, 1),
(5, 'ESL One Birmingham 2019', 'images/tournamentLogos/ESL One Birmingham 2019.png', './images/tournamentLogos/miniLogos/ESL One Birmingham 2019.png', 'WePlay! Dota 2 Tug of War', '', 300000, '2019-05-28', '2019-06-02', '', NULL, -1),
(8, 'RESF Premium Cup 2', 'images/tournamentLogos/RESF Premium Cup 2.png', './images/tournamentLogos/miniLogos/RESF Premium Cup 2.png', 'joinDOTA', '', 1027, '2019-05-26', '0000-00-00', '', NULL, -1),
(9, 'Adrenaline Cyber League 2019', 'images/tournamentLogos/Adrenaline Cyber League 2019.png', './images/tournamentLogos/miniLogos/Adrenaline Cyber League 2019.png', ' 	Adrenaline Cyber League', '', 100000, '2019-05-25', '2019-05-26', '', NULL, -1),
(10, 'Qi Invitational Europes', 'images/tournamentLogos/Qi Invitational Europes.png', './images/tournamentLogos/miniLogos/Qi Invitational Europes.png', 'Feng Ye Professional', '', 10000, '2019-05-25', '2019-05-27', '', NULL, -1),
(12, 'StarLadder ImbaTV Dota 2 Minor - OQ', 'images/tournamentLogos/StarLadder ImbaTV Dota 2 Minor Season 2.png', './images/tournamentLogos/miniLogos/StarLadder ImbaTV Dota 2 Minor - OQ.png', 'Challenge Cup', '', 0, '2019-05-19', '2019-05-21', '', NULL, 1),
(13, 'EPICENTER Major', 'images/tournamentLogos/EPICENTER Major.png', './images/tournamentLogos/miniLogos/EPICENTER Major.png', 'Epicenter', '', 1000000, '2019-06-22', '0000-00-00', '', NULL, 1),
(19, 'ESL India Premiership 2019 Summer', 'images/tournamentLogos/ESL India Premiership 2019 Summer.png', './images/tournamentLogos/miniLogos/ESL India Premiership 2019 Summer.png', '', '', 14656, '2019-04-26', '0000-00-00', '', NULL, 0),
(21, 'Bishkek Stars League #8', 'images/tournamentLogos/Bishkek Stars League #8.png', './images/tournamentLogos/miniLogos/Bishkek Stars League #8.png', '', '', 31813, '2019-04-20', '2019-05-19', '', NULL, 0),
(22, 'ESL Vietnam Championship Season 1', 'images/tournamentLogos/ESL Vietnam Championship Se', './images/tournamentLogos/miniLogos/ESL Vietnam Championship Season 1.png', '', '', 12000, '2019-04-12', '0000-00-00', '', NULL, 0),
(24, 'ESL Thailand Championship Season 1', 'images/tournamentLogos/ESL Thailand Championship S', './images/tournamentLogos/miniLogos/ESL Thailand Championship Season 1.png', '', '', 12000, '2019-04-09', '0000-00-00', '', NULL, 0),
(27, 'KFC Battle 2019', './images/tournamentLogos/KFC Battle 2019.png', '', '', '', 0, '2019-06-13', '2019-06-14', '', NULL, 1);

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
  ADD PRIMARY KEY (`idMatch`),
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
  ADD KEY `players_ibfk_3` (`idRole`);

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
  ADD PRIMARY KEY (`idRecord`),
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
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
  MODIFY `idMatch` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id матча', AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT для таблицы `matchformats`
--
ALTER TABLE `matchformats`
  MODIFY `idMatchFormat` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id формата', AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `players`
--
ALTER TABLE `players`
  MODIFY `idPlayer` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id игрока', AUTO_INCREMENT=818;

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
  MODIFY `idTeam` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id команды', AUTO_INCREMENT=122;

--
-- AUTO_INCREMENT для таблицы `tournamentmembers`
--
ALTER TABLE `tournamentmembers`
  MODIFY `idRecord` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id записи', AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT для таблицы `tournaments`
--
ALTER TABLE `tournaments`
  MODIFY `idTournament` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id турнира', AUTO_INCREMENT=28;

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
