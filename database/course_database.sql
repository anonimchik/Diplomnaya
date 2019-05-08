-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3006
-- Время создания: Май 08 2019 г., 07:08
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
  `date` datetime NOT NULL COMMENT 'дата проведения матча',
  `round` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `matchformats`
--

CREATE TABLE `matchformats` (
  `idMatchFormat` int(11) NOT NULL COMMENT 'id формата',
  `matchFormat` varchar(50) NOT NULL COMMENT 'формат'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  `birthday` date NOT NULL COMMENT 'дата рождения',
  `photoRef` varchar(250) DEFAULT NULL COMMENT 'фото',
  `idRole` int(11) NOT NULL COMMENT 'id роли',
  `line` varchar(20) NOT NULL COMMENT 'линия',
  `prize` int(11) NOT NULL COMMENT 'сумма призовых'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `players`
--

INSERT INTO `players` (`idPlayer`, `idTeam`, `idDiscipline`, `country`, `countryFlag`, `name`, `nickname`, `birthday`, `photoRef`, `idRole`, `line`, `prize`) VALUES
(1, 2, 1, 'Китай', 'images/countryFlags/Китай.png', 'Zhang Chengjun', 'Paparazi', '0000-00-00', 'images/playerPhotos/Paparazi.png', 1, 'Safe', 535237),
(2, 2, 1, 'Китай', 'images/countryFlags/Китай.png', 'Zeng Jiaoyang', 'Ori', '0000-00-00', 'images/playerPhotos/Ori.png', 2, 'Mid', 373302),
(3, 2, 1, 'Китай', 'images/countryFlags/Китай.png', 'Zhou Haiyang', 'Yang', '0000-00-00', 'images/playerPhotos/Yang.png', 3, 'Hard', 383569),
(4, 2, 1, 'Китай', 'images/countryFlags/Китай.png', 'Pan Yi', 'Fade', '0000-00-00', 'images/playerPhotos/Fade.png', 5, 'Safe', 304768),
(5, 3, 1, 'Россия', 'images/countryFlags/Россия.png', 'Nikita Kuzmin', 'Daxak', '0000-00-00', 'images/playerPhotos/Daxak.png', 1, 'Safe', 72900),
(6, 3, 1, 'Россия', 'images/countryFlags/Россия.png', 'Andrey Afonin', 'Afoninje', '0000-00-00', 'images/playerPhotos/Afoninje.png', 2, 'Mid', 114132),
(7, 3, 1, 'Россия', 'images/countryFlags/Россия.png', 'Vasilii Shishkin', 'Afterlife', '0000-00-00', 'images/playerPhotos/Afterlife.png', 3, 'Hard', 115708),
(8, 3, 1, 'Беларусь', 'images/countryFlags/Беларусь.png', 'Artem Barshack', 'fng', '0000-00-00', 'images/playerPhotos/fng.png', 5, 'Safe', 463184),
(9, 3, 1, 'Россия', 'images/countryFlags/Россия.png', 'Alexander Hmelevskoy', 'Immersion', '0000-00-00', 'images/playerPhotos/Immersion.png', 5, 'Hard', 63350),
(10, 4, 1, 'Дания', 'images/countryFlags/Дания.png', 'Marcus Hoelgaard', 'Ace', '0000-00-00', 'images/playerPhotos/Ace.png', 1, 'Safe', 664390),
(11, 4, 1, 'Македония', 'images/countryFlags/Македония.png', 'Martin Sazdov', 'Saksa', '0000-00-00', 'images/playerPhotos/Saksa.png', 5, 'Hard', 911900),
(12, 5, 1, 'Китай', 'images/countryFlags/Китай.png', 'Wang Chunyu', 'Ame', '0000-00-00', 'images/playerPhotos/Ame.png', 1, 'Safe', 1558220),
(13, 5, 1, 'Китай', 'images/countryFlags/Китай.png', 'Yang Shenyi', 'Chalice', '0000-00-00', 'images/playerPhotos/Chalice.png', 3, 'Hard', 1138544),
(14, 5, 1, 'Китай', 'images/countryFlags/Китай.png', 'Xu Linsen', 'fy', '0000-00-00', 'images/playerPhotos/fy.png', 5, 'Safe', 2120297),
(15, 5, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Yap Jian Wei', 'xNova', '0000-00-00', 'images/playerPhotos/xNova.png', 5, 'Safe', 1163741),
(16, 6, 1, 'Китай', 'images/countryFlags/Китай.png', 'Lin Zikai', 'doodle', '0000-00-00', 'images/playerPhotos/doodle.png', 1, 'Safe', 13132),
(17, 6, 1, 'Китай', 'images/countryFlags/Китай.png', 'Zhou Yi', 'Emo', '0000-00-00', 'images/playerPhotos/Emo.png', 2, 'Mid', 15088),
(18, 6, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Thiay Jun Wen', 'JT-', '0000-00-00', 'images/playerPhotos/JT-.png', 3, 'Hard', 27060),
(19, 6, 1, 'Китай', 'images/countryFlags/Китай.png', 'Gao Tianpeng', 'Dogf1ghts', '0000-00-00', 'images/playerPhotos/Dogf1ghts.png', 5, 'Hard', 189450),
(20, 6, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Chan Chon Kien', 'Oli', '0000-00-00', 'images/playerPhotos/Oli.png', 5, 'Safe', 28990),
(21, 7, 1, 'Финляндия', 'images/countryFlags/Финляндия.png', 'Lasse Urpalainen', 'MATUMBAMAN', '0000-00-00', 'images/playerPhotos/MATUMBAMAN.png', 2, 'Mid', 3494414),
(22, 7, 1, 'Германия', 'images/countryFlags/Германия.png', 'Kuro Salehi Takhasomi', 'KuroKy', '0000-00-00', 'images/playerPhotos/KuroKy.png', 5, 'Safe', 3960205),
(23, 7, 1, 'Ливан', 'images/countryFlags/Ливан.png', 'Maroun Merhej', 'GH', '0000-00-00', 'images/playerPhotos/GH.png', 5, 'Hard', 3113980),
(24, 8, 1, 'Канада', 'images/countryFlags/Канада.png', 'Artour Babaev', 'Arteezy', '0000-00-00', 'images/playerPhotos/Arteezy.png', 1, 'Safe', 1574121),
(25, 8, 1, 'Пакистан', 'images/countryFlags/Пакистан.png', 'Syed Sumail Hassan', 'Sumail', '0000-00-00', 'images/playerPhotos/Sumail.png', 2, 'Mid', 3263828),
(26, 8, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Gustav Magnusson', 's4', '0000-00-00', 'images/playerPhotos/s4.png', 3, 'Hard', 2112168),
(27, 8, 1, 'Дания', 'images/countryFlags/Дания.png', 'Andreas Franck Nielsen', 'Cr1t', '0000-00-00', 'images/playerPhotos/Cr1t.png', 5, 'Hard', 1599731),
(28, 8, 1, 'Израиль', 'images/countryFlags/Израиль.png', 'Tal Aizik', 'Fly', '0000-00-00', 'images/playerPhotos/Fly.png', 5, 'Safe', 1975035),
(29, 9, 1, 'Польша', 'images/countryFlags/Польша.png', 'Michał Jankowski', 'Nisha', '0000-00-00', 'images/playerPhotos/Nisha.png', 1, 'Safe', 213621),
(30, 9, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Ludwig Wåhlberg', 'Zai', '0000-00-00', 'images/playerPhotos/Zai.png', 3, 'Hard', 1494984),
(31, 9, 1, 'Эстония', 'images/countryFlags/Эстония.png', 'Clement Ivanov', 'Puppey', '0000-00-00', 'images/playerPhotos/Puppey.png', 5, 'Safe', 1743197),
(32, 9, 1, 'Иордания', 'images/countryFlags/Иордания.png', 'Yazied Jaradat', 'YapzOr', '0000-00-00', 'images/playerPhotos/YapzOr.png', 5, 'Hard', 824403),
(33, 10, 1, 'Великобритания', 'images/countryFlags/Великобритания.png', 'Omar Dabasas', 'Madara', '0000-00-00', 'images/playerPhotos/Madara.png', 1, 'Safe', 143580),
(34, 10, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Micke Nguyen', 'Micke', '0000-00-00', 'images/playerPhotos/Micke.png', 1, 'Safe', 21909),
(35, 10, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Samuel Svahn', 'boxi', '0000-00-00', 'images/playerPhotos/boxi.png', 3, 'Hard', 28109),
(36, 10, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Aydin Sarkohi', 'iNsania', '0000-00-00', 'images/playerPhotos/iNsania.png', 5, 'Hard', 30222),
(37, 11, 1, 'Пакистан', 'images/countryFlags/Пакистан.png', 'Yawar Hassan', 'YawaR', '0000-00-00', 'images/playerPhotos/YawaR.png', 1, 'Safe', 216933),
(38, 11, 1, 'США', 'images/countryFlags/США.png', 'Jingjun Wu', 'Sneyking', '0000-00-00', 'images/playerPhotos/Sneyking.png', 3, 'Hard', 221205),
(39, 11, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Johan Åström', 'pieliedie', '0000-00-00', 'images/playerPhotos/pieliedie.png', 5, 'Safe', 650164),
(40, 11, 1, 'США', 'images/countryFlags/США.png', 'Arif Anwar', 'MSS', '0000-00-00', 'images/playerPhotos/MSS.png', 5, 'Safe', 295227),
(41, 12, 1, 'Китай', 'images/countryFlags/Китай.png', 'Zhai Jingkai', 'Ying', '0000-00-00', 'images/playerPhotos/Ying.png', 2, 'Mid', 131329),
(42, 13, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Kim Villafuerte Santos', 'Gabbi', '0000-00-00', 'images/playerPhotos/Gabbi.png', 1, 'Safe', 148656),
(43, 13, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Armel Paul Tabios', 'Armel', '0000-00-00', 'images/playerPhotos/Armel.png', 2, 'Mid', 193887),
(44, 13, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Carlo Palad', 'Kuku', '0000-00-00', 'images/playerPhotos/Kuku.png', 3, 'Hard', 489599),
(45, 13, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Nico Barcelon', 'Eyyou', '0000-00-00', 'images/playerPhotos/Eyyou.png', 5, 'Hard', 221031),
(46, 13, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Timothy Randrup', 'Tims', '0000-00-00', 'images/playerPhotos/Tims.png', 5, 'Hard', 470668),
(47, 3, 1, 'Россия', 'images/countryFlags/Россия.png', 'Nikita Kuzmin', 'Daxak', '0000-00-00', 'images/playerPhotos/Daxak.png', 1, 'Safe', 72900),
(48, 3, 1, 'Россия', 'images/countryFlags/Россия.png', 'Andrey Afonin', 'Afoninje', '0000-00-00', 'images/playerPhotos/Afoninje.png', 2, 'Mid', 114132),
(49, 3, 1, 'Россия', 'images/countryFlags/Россия.png', 'Vasilii Shishkin', 'Afterlife', '0000-00-00', 'images/playerPhotos/Afterlife.png', 3, 'Hard', 115708),
(50, 3, 1, 'Беларусь', 'images/countryFlags/Беларусь.png', 'Artem Barshack', 'fng', '0000-00-00', 'images/playerPhotos/fng.png', 5, 'Safe', 463184),
(51, 3, 1, 'Россия', 'images/countryFlags/Россия.png', 'Alexander Hmelevskoy', 'Immersion', '0000-00-00', 'images/playerPhotos/Immersion.png', 5, 'Hard', 63350),
(52, 14, 1, 'Россия', 'images/countryFlags/Россия.png', 'Konstantin Kogaj', 'kodos', '0000-00-00', 'images/playerPhotos/kodos.png', 2, 'Mid', 4721),
(53, 14, 1, 'Россия', 'images/countryFlags/Россия.png', 'Igor Modenov', 'Maden', '0000-00-00', 'images/playerPhotos/Maden.png', 3, 'Hard', 11068),
(54, 14, 1, 'Россия', 'images/countryFlags/Россия.png', 'Renat Abdullin', 'KingR', '0000-00-00', 'images/playerPhotos/KingR.png', 5, 'Safe', 85411),
(55, 14, 1, 'Россия', 'images/countryFlags/Россия.png', 'Oleg Kalembet', 'sayuw', '0000-00-00', 'images/playerPhotos/sayuw.png', 5, 'Safe', 7099),
(56, 15, 1, 'Россия', 'images/countryFlags/Россия.png', 'Airat Gaziev', 'Silent', '0000-00-00', 'images/playerPhotos/Silent.png', 1, 'Safe', 266328),
(57, 15, 1, 'Россия', 'images/countryFlags/Россия.png', 'Igor Filatov', 'iLTW', '0000-00-00', 'images/playerPhotos/iLTW.png', 2, 'Mid', 212629),
(58, 15, 1, 'Россия', 'images/countryFlags/Россия.png', 'Aleksey Vasiliev', 'nongrataaa', '0000-00-00', 'images/playerPhotos/nongrataaa.png', 3, 'Hard', 103073),
(59, 15, 1, 'Россия', 'images/countryFlags/Россия.png', 'Churochkin Alexander', 'NoFear', '0000-00-00', 'images/playerPhotos/NoFear.png', 5, 'Safe', 172242),
(60, 15, 1, 'Украина', 'images/countryFlags/Украина.png', 'Ilya Ilyuk', 'Lil', '0000-00-00', 'images/playerPhotos/Lil.png', 5, 'Hard', 892804),
(61, 68, 1, 'Украина', 'images/countryFlags/Украина.png', 'Bogdan Vasylenko', 'Iceberg', '0000-00-00', 'images/playerPhotos/Iceberg.png', 2, 'Mid', 141274),
(62, 16, 1, 'Россия', 'images/countryFlags/Россия.png', 'Alexander Levin', 'Nix', '0000-00-00', 'images/playerPhotos/Nix.png', 2, 'Mid', 8570),
(63, 15, 1, 'Россия', 'images/countryFlags/Россия.png', 'Churochkin Alexander', 'NoFear', '0000-00-00', 'images/playerPhotos/NoFear.png', 5, 'Safe', 172242),
(64, 16, 1, 'Россия', 'images/countryFlags/Россия.png', 'Daniyal Lazebny', 'yamich', '0000-00-00', 'images/playerPhotos/yamich.png', 5, 'Hard', 100),
(65, 17, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Rasmus Blomdin', 'Chessie', '0000-00-00', 'images/playerPhotos/Chessie.png', 2, 'Mid', 108974),
(66, 17, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Andreas Ragnemalm', 'Xibbe', '0000-00-00', 'images/playerPhotos/Xibbe.png', 3, 'Hard', 233),
(67, 17, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Adrian Kryeziu', 'Era', '0000-00-00', 'images/playerPhotos/Era.png', 5, 'Hard', 80038),
(68, 17, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Simon Haag', 'Handsken', '0000-00-00', 'images/playerPhotos/Handsken.png', 5, 'Hard', 172037),
(69, 19, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Steve Zi Shan Ye', 'Xcalibur', '0000-00-00', 'images/playerPhotos/Xcalibur.png', 1, 'Safe', 18686),
(70, 19, 1, 'Словения', 'images/countryFlags/Словения.png', 'Jure Plešej', 'Pingvincek', '0000-00-00', 'images/playerPhotos/Pingvincek.png', 2, 'Mid', 7790),
(71, 19, 1, 'Россия', 'images/countryFlags/Россия.png', 'Maxim Abramovskikh', 'Shachlo', '0000-00-00', 'images/playerPhotos/Shachlo.png', 3, 'Hard', 15544),
(72, 19, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Jerry Lundkvist', 'EGM', '0000-00-00', 'images/playerPhotos/EGM.png', 5, 'Hard', 580415),
(73, 19, 1, 'Россия', 'images/countryFlags/Россия.png', 'Yaroslav Naidenov', 'Miposhka', '0000-00-00', 'images/playerPhotos/Miposhka.png', 5, 'Safe', 211278),
(74, 20, 1, 'Греция', 'images/countryFlags/Греция.png', 'Dimitris Plivouris', 'ThuG', '0000-00-00', 'images/playerPhotos/ThuG.png', 1, 'Safe', 158569),
(75, 20, 1, 'Греция', 'images/countryFlags/Греция.png', 'Kharis Zafeiriou', 'SkyLark', '0000-00-00', 'images/playerPhotos/SkyLark.png', 3, 'Hard', 165510),
(76, 20, 1, 'Греция', 'images/countryFlags/Греция.png', 'Tasos Michailidis', 'Focus', '0000-00-00', 'images/playerPhotos/Focus.png', 5, 'Hard', 30600),
(77, 20, 1, 'Греция', 'images/countryFlags/Греция.png', 'Giorgos Giannakopoulos', 'SsaSpartan', '0000-00-00', 'images/playerPhotos/SsaSpartan.png', 5, 'Safe', 165975),
(78, 21, 1, 'Украина', 'images/countryFlags/Украина.png', 'Vladimir Minenko', 'No[o]ne', '0000-00-00', 'images/playerPhotos/No[o]ne.png', 2, 'Mid', 1376228),
(79, 21, 1, 'Россия', 'images/countryFlags/Россия.png', 'Alexei Berezin', 'Solo', '0000-00-00', 'images/playerPhotos/Solo.png', 5, 'Safe', 1568331),
(80, 21, 1, 'Россия', 'images/countryFlags/Россия.png', 'Vladimir Nikogosyan', 'RodjER', '0000-00-00', 'images/playerPhotos/RodjER.png', 5, 'Hard', 1120009),
(81, 22, 1, 'Украина', 'images/countryFlags/Украина.png', 'Vladislav Krystanek', 'Crystallize', '0000-00-00', 'images/playerPhotos/Crystallize.png', 1, 'Safe', 97600),
(82, 65, 1, 'Вьетнам', 'images/countryFlags/Вьетнам.png', 'Huỳnh Hữu Nghĩa', 'Magical', '0000-00-00', 'images/playerPhotos/Magical.png', 5, 'Safe', 200),
(83, 22, 1, 'Кыргызстан', 'images/countryFlags/Кыргызстан.png', 'Evgenii Ri', 'Blizzy', '0000-00-00', 'images/playerPhotos/Blizzy.png', 3, 'Hard', 53671),
(84, 22, 1, 'Россия', 'images/countryFlags/Россия.png', 'Akbar Butaev', 'SoNNeikO', '0000-00-00', 'images/playerPhotos/SoNNeikO.png', 5, 'Safe', 207200),
(85, 22, 1, 'Кыргызстан', 'images/countryFlags/Кыргызстан.png', 'Bakyt Emilzhanov', 'Zayac', '0000-00-00', 'images/playerPhotos/Zayac.png', 5, 'Hard', 28501),
(86, 23, 1, 'Россия', 'images/countryFlags/Россия.png', 'Ilya Pivcaev', 'Illidan', '0000-00-00', 'images/playerPhotos/Illidan.png', 1, 'Safe', 351988),
(87, 23, 1, 'Россия', 'images/countryFlags/Россия.png', 'Sergey Bragin', 'God', '0000-00-00', 'images/playerPhotos/God.png', 2, 'Mid', 385586),
(88, 23, 1, 'Россия', 'images/countryFlags/Россия.png', 'Ivan Skorokhod', 'VANSKOR', '0000-00-00', 'images/playerPhotos/VANSKOR.png', 5, 'Safe', 117574),
(89, 23, 1, 'Россия', 'images/countryFlags/Россия.png', 'Fedor Rusihin', 'velheor', '0000-00-00', 'images/playerPhotos/velheor.png', 5, 'Hard', 11687),
(90, 24, 1, 'Беларусь', 'images/countryFlags/Беларусь.png', 'Aleksandr Zalivako', 'Pio65', '0000-00-00', 'images/playerPhotos/Pio65.png', 1, 'Safe', 374),
(91, 24, 1, 'Беларусь', 'images/countryFlags/Беларусь.png', 'Egor Kozlov', 'Ergon', '0000-00-00', 'images/playerPhotos/Ergon.png', 2, 'Mid', 74),
(92, 24, 1, 'Беларусь', 'images/countryFlags/Беларусь.png', 'Vladislav Kozlovskij', 'kazl', '0000-00-00', 'images/playerPhotos/kazl.png', 3, 'Hard', 74),
(93, 24, 1, 'Беларусь', 'images/countryFlags/Беларусь.png', 'Siarhei Kharonzhy', 'HappyDyurara', '0000-00-00', 'images/playerPhotos/HappyDyurara.png', 5, 'Hard', 74),
(94, 24, 1, 'Беларусь', 'images/countryFlags/Беларусь.png', 'Maksim Cymanovich', 'Tsyman', '0000-00-00', 'images/playerPhotos/Tsyman.png', 5, 'Safe', 174),
(95, 8, 1, 'Канада', 'images/countryFlags/Канада.png', 'Artour Babaev', 'Arteezy', '0000-00-00', 'images/playerPhotos/Arteezy.png', 1, 'Safe', 1574121),
(96, 8, 1, 'Пакистан', 'images/countryFlags/Пакистан.png', 'Syed Sumail Hassan', 'Sumail', '0000-00-00', 'images/playerPhotos/Sumail.png', 2, 'Mid', 3263828),
(97, 8, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Gustav Magnusson', 's4', '0000-00-00', 'images/playerPhotos/s4.png', 3, 'Hard', 2112168),
(98, 8, 1, 'Дания', 'images/countryFlags/Дания.png', 'Andreas Franck Nielsen', 'Cr1t', '0000-00-00', 'images/playerPhotos/Cr1t.png', 5, 'Hard', 1599731),
(99, 8, 1, 'Израиль', 'images/countryFlags/Израиль.png', 'Tal Aizik', 'Fly', '0000-00-00', 'images/playerPhotos/Fly.png', 5, 'Safe', 1975035),
(100, 28, 1, 'Сингапур', 'images/countryFlags/Сингапур.png', 'Galvin Kang Jian Wen', 'Meracle', '0000-00-00', 'images/playerPhotos/Meracle.png', 1, 'Safe', 22137),
(101, 28, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Linus Blomdin', 'Limmp', '0000-00-00', 'images/playerPhotos/Limmp.png', 2, 'Mid', 195285),
(102, 28, 1, 'США', 'images/countryFlags/США.png', 'Jaron Clinton', 'monkeys-forever', '0000-00-00', 'images/playerPhotos/monkeys-forever.png', 3, 'Hard', 25873),
(103, 28, 1, 'США', 'images/countryFlags/США.png', 'Zakari Freedman', 'Zfreek', '0000-00-00', 'images/playerPhotos/Zfreek.png', 5, 'Hard', 166264),
(104, 29, 1, 'Канада', 'images/countryFlags/Канада.png', 'Jacky Mao', 'EternaLEnVy', '0000-00-00', 'images/playerPhotos/EternaLEnVy.png', 1, 'Safe', 746269),
(105, 29, 1, 'США', 'images/countryFlags/США.png', 'Eric Dong', 'Ryoya', '0000-00-00', 'images/playerPhotos/Ryoya.png', 2, 'Mid', 33935),
(106, 29, 1, 'США', 'images/countryFlags/США.png', 'Braxton Paulson', 'Brax', '0000-00-00', 'images/playerPhotos/Brax.png', 3, 'Hard', 20820),
(107, 29, 1, 'США', 'images/countryFlags/США.png', 'Michael Ghannam', 'ixmike88', '0000-00-00', 'images/playerPhotos/ixmike88.png', 5, 'Safe', 16737),
(108, 29, 1, 'Сингапур', 'images/countryFlags/Сингапур.png', 'Timothy Ong', 'TMT', '0000-00-00', 'images/playerPhotos/TMT.png', 5, 'Hard', 250),
(109, 30, 1, 'Бразилия', 'images/countryFlags/Бразилия.png', 'Leonardo Santos Viana Da Guarda', 'Mandy', '0000-00-00', 'images/playerPhotos/Mandy.png', 1, 'Safe', 2338),
(110, 30, 1, 'Бразилия', 'images/countryFlags/Бразилия.png', 'Adriano Machado', '4dr', '0000-00-00', 'images/playerPhotos/4dr.png', 2, 'Mid', 58073),
(111, 30, 1, 'Бразилия', 'images/countryFlags/Бразилия.png', 'Rodrigo Lelis', 'Liposa', '0000-00-00', 'images/playerPhotos/Liposa.png', 3, 'Hard', 29293),
(112, 30, 1, 'Бразилия', 'images/countryFlags/Бразилия.png', 'Thiago Cordeiro', 'Thiolicor', '0000-00-00', 'images/playerPhotos/Thiolicor.png', 5, 'Hard', 20293),
(113, 31, 1, 'Бразилия', 'images/countryFlags/Бразилия.png', 'William De Medeiros Anastacio', 'hFn', '0000-00-00', 'images/playerPhotos/hFn.png', 1, 'Safe', 157875),
(114, 31, 1, 'Румыния', 'images/countryFlags/Румыния.png', 'Aliwi Omar', 'w33haa', '0000-00-00', 'images/playerPhotos/w33haa.png', 2, 'Mid', 1233323),
(115, 31, 1, 'Бразилия', 'images/countryFlags/Бразилия.png', 'Otávio Gabriel Cerqueira Silva', 'Tavo', '0000-00-00', 'images/playerPhotos/Tavo.png', 3, 'Hard', 157995),
(116, 31, 1, 'Бразилия', 'images/countryFlags/Бразилия.png', 'Danylo Nascimento', 'KINGRD', '0000-00-00', 'images/playerPhotos/KINGRD.png', 5, 'Safe', 158155),
(117, 31, 1, 'Дания', 'images/countryFlags/Дания.png', 'Rasmus Berth Filipsen', 'MiSeRy', '0000-00-00', 'images/playerPhotos/MiSeRy.png', 5, 'Hard', 1412650),
(118, 9, 1, 'Польша', 'images/countryFlags/Польша.png', 'Michał Jankowski', 'Nisha', '0000-00-00', 'images/playerPhotos/Nisha.png', 1, 'Safe', 213621),
(119, 9, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Ludwig Wåhlberg', 'Zai', '0000-00-00', 'images/playerPhotos/Zai.png', 3, 'Hard', 1494984),
(120, 9, 1, 'Эстония', 'images/countryFlags/Эстония.png', 'Clement Ivanov', 'Puppey', '0000-00-00', 'images/playerPhotos/Puppey.png', 5, 'Safe', 1743197),
(121, 9, 1, 'Иордания', 'images/countryFlags/Иордания.png', 'Yazied Jaradat', 'YapzOr', '0000-00-00', 'images/playerPhotos/YapzOr.png', 5, 'Hard', 824403),
(122, 7, 1, 'Финляндия', 'images/countryFlags/Финляндия.png', 'Lasse Urpalainen', 'MATUMBAMAN', '0000-00-00', 'images/playerPhotos/MATUMBAMAN.png', 2, 'Mid', 3494414),
(123, 7, 1, 'Германия', 'images/countryFlags/Германия.png', 'Kuro Salehi Takhasomi', 'KuroKy', '0000-00-00', 'images/playerPhotos/KuroKy.png', 5, 'Safe', 3960205),
(124, 7, 1, 'Ливан', 'images/countryFlags/Ливан.png', 'Maroun Merhej', 'GH', '0000-00-00', 'images/playerPhotos/GH.png', 5, 'Hard', 3113980),
(125, 32, 1, 'Австралия', 'images/countryFlags/Австралия.png', 'Anathan Pham', 'ana', '0000-00-00', 'images/playerPhotos/ana.png', 1, 'Safe', 2849154),
(126, 32, 1, 'Финляндия', 'images/countryFlags/Финляндия.png', 'Topics Taavitsainen', 'Topson', '0000-00-00', 'images/playerPhotos/Topson.png', 2, 'Mid', 2264455),
(127, 32, 1, 'Франция', 'images/countryFlags/Франция.png', 'Sebastien Debs', '7ckngMad', '0000-00-00', 'images/playerPhotos/7ckngMad.png', 3, 'Hard', 2316143),
(128, 32, 1, 'Дания', 'images/countryFlags/Дания.png', 'Johan Sundstein', 'N0tail', '0000-00-00', 'images/playerPhotos/N0tail.png', 5, 'Safe', 3664192),
(129, 32, 1, 'Финляндия', 'images/countryFlags/Финляндия.png', 'Jesse Vainikka', 'JerAx', '0000-00-00', 'images/playerPhotos/JerAx.png', 5, 'Hard', 3315898),
(130, 21, 1, 'Украина', 'images/countryFlags/Украина.png', 'Vladimir Minenko', 'No[o]ne', '0000-00-00', 'images/playerPhotos/No[o]ne.png', 2, 'Mid', 1376228),
(131, 21, 1, 'Россия', 'images/countryFlags/Россия.png', 'Alexei Berezin', 'Solo', '0000-00-00', 'images/playerPhotos/Solo.png', 5, 'Safe', 1568331),
(132, 21, 1, 'Россия', 'images/countryFlags/Россия.png', 'Vladimir Nikogosyan', 'RodjER', '0000-00-00', 'images/playerPhotos/RodjER.png', 5, 'Hard', 1120009),
(133, 14, 1, 'Россия', 'images/countryFlags/Россия.png', 'Konstantin Kogaj', 'kodos', '0000-00-00', 'images/playerPhotos/kodos.png', 2, 'Mid', 4721),
(134, 14, 1, 'Россия', 'images/countryFlags/Россия.png', 'Igor Modenov', 'Maden', '0000-00-00', 'images/playerPhotos/Maden.png', 3, 'Hard', 11068),
(135, 14, 1, 'Россия', 'images/countryFlags/Россия.png', 'Renat Abdullin', 'KingR', '0000-00-00', 'images/playerPhotos/KingR.png', 5, 'Safe', 85411),
(136, 14, 1, 'Россия', 'images/countryFlags/Россия.png', 'Oleg Kalembet', 'sayuw', '0000-00-00', 'images/playerPhotos/sayuw.png', 5, 'Safe', 7099),
(137, 12, 1, 'Китай', 'images/countryFlags/Китай.png', 'Zhai Jingkai', 'Ying', '0000-00-00', 'images/playerPhotos/Ying.png', 2, 'Mid', 131329),
(138, 5, 1, 'Китай', 'images/countryFlags/Китай.png', 'Wang Chunyu', 'Ame', '0000-00-00', 'images/playerPhotos/Ame.png', 1, 'Safe', 1558220),
(139, 5, 1, 'Китай', 'images/countryFlags/Китай.png', 'Yang Shenyi', 'Chalice', '0000-00-00', 'images/playerPhotos/Chalice.png', 3, 'Hard', 1138544),
(140, 5, 1, 'Китай', 'images/countryFlags/Китай.png', 'Xu Linsen', 'fy', '0000-00-00', 'images/playerPhotos/fy.png', 5, 'Safe', 2120297),
(141, 5, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Yap Jian Wei', 'xNova', '0000-00-00', 'images/playerPhotos/xNova.png', 5, 'Safe', 1163741),
(142, 2, 1, 'Китай', 'images/countryFlags/Китай.png', 'Zhang Chengjun', 'Paparazi', '0000-00-00', 'images/playerPhotos/Paparazi.png', 1, 'Safe', 535237),
(143, 2, 1, 'Китай', 'images/countryFlags/Китай.png', 'Zeng Jiaoyang', 'Ori', '0000-00-00', 'images/playerPhotos/Ori.png', 2, 'Mid', 373302),
(144, 2, 1, 'Китай', 'images/countryFlags/Китай.png', 'Zhou Haiyang', 'Yang', '0000-00-00', 'images/playerPhotos/Yang.png', 3, 'Hard', 383569),
(145, 2, 1, 'Китай', 'images/countryFlags/Китай.png', 'Pan Yi', 'Fade', '0000-00-00', 'images/playerPhotos/Fade.png', 5, 'Safe', 304768),
(146, 33, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Abed Yusop', 'Abed', '0000-00-00', 'images/playerPhotos/Abed.png', 2, 'Mid', 261485),
(147, 33, 1, 'Сингапур', 'images/countryFlags/Сингапур.png', 'Daryl Koh Pei Xiang', 'iceiceice', '0000-00-00', 'images/playerPhotos/iceiceice.png', 3, 'Hard', 1070463),
(148, 33, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Djardel Jicko B. Mampusti', 'DJ', '0000-00-00', 'images/playerPhotos/DJ.png', 5, 'Hard', 626518),
(149, 33, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', 'Anucha Jirawong', 'Jabz', '0000-00-00', 'images/playerPhotos/Jabz.png', 5, 'Safe', 347983),
(150, 34, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Lai Jay Son', 'Ahjit', '0000-00-00', 'images/playerPhotos/Ahjit.png', 1, 'Safe', 115273),
(151, 34, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Michael Ross', 'ninjaboogie', '0000-00-00', 'images/playerPhotos/ninjaboogie.png', 5, 'Safe', 411187),
(152, 4, 1, 'Дания', 'images/countryFlags/Дания.png', 'Marcus Hoelgaard', 'Ace', '0000-00-00', 'images/playerPhotos/Ace.png', 1, 'Safe', 664390),
(153, 4, 1, 'Македония', 'images/countryFlags/Македония.png', 'Martin Sazdov', 'Saksa', '0000-00-00', 'images/playerPhotos/Saksa.png', 5, 'Hard', 911900),
(154, 35, 1, 'Китай', 'images/countryFlags/Китай.png', 'Luo Jingdong', 'hmx', '0000-00-00', 'images/playerPhotos/hmx.png', 1, 'Safe', 2576),
(155, 35, 1, 'Китай', 'images/countryFlags/Китай.png', 'Zhang Weixuan', 'Last', '0000-00-00', 'images/playerPhotos/Last.png', 3, 'Safe', 4534),
(156, 35, 1, 'Китай', 'images/countryFlags/Китай.png', 'Xiaodong Yang', 'InJuly', '0000-00-00', 'images/playerPhotos/InJuly.png', 3, 'Hard', 178078),
(157, 36, 1, 'Китай', 'images/countryFlags/Китай.png', '&ndash;', 'Oc', '0000-00-00', 'images/playerPhotos/Oc.png', 3, 'Hard', 405),
(158, 37, 1, 'Китай', 'images/countryFlags/Китай.png', '&ndash;', 'KazZ', '0000-00-00', 'images/playerPhotos/KazZ.png', 5, 'Hard', 864),
(159, 38, 1, 'Китай', 'images/countryFlags/Китай.png', 'Zhou Shiyuan', 'Dust', '0000-00-00', 'images/playerPhotos/Dust.png', 1, 'Hard', 1771),
(160, 38, 1, 'Китай', 'images/countryFlags/Китай.png', 'Ni Weijie', 'ButterflyEffect', '0000-00-00', 'images/playerPhotos/ButterflyEffect.png', 2, 'Mid', 1771),
(161, 38, 1, 'Китай', 'images/countryFlags/Китай.png', 'Zhao Shungeng', 'black.z', '0000-00-00', 'images/playerPhotos/black.z.png', 1, 'Safe', 32277),
(162, 38, 1, 'Китай', 'images/countryFlags/Китай.png', 'Li Zimeng', 'mianmian', '0000-00-00', 'images/playerPhotos/mianmian.png', 5, 'Hard', 1771),
(163, 39, 1, 'Китай', 'images/countryFlags/Китай.png', 'Yang Shaohan', 'Erica', '0000-00-00', 'images/playerPhotos/Erica.png', 1, 'Safe', 1589),
(164, 39, 1, 'Китай', 'images/countryFlags/Китай.png', 'Xu Ziliang', 'Blood', '0000-00-00', 'images/playerPhotos/Blood.png', 2, 'Mid', 576),
(165, 39, 1, 'Китай', 'images/countryFlags/Китай.png', '&ndash;', 'kui', '0000-00-00', 'images/playerPhotos/kui.png', 5, 'Hard', 576),
(166, 40, 1, 'Китай', 'images/countryFlags/Китай.png', 'He Zhipeng', 'Just', '0000-00-00', 'images/playerPhotos/Just.png', 2, 'Mid', 3100),
(167, 41, 1, 'Китай', 'images/countryFlags/Китай.png', 'Liu Ningbo', 'bobo', '0000-00-00', 'images/playerPhotos/bobo.png', 1, 'Hard', 1723),
(168, 41, 1, 'Китай', 'images/countryFlags/Китай.png', 'Pan Shuaifang', 'yChen', '0000-00-00', 'images/playerPhotos/yChen.png', 2, 'Mid', 36074),
(169, 44, 1, 'Китай', 'images/countryFlags/Китай.png', '&ndash;', 'Orion', '0000-00-00', 'images/playerPhotos/Orion.png', 1, 'Safe', 288),
(170, 44, 1, 'Китай', 'images/countryFlags/Китай.png', '&ndash;', 'detachment', '0000-00-00', 'images/playerPhotos/detachment.png', 5, 'Hard', 1153),
(171, 45, 1, 'Китай', 'images/countryFlags/Китай.png', 'Deng Lei', 'Dstones', '0000-00-00', 'images/playerPhotos/Dstones.png', 2, 'Mid', 11194),
(172, 45, 1, 'Китай', 'images/countryFlags/Китай.png', 'Zheng Jie', 'ghost', '0000-00-00', 'images/playerPhotos/ghost.png', 3, 'Hard', 17119),
(173, 49, 1, 'Сингапур', 'images/countryFlags/Сингапур.png', '&ndash;', 'boyan', '0000-00-00', 'images/playerPhotos/boyan.png', 1, 'Safe', 120),
(174, 50, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Yeong Shi Jie', 'Mercury', '0000-00-00', 'images/playerPhotos/Mercury.png', 1, 'Safe', 2171),
(175, 50, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Chua Soon Khong', 'KaNG', '0000-00-00', 'images/playerPhotos/KaNG.png', 3, 'Hard', 47029),
(176, 50, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Cheong Zhi Ying', 'czy', '0000-00-00', 'images/playerPhotos/czy.png', 5, 'Safe', 1610),
(177, 50, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Tan Kai Soon', 'TrazaM', '0000-00-00', 'images/playerPhotos/TrazaM.png', 5, 'Hard', 2121),
(178, 53, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', '&ndash;', 'Nevermine', '0000-00-00', 'images/playerPhotos/Nevermine.png', 3, 'Hard', 78),
(179, 53, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', 'Thanathorn Sriiamkoon', 'tnt', '0000-00-00', 'images/playerPhotos/tnt.png', 5, 'Hard', 4512),
(180, 53, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Ahmad Syazwan Bin Anuar', 'ADTR', '0000-00-00', 'images/playerPhotos/ADTR.png', 5, 'Safe', 1430),
(181, 54, 1, 'Мьянма', 'images/countryFlags/Мьянма.png', 'Myint Myat Zaw', 'InsaNe', '0000-00-00', 'images/playerPhotos/InsaNe.png', 1, 'Safe', 550),
(182, 54, 1, 'Мьянма', 'images/countryFlags/Мьянма.png', '&ndash;', 'Leo', '0000-00-00', 'images/playerPhotos/Leo.png', 2, 'Mid', 550),
(183, 54, 1, 'Мьянма', 'images/countryFlags/Мьянма.png', 'Aung Myat Soe ti', 'ShowT', '0000-00-00', 'images/playerPhotos/ShowT.png', 3, 'Hard', 550),
(184, 54, 1, 'Мьянма', 'images/countryFlags/Мьянма.png', '&ndash;', 'KENJI', '0000-00-00', 'images/playerPhotos/KENJI.png', 5, 'Safe', 550),
(185, 54, 1, 'Мьянма', 'images/countryFlags/Мьянма.png', '&ndash;', 'raprap', '0000-00-00', 'images/playerPhotos/raprap.png', 5, 'Hard', 550),
(186, 150, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', '&ndash;', 'Palos', '0000-00-00', 'images/playerPhotos/Palos.png', 1, 'Safe', 387),
(187, 150, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Jonas Samonte', 'Nasjo', '0000-00-00', 'images/playerPhotos/Nasjo.png', 2, 'Mid', 1087),
(188, 150, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', '&ndash;', 'MOki', '0000-00-00', 'images/playerPhotos/MOki.png', 3, 'Hard', 387),
(189, 150, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', '&ndash;', 'Efking', '0000-00-00', 'images/playerPhotos/Efking.png', 5, 'Hard', 387),
(190, 150, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', '&ndash;', 'Ronn', '0000-00-00', 'images/playerPhotos/Ronn.png', 5, 'Safe', 387),
(191, 58, 1, 'Индонезия', 'images/countryFlags/Индонезия.png', '&ndash;', 'Ifr1t!', '0000-00-00', 'images/playerPhotos/Ifr1t!.png', 1, 'Hard', 3600),
(192, 58, 1, 'Индонезия', 'images/countryFlags/Индонезия.png', 'Muhammad Lutfi', 'Azur4', '0000-00-00', 'images/playerPhotos/Azur4.png', 2, 'Mid', 3878),
(193, 58, 1, 'Индонезия', 'images/countryFlags/Индонезия.png', 'Fahmi Choirul', 'Huppey', '0000-00-00', 'images/playerPhotos/Huppey.png', 5, 'Hard', 3556),
(194, 58, 1, 'Индонезия', 'images/countryFlags/Индонезия.png', '&ndash;', 'SPACEMAN', '0000-00-00', 'images/playerPhotos/SPACEMAN.png', 5, 'Hard', 3528),
(195, 59, 1, 'Лаос', 'images/countryFlags/Лаос.png', 'Souliya Khoomphetsavong', 'Jaccky', '0000-00-00', 'images/playerPhotos/Jaccky.png', 1, 'Safe', 78),
(196, 59, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', '&ndash;', 'WhatThe', '0000-00-00', 'images/playerPhotos/WhatThe.png', 3, 'Hard', 914),
(197, 60, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Marc Mamales', 'Marc', '0000-00-00', 'images/playerPhotos/Marc.png', 2, 'Mid', 4240),
(198, 60, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Abeng Dicdican', 'Abeng', '0000-00-00', 'images/playerPhotos/Abeng.png', 5, 'Safe', 4649),
(199, 60, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Ralph Richard Peñano', 'RR', '0000-00-00', 'images/playerPhotos/RR.png', 5, 'Hard', 52559),
(200, 64, 1, 'Вьетнам', 'images/countryFlags/Вьетнам.png', 'Trần Duy Anh', 'SADBOY', '0000-00-00', 'images/playerPhotos/SADBOY.png', 1, 'Safe', 100),
(201, 65, 1, 'Вьетнам', 'images/countryFlags/Вьетнам.png', 'Huỳnh Hữu Nghĩa', 'Magical', '0000-00-00', 'images/playerPhotos/Magical.png', 5, 'Safe', 200),
(202, 70, 1, 'Вьетнам', 'images/countryFlags/Вьетнам.png', '&ndash;', 'TrEdO', '0000-00-00', 'images/playerPhotos/TrEdO.png', 3, 'Hard', 734),
(203, 70, 1, 'Вьетнам', 'images/countryFlags/Вьетнам.png', 'Vương Thiện Tài', 'SeeL', '0000-00-00', 'images/playerPhotos/SeeL.png', 5, 'Safe', 1481),
(204, 70, 1, 'Вьетнам', 'images/countryFlags/Вьетнам.png', 'Nguyễn Châu Lôi', 'Yasy', '0000-00-00', 'images/playerPhotos/Yasy.png', 5, 'Hard', 534),
(205, 71, 1, 'Вьетнам', 'images/countryFlags/Вьетнам.png', 'Dương Phan Nhật Toàn', 'TenGu', '0000-00-00', 'images/playerPhotos/TenGu.png', 5, 'Safe', 660),
(206, 50, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Yeong Shi Jie', 'Mercury', '0000-00-00', 'images/playerPhotos/Mercury.png', 1, 'Safe', 2171),
(207, 50, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Chua Soon Khong', 'KaNG', '0000-00-00', 'images/playerPhotos/KaNG.png', 3, 'Hard', 47029),
(208, 50, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Cheong Zhi Ying', 'czy', '0000-00-00', 'images/playerPhotos/czy.png', 5, 'Safe', 1610),
(209, 50, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Tan Kai Soon', 'TrazaM', '0000-00-00', 'images/playerPhotos/TrazaM.png', 5, 'Hard', 2121),
(210, 72, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Fua Hsien Wan', 'Lance', '0000-00-00', 'images/playerPhotos/Lance.png', 1, 'Safe', 6200),
(211, 72, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Kok Yi Liong', 'ddz', '0000-00-00', 'images/playerPhotos/ddz.png', 2, 'Mid', 6640),
(212, 72, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', '&ndash;', 'Bored', '0000-00-00', 'images/playerPhotos/Bored.png', 3, 'Hard', 555),
(213, 72, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Goh Choo Jian', 'MoZuN', '0000-00-00', 'images/playerPhotos/MoZuN.png', 5, 'Safe', 6742),
(214, 77, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Lee Jia He', 'Chidori~', '0000-00-00', 'images/playerPhotos/Chidori~.png', 1, 'Safe', 510),
(215, 78, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', '&ndash;', 'Earnzamax', '0000-00-00', 'images/playerPhotos/Earnzamax.png', 3, 'Safe', 116),
(216, 78, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', '&ndash;', 'reNniw', '0000-00-00', 'images/playerPhotos/reNniw.png', 5, 'Hard', 348),
(217, 79, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', '&ndash;', 'Masaros', '0000-00-00', 'images/playerPhotos/Masaros.png', 3, 'Hard', 116),
(218, 79, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', 'Supanut Chow', 'LionaX', '0000-00-00', 'images/playerPhotos/LionaX.png', 5, 'Hard', 3045),
(219, 53, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', '&ndash;', 'Nevermine', '0000-00-00', 'images/playerPhotos/Nevermine.png', 3, 'Hard', 78),
(220, 53, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', 'Thanathorn Sriiamkoon', 'tnt', '0000-00-00', 'images/playerPhotos/tnt.png', 5, 'Hard', 4512),
(221, 53, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Ahmad Syazwan Bin Anuar', 'ADTR', '0000-00-00', 'images/playerPhotos/ADTR.png', 5, 'Safe', 1430),
(222, 59, 1, 'Лаос', 'images/countryFlags/Лаос.png', 'Souliya Khoomphetsavong', 'Jaccky', '0000-00-00', 'images/playerPhotos/Jaccky.png', 1, 'Safe', 78),
(223, 59, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', '&ndash;', 'WhatThe', '0000-00-00', 'images/playerPhotos/WhatThe.png', 3, 'Hard', 914),
(224, 82, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', 'Patipat Nussayateerasarn', 'Peter', '0000-00-00', 'images/playerPhotos/Peter.png', 1, 'Safe', 542),
(225, 82, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', 'Posathorn Kasemsawat', 'SoLotic', '0000-00-00', 'images/playerPhotos/SoLotic.png', 3, 'Hard', 3327),
(226, 82, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', 'Kanokkorn Hirungue', 'Varen', '0000-00-00', 'images/playerPhotos/Varen.png', 5, 'Hard', 1200),
(227, 83, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', '&ndash;', 'mn', '0000-00-00', 'images/playerPhotos/mn.png', 2, 'Mid', 348),
(228, 83, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', 'Rungpetch Yuenying', 'Rpyy', '0000-00-00', 'images/playerPhotos/Rpyy.png', 5, 'Roaming', 113),
(229, 83, 1, 'Тайланд', 'images/countryFlags/Тайланд.png', 'Saharat Thawornsusin', 'divasa', '0000-00-00', 'images/playerPhotos/divasa.png', 5, 'Hard', 61),
(230, 29, 1, 'Канада', 'images/countryFlags/Канада.png', 'Jacky Mao', 'EternaLEnVy', '0000-00-00', 'images/playerPhotos/EternaLEnVy.png', 1, 'Safe', 746269),
(231, 29, 1, 'США', 'images/countryFlags/США.png', 'Braxton Paulson', 'Brax', '0000-00-00', 'images/playerPhotos/Brax.png', 3, 'Hard', 20820),
(232, 29, 1, 'США', 'images/countryFlags/США.png', 'Michael Ghannam', 'ixmike88', '0000-00-00', 'images/playerPhotos/ixmike88.png', 5, 'Safe', 16737),
(233, 28, 1, 'Сингапур', 'images/countryFlags/Сингапур.png', 'Galvin Kang Jian Wen', 'Meracle', '0000-00-00', 'images/playerPhotos/Meracle.png', 1, 'Safe', 22137),
(234, 28, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Linus Blomdin', 'Limmp', '0000-00-00', 'images/playerPhotos/Limmp.png', 2, 'Mid', 195285),
(235, 28, 1, 'США', 'images/countryFlags/США.png', 'Jaron Clinton', 'monkeys-forever', '0000-00-00', 'images/playerPhotos/monkeys-forever.png', 3, 'Hard', 25873),
(236, 28, 1, 'США', 'images/countryFlags/США.png', 'Zakari Freedman', 'Zfreek', '0000-00-00', 'images/playerPhotos/Zfreek.png', 5, 'Hard', 166264),
(237, 85, 1, 'Канада', 'images/countryFlags/Канада.png', 'Zheng Yukai', 'PatSoul', '0000-00-00', 'images/playerPhotos/PatSoul.png', 3, 'Hard', 1500),
(238, 85, 1, 'Сингапур', 'images/countryFlags/Сингапур.png', 'Nicholas Lim', 'xfreedom', '0000-00-00', 'images/playerPhotos/xfreedom.png', 5, 'Hard', 500),
(239, 85, 1, 'США', 'images/countryFlags/США.png', 'Yixuan Guo', 'xuan', '0000-00-00', 'images/playerPhotos/xuan.png', 5, 'Safe', 1900),
(240, 86, 1, 'США', 'images/countryFlags/США.png', 'Ravindu Kodippili', 'ritsu', '0000-00-00', 'images/playerPhotos/ritsu.png', 1, 'Safe', 19065),
(241, 29, 1, 'США', 'images/countryFlags/США.png', 'Eric Dong', 'Ryoya', '0000-00-00', 'images/playerPhotos/Ryoya.png', 2, 'Mid', 33935),
(242, 86, 1, 'Канада', 'images/countryFlags/Канада.png', 'David Tan', 'MoonMeander', '0000-00-00', 'images/playerPhotos/MoonMeander.png', 3, 'Hard', 788482),
(243, 86, 1, 'Канада', 'images/countryFlags/Канада.png', 'Andrew Evelynn', 'Jubei', '0000-00-00', 'images/playerPhotos/Jubei.png', 5, 'Safe', 7010),
(244, 86, 1, 'Канада', 'images/countryFlags/Канада.png', 'Noah Minhas', 'Boris', '0000-00-00', 'images/playerPhotos/Boris.png', 5, 'Hard', 4230),
(245, 76, 1, 'Перу', 'images/countryFlags/Перу.png', 'Jeremy Aguinaga', 'Jeimari', '0000-00-00', 'images/playerPhotos/Jeimari.png', 2, 'Mid', 6200),
(246, 76, 1, 'Перу', 'images/countryFlags/Перу.png', 'Christian Cruz', 'Accel', '0000-00-00', 'images/playerPhotos/Accel.png', 5, 'Safe', 81738),
(247, 76, 1, 'Перу', 'images/countryFlags/Перу.png', 'Farith Puente', 'Matthew', '0000-00-00', 'images/playerPhotos/Matthew.png', 5, 'Hard', 44240),
(248, 88, 1, 'Мексика', 'images/countryFlags/Мексика.png', 'Jose Coronel', 'esk', '0000-00-00', 'images/playerPhotos/esk.png', 2, 'Mid', 130),
(249, 88, 1, 'Мексика', 'images/countryFlags/Мексика.png', 'Alejandro Moreno', 'Jano', '0000-00-00', 'images/playerPhotos/Jano.png', 3, 'Hard', 130),
(250, 89, 1, 'Россия', 'images/countryFlags/Россия.png', 'Leonid Kuzmenkov', 'Sonic', '0000-00-00', 'images/playerPhotos/Sonic.png', 5, 'Safe', 1881),
(251, 148, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', '&ndash;', 'Goaty', '0000-00-00', 'images/playerPhotos/Goaty.png', 5, 'Safe', 100),
(252, 150, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', '&ndash;', 'Palos', '0000-00-00', 'images/playerPhotos/Palos.png', 1, 'Safe', 387),
(253, 150, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Jonas Samonte', 'Nasjo', '0000-00-00', 'images/playerPhotos/Nasjo.png', 2, 'Mid', 1087),
(254, 150, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', '&ndash;', 'MOki', '0000-00-00', 'images/playerPhotos/MOki.png', 3, 'Hard', 387),
(255, 150, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', '&ndash;', 'Efking', '0000-00-00', 'images/playerPhotos/Efking.png', 5, 'Hard', 387),
(256, 150, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', '&ndash;', 'Ronn', '0000-00-00', 'images/playerPhotos/Ronn.png', 5, 'Safe', 387),
(257, 151, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Fernando Mendoza', 'Nando', '0000-00-00', 'images/playerPhotos/Nando.png', 1, 'Safe', 44076),
(258, 151, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', '&ndash;', 'Van', '0000-00-00', 'images/playerPhotos/Van.png', 3, 'Hard', 2175),
(259, 151, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Erice Guerra', 'Erice', '0000-00-00', 'images/playerPhotos/Erice.png', 5, 'Hard', 3635),
(260, 151, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', '&ndash;', 'Grimzx', '0000-00-00', 'images/playerPhotos/Grimzx.png', 5, 'Safe', 10775),
(261, 90, 1, 'Австралия', 'images/countryFlags/Австралия.png', 'Nick Capeski', 'Splicko', '0000-00-00', 'images/playerPhotos/Splicko.png', 2, 'Mid', 2371),
(262, 90, 1, 'Австралия', 'images/countryFlags/Австралия.png', 'James Lee', 'XemistrY', '0000-00-00', 'images/playerPhotos/XemistrY.png', 2, 'Mid', 4211),
(263, 90, 1, 'Австралия', 'images/countryFlags/Австралия.png', 'Tuan Nguyen', 'TEKCOR', '0000-00-00', 'images/playerPhotos/TEKCOR.png', 3, 'Hard', 2157),
(264, 92, 1, 'Австралия', 'images/countryFlags/Австралия.png', '&ndash;', 'Reverie', '0000-00-00', 'images/playerPhotos/Reverie.png', 2, 'Mid', 219),
(265, 92, 1, 'Австралия', 'images/countryFlags/Австралия.png', 'Justin Yuen', 'xMusiCa', '0000-00-00', 'images/playerPhotos/xMusiCa.png', 3, 'Hard', 8111),
(266, 92, 1, 'Австралия', 'images/countryFlags/Австралия.png', 'Tobias Sveaas', 'Tobz', '0000-00-00', 'images/playerPhotos/Tobz.png', 5, 'Safe', 291),
(267, 92, 1, 'Австралия', 'images/countryFlags/Австралия.png', '&ndash;', 'Poyo', '0000-00-00', 'images/playerPhotos/Poyo.png', 5, 'Hard', 219),
(268, 96, 1, 'Болгария', 'images/countryFlags/Болгария.png', 'Nikolay Nikolov', 'Nikobaby', '0000-00-00', 'images/playerPhotos/Nikobaby.png', 1, 'Safe', 3482),
(269, 96, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Chong Wei Lun', 'FelixCiaoBa', '0000-00-00', 'images/playerPhotos/FelixCiaoBa.png', 5, 'Hard', 6852),
(270, 97, 1, 'Китай', 'images/countryFlags/Китай.png', 'Mo Jian', 'Veng', '0000-00-00', 'images/playerPhotos/Veng.png', 1, 'Safe', 301),
(271, 58, 1, 'Индонезия', 'images/countryFlags/Индонезия.png', '&ndash;', 'Ifr1t!', '0000-00-00', 'images/playerPhotos/Ifr1t!.png', 1, 'Hard', 3600),
(272, 58, 1, 'Индонезия', 'images/countryFlags/Индонезия.png', 'Muhammad Lutfi', 'Azur4', '0000-00-00', 'images/playerPhotos/Azur4.png', 2, 'Mid', 3878),
(273, 58, 1, 'Индонезия', 'images/countryFlags/Индонезия.png', 'Fahmi Choirul', 'Huppey', '0000-00-00', 'images/playerPhotos/Huppey.png', 5, 'Hard', 3556),
(274, 58, 1, 'Индонезия', 'images/countryFlags/Индонезия.png', '&ndash;', 'SPACEMAN', '0000-00-00', 'images/playerPhotos/SPACEMAN.png', 5, 'Hard', 3528),
(275, 99, 1, 'Индия', 'images/countryFlags/Индия.png', 'Balaji Ramnarayan', 'BlizzarD', '0000-00-00', 'images/playerPhotos/BlizzarD.png', 1, 'Safe', 10531),
(276, 99, 1, 'Индия', 'images/countryFlags/Индия.png', 'Jeet Kundra', 'Swifty', '0000-00-00', 'images/playerPhotos/Swifty.png', 2, 'Mid', 10531),
(277, 99, 1, 'Индия', 'images/countryFlags/Индия.png', 'Raunak Sen', 'Crowley', '0000-00-00', 'images/playerPhotos/Crowley.png', 5, 'Hard', 10531),
(278, 99, 1, 'Индия', 'images/countryFlags/Индия.png', 'Dhvanit Negi', 'Negi', '0000-00-00', 'images/playerPhotos/Negi.png', 5, 'Safe', 9781),
(279, 54, 1, 'Мьянма', 'images/countryFlags/Мьянма.png', 'Myint Myat Zaw', 'InsaNe', '0000-00-00', 'images/playerPhotos/InsaNe.png', 1, 'Safe', 550),
(280, 54, 1, 'Мьянма', 'images/countryFlags/Мьянма.png', '&ndash;', 'Leo', '0000-00-00', 'images/playerPhotos/Leo.png', 2, 'Mid', 550),
(281, 54, 1, 'Мьянма', 'images/countryFlags/Мьянма.png', 'Aung Myat Soe ti', 'ShowT', '0000-00-00', 'images/playerPhotos/ShowT.png', 3, 'Hard', 550),
(282, 54, 1, 'Мьянма', 'images/countryFlags/Мьянма.png', '&ndash;', 'KENJI', '0000-00-00', 'images/playerPhotos/KENJI.png', 5, 'Safe', 550),
(283, 54, 1, 'Мьянма', 'images/countryFlags/Мьянма.png', '&ndash;', 'raprap', '0000-00-00', 'images/playerPhotos/raprap.png', 5, 'Hard', 550),
(284, 60, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Marc Mamales', 'Marc', '0000-00-00', 'images/playerPhotos/Marc.png', 2, 'Mid', 4240),
(285, 60, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Abeng Dicdican', 'Abeng', '0000-00-00', 'images/playerPhotos/Abeng.png', 5, 'Safe', 4649),
(286, 60, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Ralph Richard Peñano', 'RR', '0000-00-00', 'images/playerPhotos/RR.png', 5, 'Hard', 52559),
(287, 72, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Fua Hsien Wan', 'Lance', '0000-00-00', 'images/playerPhotos/Lance.png', 1, 'Safe', 6200),
(288, 72, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Kok Yi Liong', 'ddz', '0000-00-00', 'images/playerPhotos/ddz.png', 2, 'Mid', 6640),
(289, 72, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', '&ndash;', 'Bored', '0000-00-00', 'images/playerPhotos/Bored.png', 3, 'Hard', 555),
(290, 72, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Goh Choo Jian', 'MoZuN', '0000-00-00', 'images/playerPhotos/MoZuN.png', 5, 'Safe', 6742),
(291, 60, 1, 'Филиппины', 'images/countryFlags/Филиппины.png', 'Ralph Richard Peñano', 'RR', '0000-00-00', 'images/playerPhotos/RR.png', 5, 'Hard', 52559),
(292, 64, 1, 'Вьетнам', 'images/countryFlags/Вьетнам.png', 'Trần Duy Anh', 'SADBOY', '0000-00-00', 'images/playerPhotos/SADBOY.png', 1, 'Safe', 100),
(293, 71, 1, 'Вьетнам', 'images/countryFlags/Вьетнам.png', 'Dương Phan Nhật Toàn', 'TenGu', '0000-00-00', 'images/playerPhotos/TenGu.png', 5, 'Safe', 660),
(294, 104, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Max Barkö', 'Mikey', '0000-00-00', 'images/playerPhotos/Mikey.png', 3, 'Hard', 1758),
(295, 104, 1, 'Дания', 'images/countryFlags/Дания.png', 'Sebastian Kjær', 'Solen', '0000-00-00', 'images/playerPhotos/Solen.png', 5, 'Safe', 1608),
(296, 104, 1, 'Польша', 'images/countryFlags/Польша.png', 'Jakub Kocjan', 'Kacor', '0000-00-00', 'images/playerPhotos/Kacor.png', 5, 'Hard', 22250),
(297, 105, 1, 'Чехия', 'images/countryFlags/Чехия.png', 'Ondřej Štarha', 'Supream^', '0000-00-00', 'images/playerPhotos/Supream^.png', 1, 'Mid', 1000),
(298, 105, 1, 'Чехия', 'images/countryFlags/Чехия.png', 'Vojtech Novak', 'Curry', '0000-00-00', 'images/playerPhotos/Curry.png', 3, 'Mid', 1000),
(299, 105, 1, 'Чехия', 'images/countryFlags/Чехия.png', 'Jonáš Volek', 'SaberLight', '0000-00-00', 'images/playerPhotos/SaberLight.png', 1, 'Hard', 1000),
(300, 105, 1, 'Чехия', 'images/countryFlags/Чехия.png', 'Petr Fojtík', 'muf', '0000-00-00', 'images/playerPhotos/muf.png', 5, 'Hard', 1000),
(301, 105, 1, 'Чехия', 'images/countryFlags/Чехия.png', 'Jan Sehnal', 'sehny', '0000-00-00', 'images/playerPhotos/sehny.png', 5, 'Hard', 1400),
(302, 106, 1, 'Казахстан', 'images/countryFlags/Казахстан.png', 'Малик Сайлау', 'Malik', '0000-00-00', 'images/playerPhotos/Malik.png', 3, 'Hard', 340),
(303, 106, 1, 'Казахстан', 'images/countryFlags/Казахстан.png', 'Dulat Seidimomyn', 'goddam', '0000-00-00', 'images/playerPhotos/goddam.png', 5, 'Safe', 21722),
(304, 68, 1, 'Казахстан', 'images/countryFlags/Казахстан.png', 'Danial Alibaev', 'XSvamp1Re', '0000-00-00', 'images/playerPhotos/XSvamp1Re.png', 5, 'Roaming', 2800),
(305, 107, 1, 'Германия', 'images/countryFlags/Германия.png', 'Henrik Schütz', 'Lexam', '0000-00-00', 'images/playerPhotos/Lexam.png', 1, 'Safe', 99),
(306, 107, 1, 'Германия', 'images/countryFlags/Германия.png', 'Baba Marv', 'Sile', '0000-00-00', 'images/playerPhotos/Sile.png', 2, 'Mid', 99),
(307, 107, 1, 'Германия', 'images/countryFlags/Германия.png', 'Kraven Hunter', 'Kraven', '0000-00-00', 'images/playerPhotos/Kraven.png', 1, 'Safe', 99),
(308, 107, 1, 'Германия', 'images/countryFlags/Германия.png', '&ndash;', 'kacks', '0000-00-00', 'images/playerPhotos/kacks.png', 5, 'Safe', 99),
(309, 107, 1, 'Германия', 'images/countryFlags/Германия.png', 'Warum Bitte', 'Liminality', '0000-00-00', 'images/playerPhotos/Liminality.png', 5, 'Safe', 99),
(310, 19, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Steve Zi Shan Ye', 'Xcalibur', '0000-00-00', 'images/playerPhotos/Xcalibur.png', 1, 'Safe', 18686),
(311, 19, 1, 'Словения', 'images/countryFlags/Словения.png', 'Jure Plešej', 'Pingvincek', '0000-00-00', 'images/playerPhotos/Pingvincek.png', 2, 'Mid', 7790),
(312, 19, 1, 'Россия', 'images/countryFlags/Россия.png', 'Maxim Abramovskikh', 'Shachlo', '0000-00-00', 'images/playerPhotos/Shachlo.png', 3, 'Hard', 15544),
(313, 19, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Jerry Lundkvist', 'EGM', '0000-00-00', 'images/playerPhotos/EGM.png', 5, 'Hard', 580415),
(314, 19, 1, 'Россия', 'images/countryFlags/Россия.png', 'Yaroslav Naidenov', 'Miposhka', '0000-00-00', 'images/playerPhotos/Miposhka.png', 5, 'Safe', 211278),
(315, 24, 1, 'Беларусь', 'images/countryFlags/Беларусь.png', 'Aleksandr Zalivako', 'Pio65', '0000-00-00', 'images/playerPhotos/Pio65.png', 1, 'Safe', 374),
(316, 24, 1, 'Беларусь', 'images/countryFlags/Беларусь.png', 'Egor Kozlov', 'Ergon', '0000-00-00', 'images/playerPhotos/Ergon.png', 2, 'Mid', 74),
(317, 24, 1, 'Беларусь', 'images/countryFlags/Беларусь.png', 'Vladislav Kozlovskij', 'kazl', '0000-00-00', 'images/playerPhotos/kazl.png', 3, 'Hard', 74),
(318, 24, 1, 'Беларусь', 'images/countryFlags/Беларусь.png', 'Siarhei Kharonzhy', 'HappyDyurara', '0000-00-00', 'images/playerPhotos/HappyDyurara.png', 5, 'Hard', 74),
(319, 24, 1, 'Беларусь', 'images/countryFlags/Беларусь.png', 'Maksim Cymanovich', 'Tsyman', '0000-00-00', 'images/playerPhotos/Tsyman.png', 5, 'Safe', 174),
(320, 109, 1, 'Украина', 'images/countryFlags/Украина.png', 'Alik Vorobej', 'V-Tune', '0000-00-00', 'images/playerPhotos/V-Tune.png', 1, 'Safe', 250),
(321, 109, 1, 'Россия', 'images/countryFlags/Россия.png', 'Dmitry Bolshakov', 'UnderShock', '0000-00-00', 'images/playerPhotos/UnderShock.png', 2, 'Mid', 22551),
(322, 109, 1, 'Украина', 'images/countryFlags/Украина.png', 'Gleb Lipatnikov', 'Funn1k', '0000-00-00', 'images/playerPhotos/Funn1k.png', 3, 'Hard', 226378),
(323, 109, 1, 'Россия', 'images/countryFlags/Россия.png', 'Khaled El-khabbash', 'sQreen', '0000-00-00', 'images/playerPhotos/sQreen.png', 5, 'Safe', 4561),
(324, 109, 1, 'Украина', 'images/countryFlags/Украина.png', 'Sergey Slobodyanyk', 'EcNart', '0000-00-00', 'images/playerPhotos/EcNart.png', 5, 'Hard', 4350),
(325, 111, 1, 'Россия', 'images/countryFlags/Россия.png', 'Rodion Fomkin', 'MYSmoon', '0000-00-00', 'images/playerPhotos/MYSmoon.png', 3, 'Hard', 509),
(326, 110, 1, 'Дания', 'images/countryFlags/Дания.png', 'Mikki Mørch Junget', 'HeStEJoE-RoTTeN', '0000-00-00', 'images/playerPhotos/HeStEJoE-RoTTeN.png', 3, 'Hard', 110576),
(327, 110, 1, 'Румыния', 'images/countryFlags/Румыния.png', 'Alexandru Craciunescu', 'ComeWithMe', '0000-00-00', 'images/playerPhotos/ComeWithMe.png', 5, 'Safe', 11041),
(328, 110, 1, 'Ливан', 'images/countryFlags/Ливан.png', '&ndash;', 'Eixn', '0000-00-00', 'images/playerPhotos/Eixn.png', 5, 'Hard', 1336),
(329, 111, 1, 'Россия', 'images/countryFlags/Россия.png', 'Rodion Fomkin', 'MYSmoon', '0000-00-00', 'images/playerPhotos/MYSmoon.png', 3, 'Hard', 509),
(330, 113, 1, 'США', 'images/countryFlags/США.png', '&ndash;', 'pingudota2006', '0000-00-00', 'images/playerPhotos/pingudota2006.png', 1, 'Safe', 200),
(331, 115, 1, 'Перу', 'images/countryFlags/Перу.png', '&ndash;', 'Babypure', '0000-00-00', 'images/playerPhotos/Babypure.png', 1, 'Safe', 400),
(332, 115, 1, 'Перу', 'images/countryFlags/Перу.png', 'Jose Andree Nicosia', 'Sword', '0000-00-00', 'images/playerPhotos/Sword.png', 3, 'Hard', 6912),
(333, 115, 1, 'Перу', 'images/countryFlags/Перу.png', 'Romel Quinteros', 'Wu', '0000-00-00', 'images/playerPhotos/Wu.png', 5, 'Safe', 5000);
INSERT INTO `players` (`idPlayer`, `idTeam`, `idDiscipline`, `country`, `countryFlag`, `name`, `nickname`, `birthday`, `photoRef`, `idRole`, `line`, `prize`) VALUES
(334, 116, 1, 'США', 'images/countryFlags/США.png', '&ndash;', 'Berlin', '0000-00-00', 'images/playerPhotos/Berlin.png', 2, 'Mid', 130),
(335, 116, 1, 'США', 'images/countryFlags/США.png', '&ndash;', 'Orange', '0000-00-00', 'images/playerPhotos/Orange.png', 5, 'Hard', 100),
(336, 10, 1, 'Великобритания', 'images/countryFlags/Великобритания.png', 'Omar Dabasas', 'Madara', '0000-00-00', 'images/playerPhotos/Madara.png', 1, 'Safe', 143580),
(337, 117, 1, 'Перу', 'images/countryFlags/Перу.png', '&ndash;', 'leone', '0000-00-00', 'images/playerPhotos/leone.png', 3, 'Hard', 512),
(338, 117, 1, 'Перу', 'images/countryFlags/Перу.png', '&ndash;', 'Ireal', '0000-00-00', 'images/playerPhotos/Ireal.png', 5, 'Safe', 400),
(339, 88, 1, 'Мексика', 'images/countryFlags/Мексика.png', 'Jose Coronel', 'esk', '0000-00-00', 'images/playerPhotos/esk.png', 2, 'Mid', 130),
(340, 88, 1, 'Мексика', 'images/countryFlags/Мексика.png', 'Alejandro Moreno', 'Jano', '0000-00-00', 'images/playerPhotos/Jano.png', 3, 'Hard', 130),
(341, 119, 1, 'Колумбия', 'images/countryFlags/Колумбия.png', '&ndash;', 'TeD', '0000-00-00', 'images/playerPhotos/TeD.png', 3, 'Safe', 400),
(342, 119, 1, 'Перу', 'images/countryFlags/Перу.png', 'Sergio Toribio', 'Prada', '0000-00-00', 'images/playerPhotos/Prada.png', 5, 'Hard', 5452),
(343, 120, 1, 'США', 'images/countryFlags/США.png', '&ndash;', 'yamsun', '0000-00-00', 'images/playerPhotos/yamsun.png', 1, 'Safe', 580),
(344, 120, 1, 'США', 'images/countryFlags/США.png', '&ndash;', 'AlienManaBanana', '0000-00-00', 'images/playerPhotos/AlienManaBanana.png', 2, 'Mid', 100),
(345, 120, 1, 'США', 'images/countryFlags/США.png', '&ndash;', 'Speeed', '0000-00-00', 'images/playerPhotos/Speeed.png', 3, 'Hard', 530),
(346, 120, 1, 'США', 'images/countryFlags/США.png', '&ndash;', 'DoublA', '0000-00-00', 'images/playerPhotos/DoublA.png', 5, 'Safe', 200),
(347, 120, 1, 'США', 'images/countryFlags/США.png', '&ndash;', 'Oceania', '0000-00-00', 'images/playerPhotos/Oceania.png', 5, 'Hard', 300),
(348, 121, 1, 'Перу', 'images/countryFlags/Перу.png', '&ndash;', 'Garou', '0000-00-00', 'images/playerPhotos/Garou.png', 1, 'Safe', 300),
(349, 121, 1, 'Перу', 'images/countryFlags/Перу.png', '&ndash;', 'Zone', '0000-00-00', 'images/playerPhotos/Zone.png', 2, 'Mid', 100),
(350, 121, 1, 'Перу', 'images/countryFlags/Перу.png', 'Benjamín Lanao Barrios', 'Benjaz', '0000-00-00', 'images/playerPhotos/Benjaz.png', 3, 'Hard', 48811),
(351, 121, 1, 'Перу', 'images/countryFlags/Перу.png', 'Diego Armando Rivera Jimenez', 'J3R1CHO', '0000-00-00', 'images/playerPhotos/J3R1CHO.png', 5, 'Safe', 5533),
(352, 121, 1, 'Перу', 'images/countryFlags/Перу.png', 'Steve Vargas', 'StingeR', '0000-00-00', 'images/playerPhotos/StingeR.png', 5, 'Hard', 50193),
(353, 115, 1, 'Перу', 'images/countryFlags/Перу.png', '&ndash;', 'Babypure', '0000-00-00', 'images/playerPhotos/Babypure.png', 1, 'Safe', 400),
(354, 115, 1, 'Перу', 'images/countryFlags/Перу.png', 'Jose Andree Nicosia', 'Sword', '0000-00-00', 'images/playerPhotos/Sword.png', 3, 'Hard', 6912),
(355, 115, 1, 'Перу', 'images/countryFlags/Перу.png', 'Romel Quinteros', 'Wu', '0000-00-00', 'images/playerPhotos/Wu.png', 5, 'Safe', 5000),
(356, 122, 1, 'Бразилия', 'images/countryFlags/Бразилия.png', 'Caio Oliveira', 'Nuages', '0000-00-00', 'images/playerPhotos/Nuages.png', 5, 'Safe', 217),
(357, 123, 1, 'Перу', 'images/countryFlags/Перу.png', 'Freddy Sina', 'Smash', '0000-00-00', 'images/playerPhotos/Smash.png', 3, 'Hard', 16184),
(358, 123, 1, 'Перу', 'images/countryFlags/Перу.png', 'Juan Carlos Tito Carrizales', 'vanN', '0000-00-00', 'images/playerPhotos/vanN.png', 2, 'Mid', 18528),
(359, 123, 1, 'Перу', 'images/countryFlags/Перу.png', 'Ricardo Román Sandoval', 'Mstco', '0000-00-00', 'images/playerPhotos/Mstco.png', 5, 'Roaming', 11384),
(360, 123, 1, 'Перу', 'images/countryFlags/Перу.png', 'Alex Dávila', 'Masoku', '0000-00-00', 'images/playerPhotos/Masoku.png', 5, 'Safe', 16341),
(361, 121, 1, 'Перу', 'images/countryFlags/Перу.png', '&ndash;', 'Garou', '0000-00-00', 'images/playerPhotos/Garou.png', 1, 'Safe', 300),
(362, 115, 1, 'Перу', 'images/countryFlags/Перу.png', 'Jose Andree Nicosia', 'Sword', '0000-00-00', 'images/playerPhotos/Sword.png', 3, 'Hard', 6912),
(363, 76, 1, 'Перу', 'images/countryFlags/Перу.png', 'Christian Cruz', 'Accel', '0000-00-00', 'images/playerPhotos/Accel.png', 5, 'Safe', 81738),
(364, 119, 1, 'Колумбия', 'images/countryFlags/Колумбия.png', '&ndash;', 'TeD', '0000-00-00', 'images/playerPhotos/TeD.png', 3, 'Safe', 400),
(365, 119, 1, 'Перу', 'images/countryFlags/Перу.png', 'Sergio Toribio', 'Prada', '0000-00-00', 'images/playerPhotos/Prada.png', 5, 'Hard', 5452),
(366, 117, 1, 'Перу', 'images/countryFlags/Перу.png', '&ndash;', 'Ireal', '0000-00-00', 'images/playerPhotos/Ireal.png', 5, 'Safe', 400),
(367, 128, 1, 'Перу', 'images/countryFlags/Перу.png', 'Hector Antonio Rodriguez', 'K1', '0000-00-00', 'images/playerPhotos/K1.png', 1, 'Safe', 6480),
(368, 128, 1, 'Перу', 'images/countryFlags/Перу.png', 'Junior Reyes Rimari', 'Yadomi', '0000-00-00', 'images/playerPhotos/Yadomi.png', 5, 'Safe', 5450),
(369, 4, 1, 'Дания', 'images/countryFlags/Дания.png', 'Marcus Hoelgaard', 'Ace', '0000-00-00', 'images/playerPhotos/Ace.png', 1, 'Safe', 664390),
(370, 4, 1, 'Македония', 'images/countryFlags/Македония.png', 'Martin Sazdov', 'Saksa', '0000-00-00', 'images/playerPhotos/Saksa.png', 5, 'Hard', 911900),
(371, 10, 1, 'Великобритания', 'images/countryFlags/Великобритания.png', 'Omar Dabasas', 'Madara', '0000-00-00', 'images/playerPhotos/Madara.png', 1, 'Safe', 143580),
(372, 10, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Micke Nguyen', 'Micke', '0000-00-00', 'images/playerPhotos/Micke.png', 1, 'Safe', 21909),
(373, 10, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Samuel Svahn', 'boxi', '0000-00-00', 'images/playerPhotos/boxi.png', 3, 'Hard', 28109),
(374, 10, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Aydin Sarkohi', 'iNsania', '0000-00-00', 'images/playerPhotos/iNsania.png', 5, 'Hard', 30222),
(375, 11, 1, 'Пакистан', 'images/countryFlags/Пакистан.png', 'Yawar Hassan', 'YawaR', '0000-00-00', 'images/playerPhotos/YawaR.png', 1, 'Safe', 216933),
(376, 11, 1, 'США', 'images/countryFlags/США.png', 'Jingjun Wu', 'Sneyking', '0000-00-00', 'images/playerPhotos/Sneyking.png', 3, 'Hard', 221205),
(377, 11, 1, 'Швеция', 'images/countryFlags/Швеция.png', 'Johan Åström', 'pieliedie', '0000-00-00', 'images/playerPhotos/pieliedie.png', 5, 'Safe', 650164),
(378, 11, 1, 'США', 'images/countryFlags/США.png', 'Arif Anwar', 'MSS', '0000-00-00', 'images/playerPhotos/MSS.png', 5, 'Safe', 295227),
(379, 128, 1, 'Перу', 'images/countryFlags/Перу.png', 'Hector Antonio Rodriguez', 'K1', '0000-00-00', 'images/playerPhotos/K1.png', 1, 'Safe', 6480),
(380, 128, 1, 'Перу', 'images/countryFlags/Перу.png', 'Junior Reyes Rimari', 'Yadomi', '0000-00-00', 'images/playerPhotos/Yadomi.png', 5, 'Safe', 5450),
(381, 3, 1, 'Россия', 'images/countryFlags/Россия.png', 'Nikita Kuzmin', 'Daxak', '0000-00-00', 'images/playerPhotos/Daxak.png', 1, 'Safe', 72900),
(382, 3, 1, 'Россия', 'images/countryFlags/Россия.png', 'Andrey Afonin', 'Afoninje', '0000-00-00', 'images/playerPhotos/Afoninje.png', 2, 'Mid', 114132),
(383, 3, 1, 'Россия', 'images/countryFlags/Россия.png', 'Vasilii Shishkin', 'Afterlife', '0000-00-00', 'images/playerPhotos/Afterlife.png', 3, 'Hard', 115708),
(384, 3, 1, 'Беларусь', 'images/countryFlags/Беларусь.png', 'Artem Barshack', 'fng', '0000-00-00', 'images/playerPhotos/fng.png', 5, 'Safe', 463184),
(385, 3, 1, 'Россия', 'images/countryFlags/Россия.png', 'Alexander Hmelevskoy', 'Immersion', '0000-00-00', 'images/playerPhotos/Immersion.png', 5, 'Hard', 63350),
(386, 136, 1, 'Китай', 'images/countryFlags/Китай.png', 'Du Peng', 'Monet', '0000-00-00', 'images/playerPhotos/Monet.png', 1, 'Safe', 617779),
(387, 136, 1, 'Китай', 'images/countryFlags/Китай.png', 'Gao Zhenxiong', 'Setsu', '0000-00-00', 'images/playerPhotos/Setsu.png', 2, 'Mid', 19791),
(388, 136, 1, 'Китай', 'images/countryFlags/Китай.png', 'Su Lei', 'Flyby', '0000-00-00', 'images/playerPhotos/Flyby.png', 3, 'Hard', 23087),
(389, 136, 1, 'Китай', 'images/countryFlags/Китай.png', 'Zhang Zhicheng', 'LaNm', '0000-00-00', 'images/playerPhotos/LaNm.png', 5, 'Hard', 850947),
(390, 136, 1, 'Малайзия', 'images/countryFlags/Малайзия.png', 'Tue Soon Chuan', 'ahfu', '0000-00-00', 'images/playerPhotos/ahfu.png', 5, 'Safe', 615218),
(391, 137, 1, 'Китай', 'images/countryFlags/Китай.png', 'Ning Zhang', 'xiao8', '0000-00-00', 'images/playerPhotos/xiao8.png', 3, 'Hard', 1745854),
(392, 137, 1, 'Китай', 'images/countryFlags/Китай.png', 'Zhao Zixing', 'XinQ', '0000-00-00', 'images/playerPhotos/XinQ.png', 5, 'Hard', 106866),
(393, 138, 1, 'Индонезия', 'images/countryFlags/Индонезия.png', 'Randy Sapoetra', 'Dreamocel', '0000-00-00', 'images/playerPhotos/Dreamocel.png', 1, 'Safe', 25764),
(394, 138, 1, 'Индонезия', 'images/countryFlags/Индонезия.png', 'Alfi Nelphyana', 'Khezcute', '0000-00-00', 'images/playerPhotos/Khezcute.png', 5, 'Safe', 25764),
(395, 138, 1, 'Индонезия', 'images/countryFlags/Индонезия.png', 'Tri Kuncoro', 'Jhocam', '0000-00-00', 'images/playerPhotos/Jhocam.png', 5, 'Roaming', 25864);

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
  `idRole` int(11) NOT NULL COMMENT 'id роли',
  `role` varchar(50) NOT NULL COMMENT 'роль',
  `idDiscipline` int(11) NOT NULL COMMENT 'id дисциплины'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `roles`
--

INSERT INTO `roles` (`idRole`, `role`, `idDiscipline`) VALUES
(1, 'Carry', 1),
(2, 'Mid', 1),
(3, 'Offlane', 1),
(4, 'Safe', 1),
(5, 'Support', 1);

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
  `prize` decimal(11,0) NOT NULL COMMENT 'сумма призовых',
  `description` text NOT NULL COMMENT 'описание'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `teams`
--

INSERT INTO `teams` (`idTeam`, `idDiscipline`, `name`, `logo`, `countryFlag`, `country`, `appearenceDate`, `site`, `prize`, `description`) VALUES
(2, 1, 'VG', '', '', '', 0000, '', '0', ''),
(3, 1, 'Gambit', '', '', '', 0000, '', '0', ''),
(4, 1, 'NIP', '', '', '', 0000, '', '0', ''),
(5, 1, 'PSG.LGD', '', '', '', 0000, '', '0', ''),
(6, 1, 'IG', '', '', '', 0000, '', '0', ''),
(7, 1, 'Liquid', '', '', '', 0000, '', '0', ''),
(8, 1, 'EG', '', '', '', 0000, '', '0', ''),
(9, 1, 'Secret', '', '', '', 0000, '', '0', ''),
(10, 1, 'Alliance', '', '', '', 0000, '', '0', ''),
(11, 1, 'FWD', '', '', '', 0000, '', '0', ''),
(12, 1, 'KG', '', '', '', 0000, '', '0', ''),
(13, 1, 'TnC', '', '', '', 0000, '', '0', ''),
(14, 1, 'Empire', '', '', '', 0000, '', '0', ''),
(15, 1, 'Winstrike', '', '', '', 0000, '', '0', ''),
(16, 1, 'FTM', '', '', '', 0000, '', '0', ''),
(17, 1, 'TFT', '', '', '', 0000, '', '0', ''),
(18, 1, 'Vega', '', '', '', 0000, '', '0', ''),
(19, 1, 'SNG', '', '', '', 0000, '', '0', ''),
(20, 1, 'SexyAsF', '', '', '', 0000, '', '0', ''),
(21, 1, 'Virtus.Pro', '', '', '', 0000, '', '0', ''),
(22, 1, 'Na’Vi', '', '', '', 0000, '', '0', ''),
(23, 1, 'gOLD', '', '', '', 0000, '', '0', ''),
(24, 1, 'PVG.J', '', '', '', 0000, '', '0', ''),
(25, 1, 'TN', '', '', '', 0000, '', '0', ''),
(26, 1, 'M5 Academy', '', '', '', 0000, '', '0', ''),
(27, 1, 'N7', '', '', '', 0000, '', '0', ''),
(28, 1, 'coL', '', '', '', 0000, '', '0', ''),
(29, 1, 'bc', '', '', '', 0000, '', '0', ''),
(30, 1, 'paiN', '', '', '', 0000, '', '0', ''),
(31, 1, 'Chaos', '', '', '', 0000, '', '0', ''),
(32, 1, 'OG', '', '', '', 0000, '', '0', ''),
(33, 1, 'Fnatic', '', '', '', 0000, '', '0', ''),
(34, 1, 'Mineski', '', '', '', 0000, '', '0', ''),
(35, 1, 'Aster.A', '', '', '', 0000, '', '0', ''),
(36, 1, 'EPOCH', '', '', '', 0000, '', '0', ''),
(37, 1, 'FC.A', '', '', '', 0000, '', '0', ''),
(38, 1, 'iG.V', '', '', '', 0000, '', '0', ''),
(39, 1, 'KGL', '', '', '', 0000, '', '0', ''),
(40, 1, 'Taichi', '', '', '', 0000, '', '0', ''),
(41, 1, 'EVER', '', '', '', 0000, '', '0', ''),
(42, 1, 'Galaxy', '', '', '', 0000, '', '0', ''),
(43, 1, 'MAX', '', '', '', 0000, '', '0', ''),
(44, 1, 'Sincere', '', '', '', 0000, '', '0', ''),
(45, 1, 'TSG.', '', '', '', 0000, '', '0', ''),
(46, 1, 'Vampire', '', '', '', 0000, '', '0', ''),
(47, 1, 'GeekFam', '', '', '', 0000, '', '0', ''),
(48, 1, 'AOES', '', '', '', 0000, '', '0', ''),
(49, 1, 'CM', '', '', '', 0000, '', '0', ''),
(50, 1, 'Unicorn', '', '', '', 0000, '', '0', ''),
(51, 1, 'KPG', '', '', '', 0000, '', '0', ''),
(52, 1, 'Tiny Airlines', '', '', '', 0000, '', '0', ''),
(53, 1, 'MSC', '', '', '', 0000, '', '0', ''),
(54, 1, 'R|G', '', '', '', 0000, '', '0', ''),
(55, 1, 'PG.Orca', '', '', '', 0000, '', '0', ''),
(56, 1, 'LFS.ph', '', '', '', 0000, '', '0', ''),
(57, 1, 'SGD', '', '', '', 0000, '', '0', ''),
(58, 1, 'PG.Brx', '', '', '', 0000, '', '0', ''),
(59, 1, 'α-Red', '', '', '', 0000, '', '0', ''),
(60, 1, 'Neon', '', '', '', 0000, '', '0', ''),
(61, 1, 'LW', '', '', '', 0000, '', '0', ''),
(62, 1, 'x@', '', '', '', 0000, '', '0', ''),
(63, 1, 'kastrol+4', '', '', '', 0000, '', '0', ''),
(64, 1, '7SVN', '', '', '', 0000, '', '0', ''),
(65, 1, 'NoMidas', '', '', '', 0000, '', '0', ''),
(66, 1, '23C', '', '', '', 0000, '', '0', ''),
(67, 1, 'SB Young', '', '', '', 0000, '', '0', ''),
(68, 1, 'Pango', '', '', '', 0000, '', '0', ''),
(69, 1, 'SAsh', '', '', '', 0000, '', '0', ''),
(70, 1, '496', '', '', '', 0000, '', '0', ''),
(71, 1, 'SSG', '', '', '', 0000, '', '0', ''),
(72, 1, 'FG', '', '', '', 0000, '', '0', ''),
(73, 1, 'Lagenda', '', '', '', 0000, '', '0', ''),
(74, 1, 'P1', '', '', '', 0000, '', '0', ''),
(75, 1, 'Junior', '', '', '', 0000, '', '0', ''),
(76, 1, 'Team X', '', '', '', 0000, '', '0', ''),
(77, 1, 'DH', '', '', '', 0000, '', '0', ''),
(78, 1, '5iwns', '', '', '', 0000, '', '0', ''),
(79, 1, 'BRUTD', '', '', '', 0000, '', '0', ''),
(80, 1, 'Cipher', '', '', '', 0000, '', '0', ''),
(81, 1, 'Xunwu', '', '', '', 0000, '', '0', ''),
(82, 1, 'Astro', '', '', '', 0000, '', '0', ''),
(83, 1, 'LYNX TH', '', '', '', 0000, '', '0', ''),
(84, 1, 'tt', '', '', '', 0000, '', '0', ''),
(85, 1, 'IBNA', '', '', '', 0000, '', '0', ''),
(86, 1, 'ggngg', '', '', '', 0000, '', '0', ''),
(87, 1, 'zxcv666', '', '', '', 0000, '', '0', ''),
(88, 1, 'Xolotl', '', '', '', 0000, '', '0', ''),
(89, 1, 'Vega.A', '', '', '', 0000, '', '0', ''),
(90, 1, 'Athletico', '', '', '', 0000, '', '0', ''),
(91, 1, '5pd', '', '', '', 0000, '', '0', ''),
(92, 1, 'DS', '', '', '', 0000, '', '0', ''),
(93, 1, 'Infinity', '', '', '', 0000, '', '0', ''),
(94, 1, 'Blue Cactus', '', '', '', 0000, '', '0', ''),
(95, 1, 'Trident', '', '', '', 0000, '', '0', ''),
(96, 1, 'WGU', '', '', '', 0000, '', '0', ''),
(97, 1, 'Zeus', '', '', '', 0000, '', '0', ''),
(98, 1, 'Admiral', '', '', '', 0000, '', '0', ''),
(99, 1, 'Signify', '', '', '', 0000, '', '0', ''),
(100, 1, 'Veteran', '', '', '', 0000, '', '0', ''),
(101, 1, 'HG', '', '', '', 0000, '', '0', ''),
(102, 1, 'DeToNator', '', '', '', 0000, '', '0', ''),
(103, 1, 'DotaPlus', '', '', '', 0000, '', '0', ''),
(104, 1, 'uNc', '', '', '', 0000, '', '0', ''),
(105, 1, 'HpM', '', '', '', 0000, '', '0', ''),
(106, 1, 'S7E', '', '', '', 0000, '', '0', ''),
(107, 1, 'TopfVoll Ott', '', '', '', 0000, '', '0', ''),
(108, 1, 'Ecks Dee', '', '', '', 0000, '', '0', ''),
(109, 1, 'ACE', '', '', '', 0000, '', '0', ''),
(110, 1, 'Freelancers', '', '', '', 0000, '', '0', ''),
(111, 1, 'D2P', '', '', '', 0000, '', '0', ''),
(112, 1, 'CCCC', '', '', '', 0000, '', '0', ''),
(113, 1, 'Jazzy', '', '', '', 0000, '', '0', ''),
(114, 1, 'GLZ', '', '', '', 0000, '', '0', ''),
(115, 1, 'G-Pride', '', '', '', 0000, '', '0', ''),
(116, 1, 'SFtp', '', '', '', 0000, '', '0', ''),
(117, 1, 'South', '', '', '', 0000, '', '0', ''),
(118, 1, 'Wolf', '', '', '', 0000, '', '0', ''),
(119, 1, 'TA', '', '', '', 0000, '', '0', ''),
(120, 1, 'WDGG', '', '', '', 0000, '', '0', ''),
(121, 1, '0-900 Luccini', '', '', '', 0000, '', '0', ''),
(122, 1, 'SGe', '', '', '', 0000, '', '0', ''),
(123, 1, 'EW D2-gg', '', '', '', 0000, '', '0', ''),
(124, 1, 'UNK 2.0', '', '', '', 0000, '', '0', ''),
(125, 1, 'Golden Mulas', '', '', '', 0000, '', '0', ''),
(126, 1, 'NN', '', '', '', 0000, '', '0', ''),
(127, 1, 'ZonaZ', '', '', '', 0000, '', '0', ''),
(128, 1, 'Majestic', '', '', '', 0000, '', '0', ''),
(129, 1, 'EOGG', '', '', '', 0000, '', '0', ''),
(130, 1, 'СДЗП', '', '', '', 0000, '', '0', ''),
(131, 1, 'Lizard', '', '', '', 0000, '', '0', ''),
(132, 1, 'ZILANT', '', '', '', 0000, '', '0', ''),
(133, 1, 'NoCreativity', '', '', '', 0000, '', '0', ''),
(134, 1, 'SGL', '', '', '', 0000, '', '0', ''),
(135, 1, 'timur', '', '', '', 0000, '', '0', ''),
(136, 1, 'RNG', '', '', '', 0000, '', '0', ''),
(137, 1, 'EHOME', '', '', '', 0000, '', '0', ''),
(138, 1, 'BOOM-ID', '', '', '', 0000, '', '0', ''),
(139, 1, 'Eclipse', '', '', '', 0000, '', '0', ''),
(140, 1, 'PHG', '', '', '', 0000, '', '0', ''),
(141, 1, 'SWC', '', '', '', 0000, '', '0', ''),
(142, 1, 'Titans', '', '', '', 0000, '', '0', ''),
(143, 1, 'Edition', '', '', '', 0000, '', '0', ''),
(144, 1, 'Victory', '', '', '', 0000, '', '0', ''),
(145, 1, 'Trump Gamers', '', '', '', 0000, '', '0', ''),
(146, 1, 'WG', '', '', '', 0000, '', '0', ''),
(147, 1, 'beeline.kg', '', '', '', 0000, '', '0', ''),
(148, 1, 'Bren', '', '', '', 0000, '', '0', ''),
(149, 1, 'HFE', '', '', '', 0000, '', '0', ''),
(150, 1, 'PLDT-Smart', '', '', '', 0000, '', '0', ''),
(151, 1, 'Cignal', '', '', '', 0000, '', '0', ''),
(152, 1, 'Suha-XctN', '', '', '', 0000, '', '0', '');

-- --------------------------------------------------------

--
-- Структура таблицы `tournamentmembers`
--

CREATE TABLE `tournamentmembers` (
  `idTournament` int(11) NOT NULL COMMENT 'id турнира',
  `idTeam` int(11) NOT NULL COMMENT 'id команды',
  `invited` varchar(45) NOT NULL DEFAULT '1' COMMENT 'приглашен или прошел квалы'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `tournamentmembers`
--

INSERT INTO `tournamentmembers` (`idTournament`, `idTeam`, `invited`) VALUES
(4, 2, ''),
(4, 3, ''),
(4, 4, ''),
(4, 5, ''),
(4, 6, ''),
(4, 7, ''),
(4, 8, ''),
(4, 9, ''),
(4, 10, ''),
(4, 11, ''),
(4, 12, ''),
(4, 13, ''),
(5, 21, ''),
(5, 22, ''),
(5, 23, ''),
(6, 24, ''),
(6, 25, ''),
(6, 26, ''),
(6, 27, ''),
(7, 8, ''),
(7, 28, ''),
(7, 29, ''),
(7, 30, ''),
(7, 31, ''),
(7, 9, ''),
(7, 7, ''),
(7, 32, ''),
(7, 21, ''),
(7, 14, ''),
(7, 12, ''),
(7, 5, ''),
(7, 2, ''),
(7, 33, ''),
(7, 34, ''),
(7, 4, ''),
(10, 47, ''),
(10, 48, ''),
(10, 49, ''),
(10, 50, ''),
(10, 51, ''),
(10, 52, ''),
(10, 53, ''),
(10, 54, ''),
(10, 55, ''),
(10, 56, ''),
(10, 57, ''),
(10, 58, ''),
(10, 59, ''),
(10, 60, ''),
(10, 61, ''),
(14, 62, ''),
(14, 63, ''),
(14, 147, ''),
(16, 64, ''),
(16, 65, ''),
(16, 66, ''),
(16, 67, ''),
(16, 68, ''),
(16, 69, ''),
(16, 70, ''),
(16, 71, ''),
(18, 50, ''),
(18, 72, ''),
(18, 73, ''),
(18, 47, ''),
(18, 74, ''),
(18, 75, ''),
(18, 76, ''),
(18, 77, ''),
(17, 78, ''),
(17, 79, ''),
(17, 53, ''),
(17, 59, ''),
(17, 80, ''),
(17, 81, ''),
(17, 82, ''),
(17, 83, ''),
(20, 84, ''),
(20, 28, ''),
(20, 85, ''),
(20, 86, ''),
(20, 76, ''),
(20, 87, ''),
(20, 88, ''),
(20, 89, ''),
(21, 90, ''),
(21, 91, ''),
(21, 92, ''),
(21, 93, ''),
(21, 94, ''),
(21, 95, ''),
(22, 96, ''),
(22, 97, ''),
(22, 98, ''),
(22, 58, ''),
(22, 99, ''),
(22, 100, ''),
(22, 60, ''),
(22, 101, ''),
(22, 102, ''),
(22, 103, ''),
(22, 104, ''),
(22, 105, ''),
(22, 106, ''),
(22, 107, ''),
(22, 19, ''),
(22, 24, ''),
(22, 108, ''),
(22, 109, ''),
(22, 110, ''),
(22, 111, ''),
(22, 112, ''),
(22, 113, ''),
(22, 114, ''),
(22, 115, ''),
(22, 116, ''),
(22, 117, ''),
(22, 118, ''),
(22, 88, ''),
(22, 119, ''),
(22, 120, ''),
(19, 121, ''),
(19, 115, ''),
(19, 122, ''),
(19, 123, ''),
(19, 124, ''),
(19, 119, ''),
(19, 125, ''),
(19, 126, ''),
(19, 127, ''),
(19, 128, ''),
(12, 129, ''),
(12, 130, ''),
(12, 131, ''),
(12, 132, ''),
(12, 133, ''),
(12, 134, ''),
(12, 135, ''),
(12, 18, ''),
(13, 4, ''),
(13, 10, ''),
(13, 11, ''),
(13, 128, ''),
(13, 3, ''),
(13, 136, ''),
(13, 137, ''),
(13, 138, ''),
(23, 97, ''),
(23, 139, ''),
(23, 140, ''),
(23, 60, ''),
(23, 141, ''),
(23, 142, ''),
(23, 143, ''),
(23, 43, ''),
(23, 76, ''),
(23, 144, ''),
(23, 145, ''),
(23, 146, ''),
(4, 2, ''),
(4, 3, ''),
(4, 4, ''),
(4, 5, ''),
(4, 6, ''),
(4, 7, ''),
(4, 8, ''),
(4, 9, ''),
(4, 10, ''),
(4, 11, ''),
(4, 12, ''),
(4, 13, ''),
(5, 21, ''),
(5, 22, ''),
(5, 23, ''),
(6, 24, ''),
(6, 25, ''),
(6, 26, ''),
(6, 27, ''),
(7, 8, ''),
(7, 28, ''),
(7, 29, ''),
(7, 30, ''),
(7, 31, ''),
(7, 9, ''),
(7, 7, ''),
(7, 32, ''),
(7, 21, ''),
(7, 14, ''),
(7, 12, ''),
(7, 5, ''),
(7, 2, ''),
(7, 33, ''),
(7, 34, ''),
(7, 4, ''),
(10, 47, ''),
(10, 48, ''),
(10, 49, ''),
(10, 50, ''),
(10, 51, ''),
(10, 52, ''),
(10, 53, ''),
(10, 54, ''),
(10, 55, ''),
(10, 56, ''),
(10, 57, ''),
(10, 58, ''),
(10, 59, ''),
(10, 60, ''),
(10, 61, ''),
(14, 62, ''),
(14, 63, ''),
(14, 147, ''),
(16, 64, ''),
(16, 65, ''),
(16, 66, ''),
(16, 67, ''),
(16, 68, ''),
(16, 69, ''),
(16, 70, ''),
(16, 71, ''),
(18, 50, ''),
(18, 72, ''),
(18, 73, ''),
(18, 47, ''),
(18, 74, ''),
(18, 75, ''),
(18, 76, ''),
(18, 77, ''),
(17, 78, ''),
(17, 79, ''),
(17, 53, ''),
(17, 59, ''),
(17, 80, ''),
(17, 81, ''),
(17, 82, ''),
(17, 83, ''),
(20, 84, ''),
(20, 28, ''),
(20, 85, ''),
(20, 86, ''),
(20, 76, ''),
(20, 87, ''),
(20, 88, ''),
(20, 89, ''),
(21, 90, ''),
(21, 91, ''),
(21, 92, ''),
(21, 93, ''),
(21, 94, ''),
(21, 95, ''),
(22, 96, ''),
(22, 97, ''),
(22, 98, ''),
(22, 58, ''),
(22, 99, ''),
(22, 100, ''),
(22, 60, ''),
(22, 101, ''),
(22, 102, ''),
(22, 103, ''),
(22, 104, ''),
(22, 105, ''),
(22, 106, ''),
(22, 107, ''),
(22, 19, ''),
(22, 24, ''),
(22, 108, ''),
(22, 109, ''),
(22, 110, ''),
(22, 111, ''),
(22, 112, ''),
(22, 113, ''),
(22, 114, ''),
(22, 115, ''),
(22, 116, ''),
(22, 117, ''),
(22, 118, ''),
(22, 88, ''),
(22, 119, ''),
(22, 120, ''),
(19, 121, ''),
(19, 115, ''),
(19, 122, ''),
(19, 123, ''),
(19, 124, ''),
(19, 119, ''),
(19, 125, ''),
(19, 126, ''),
(19, 127, ''),
(19, 128, ''),
(12, 129, ''),
(12, 130, ''),
(12, 131, ''),
(12, 132, ''),
(12, 133, ''),
(12, 134, ''),
(12, 135, ''),
(12, 18, ''),
(13, 4, ''),
(13, 10, ''),
(13, 11, ''),
(13, 128, ''),
(13, 3, ''),
(13, 136, ''),
(13, 137, ''),
(13, 138, ''),
(23, 97, ''),
(23, 139, ''),
(23, 140, ''),
(23, 60, ''),
(23, 141, ''),
(23, 142, ''),
(23, 143, ''),
(23, 43, ''),
(23, 76, ''),
(23, 144, ''),
(23, 145, ''),
(23, 146, '');

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
  `seria` varchar(100) NOT NULL COMMENT 'серия',
  `description` varchar(1500) NOT NULL COMMENT 'описание ',
  `prize` int(11) NOT NULL COMMENT 'сумма призовых',
  `dateBegin` date NOT NULL COMMENT 'дата начала турнира',
  `dateEnd` date NOT NULL COMMENT 'дата окончания турнира',
  `location` varchar(100) NOT NULL COMMENT 'локация',
  `idRegion` int(11) DEFAULT NULL COMMENT 'id региона'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `tournaments`
--

INSERT INTO `tournaments` (`idTournament`, `event`, `tournamentLogo`, `seria`, `description`, `prize`, `dateBegin`, `dateEnd`, `location`, `idRegion`) VALUES
(1, 'The International 2019', 'images/tournamentLogos/The International 2019.png', '', 'The International 2019 пройдет в августе 2019 года в Шанхае, Китай. Призовой фонд предыдущего турнира составил $25,000,000. Квалификации на турнир пройдут во всех регионах в июне 2019 года', 1000000, '2019-08-15', '0000-00-00', '', NULL),
(2, 'World Cyber Games 2019', 'images/tournamentLogos/World Cyber Games 2019.png', '', '', 0, '2019-07-18', '0000-00-00', '', NULL),
(3, 'EPICENTER Major', 'images/tournamentLogos/EPICENTER Major.png', '', '', 1000000, '2019-06-22', '0000-00-00', '', NULL),
(4, 'ESL One Birmingham 2019', 'images/tournamentLogos/ESL One Birmingham 2019.png', '', '', 300000, '2019-05-28', '0000-00-00', '', NULL),
(5, 'Adrenaline Cyber League 2019', 'images/tournamentLogos/Adrenaline Cyber League 201', '', '', 100000, '2019-05-25', '0000-00-00', '', NULL),
(6, 'META&#039;19 Spring', 'images/tournamentLogos/META&#039;19 Spring.png', '', '', 1396, '2019-05-05', '0000-00-00', '', NULL),
(7, 'MDL Disneyland Paris Major', 'images/tournamentLogos/MDL Disneyland Paris Major.', '', 'MDL Disneyland&reg; Paris Major &mdash; четвёртый мейджор профессионального сезона 2018/2019. Турнир пройдёт с 4 по 12 мая на территории Диснейленда в Париже. Организатор &mdash; Mars Media.', 1000000, '2019-05-04', '0000-00-00', '', NULL),
(8, 'EPICENTER Major - OQ', 'images/tournamentLogos/EPICENTER Major - OQ.png', '', '', 0, '2019-04-29', '0000-00-00', '', NULL),
(9, 'World Cyber Games 2019 - OQ', 'images/tournamentLogos/World Cyber Games 2019 - OQ', '', '', 0, '2019-04-28', '0000-00-00', '', NULL),
(10, 'Sin Esports', 'images/tournamentLogos/Sin Esports.png', '', '', 5889, '2019-04-27', '0000-00-00', '', NULL),
(11, 'ESL India Premiership 2019 Summer', 'images/tournamentLogos/ESL India Premiership 2019 ', '', '', 1144, '2019-04-26', '0000-00-00', '', NULL),
(12, 'Dom.ru Championship 2019', 'images/tournamentLogos/Dom.ru Championship 2019.pn', '', '', 15573, '2019-04-26', '0000-00-00', '', NULL),
(13, 'Dota PIT Minor 2019', 'images/tournamentLogos/Dota PIT Minor 2019.png', '', '', 300000, '2019-04-22', '0000-00-00', '', NULL),
(14, 'Bishkek Stars League #8', 'images/tournamentLogos/Bishkek Stars League #8.png', '', '', 31813, '2019-04-20', '0000-00-00', '', NULL),
(15, 'Russian eSports Championship 2019', 'images/tournamentLogos/Russian eSports Championshi', '', '', 22500, '2019-04-20', '0000-00-00', '', NULL),
(16, 'ESL Vietnam Championship Season 1', 'images/tournamentLogos/ESL Vietnam Championship Se', '', '', 9000, '2019-04-12', '0000-00-00', '', NULL),
(17, 'ESL Thailand Championship Season 1', 'images/tournamentLogos/ESL Thailand Championship S', '', '', 9000, '2019-04-09', '0000-00-00', '', NULL),
(18, 'ESL MY&amp;SG Championship Season 1', 'images/tournamentLogos/ESL MY&amp;SG Championship ', '', '', 9000, '2019-04-09', '0000-00-00', '', NULL),
(19, 'Liga Pro Gaming S6', 'images/tournamentLogos/Liga Pro Gaming S6.png', '', '', 4500, '2019-04-08', '0000-00-00', '', NULL),
(20, 'American Avengers Cup', 'images/tournamentLogos/American Avengers Cup.png', '', '', 10000, '2019-04-05', '0000-00-00', '', NULL),
(21, 'ESL ANZ Championship Season 3', 'images/tournamentLogos/ESL ANZ Championship Season', '', '', 7228, '2019-03-03', '0000-00-00', '', NULL),
(22, 'joinDOTA Season 15', 'images/tournamentLogos/joinDOTA Season 15.png', '', '', 12000, '2019-01-28', '0000-00-00', '', NULL),
(23, 'Rainbow Cup Season 2', 'images/tournamentLogos/Rainbow Cup Season 2.png', '', '', 10000, '2019-04-14', '0000-00-00', '', NULL),
(24, 'ESL One Mumbai 2019', 'images/tournamentLogos/ESL One Mumbai 2019.png', '', 'ESL вместе с&nbsp;NODWIN Gaming&nbsp;проведут первый крупный турнир в Индии -&nbsp;ESL One Mumbai 2019. 7 приглашенных команд, а так же 5 лучших команд из квалификаций сразятся за призовой фонд в $300,000', 300000, '2019-04-16', '0000-00-00', '', NULL),
(25, 'AEF DPL Season 2', 'images/tournamentLogos/AEF DPL Season 2.png', '', '', 3642, '2019-04-20', '0000-00-00', '', NULL);

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
  ADD KEY `players_ibfk_3_idx` (`idRole`);

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
  ADD KEY `idRelatedTournament` (`idRelatedTournament`),
  ADD KEY `idTournament` (`idTournament`);

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
  MODIFY `idMatchFormat` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id формата';

--
-- AUTO_INCREMENT для таблицы `players`
--
ALTER TABLE `players`
  MODIFY `idPlayer` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id игрока', AUTO_INCREMENT=396;

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
-- AUTO_INCREMENT для таблицы `roles`
--
ALTER TABLE `roles`
  MODIFY `idRole` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id роли', AUTO_INCREMENT=6;

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
  MODIFY `idTeam` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id команды', AUTO_INCREMENT=153;

--
-- AUTO_INCREMENT для таблицы `tournaments`
--
ALTER TABLE `tournaments`
  MODIFY `idTournament` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id турнира', AUTO_INCREMENT=26;

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
  ADD CONSTRAINT `matchDesctiption_ibfk_1` FOREIGN KEY (`idMatch`) REFERENCES `matches` (`idmatch`),
  ADD CONSTRAINT `matchDesctiption_ibfk_2` FOREIGN KEY (`idFormat`) REFERENCES `matchformats` (`idmatchformat`),
  ADD CONSTRAINT `matchDesctiption_ibfk_3` FOREIGN KEY (`firstWinner`) REFERENCES `teams` (`idteam`),
  ADD CONSTRAINT `matchDesctiption_ibfk_4` FOREIGN KEY (`secondWinner`) REFERENCES `teams` (`idteam`),
  ADD CONSTRAINT `matchDesctiption_ibfk_5` FOREIGN KEY (`thirdWinner`) REFERENCES `teams` (`idteam`),
  ADD CONSTRAINT `matchDesctiption_ibfk_6` FOREIGN KEY (`fourthWinner`) REFERENCES `teams` (`idteam`),
  ADD CONSTRAINT `matchDesctiption_ibfk_7` FOREIGN KEY (`fifthWinner`) REFERENCES `teams` (`idteam`);

--
-- Ограничения внешнего ключа таблицы `matches`
--
ALTER TABLE `matches`
  ADD CONSTRAINT `matches_ibfk_1` FOREIGN KEY (`idTournament`) REFERENCES `tournaments` (`idtournament`),
  ADD CONSTRAINT `matches_ibfk_2` FOREIGN KEY (`idFirstTeam`) REFERENCES `teams` (`idteam`),
  ADD CONSTRAINT `matches_ibfk_3` FOREIGN KEY (`idSecondTeam`) REFERENCES `teams` (`idteam`);

--
-- Ограничения внешнего ключа таблицы `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`idTeam`) REFERENCES `teams` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `players_ibfk_2` FOREIGN KEY (`idDiscipline`) REFERENCES `disciplines` (`idDiscipline`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `players_ibfk_3` FOREIGN KEY (`idRole`) REFERENCES `roles` (`idRole`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `playertransfers`
--
ALTER TABLE `playertransfers`
  ADD CONSTRAINT `playerTransfers_ibfk_2` FOREIGN KEY (`idTeam`) REFERENCES `teams` (`idTeam`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `relatedtournaments`
--
ALTER TABLE `relatedtournaments`
  ADD CONSTRAINT `relatedtournaments_ibfk_1` FOREIGN KEY (`idRelatedTournament`) REFERENCES `tournaments` (`idTournament`),
  ADD CONSTRAINT `relatedtournaments_ibfk_2` FOREIGN KEY (`idTournament`) REFERENCES `tournaments` (`idTournament`);

--
-- Ограничения внешнего ключа таблицы `roles`
--
ALTER TABLE `roles`
  ADD CONSTRAINT `roles_ibfk_1` FOREIGN KEY (`idDiscipline`) REFERENCES `disciplines` (`idDiscipline`);

--
-- Ограничения внешнего ключа таблицы `rounds`
--
ALTER TABLE `rounds`
  ADD CONSTRAINT `rounds_ibfk_1` FOREIGN KEY (`idBracket`) REFERENCES `brackets` (`idBracket`);

--
-- Ограничения внешнего ключа таблицы `substitutions`
--
ALTER TABLE `substitutions`
  ADD CONSTRAINT `substitutions_ibfk_3` FOREIGN KEY (`idMatch`) REFERENCES `matches` (`idMatch`),
  ADD CONSTRAINT `substitutions_ibfk_4` FOREIGN KEY (`idTeam`) REFERENCES `teams` (`idteam`),
  ADD CONSTRAINT `substitutions_ibfk_6` FOREIGN KEY (`idTournament`) REFERENCES `tournaments` (`idtournament`),
  ADD CONSTRAINT `substitutions_ibfk_7` FOREIGN KEY (`idTeam1`) REFERENCES `teams` (`idTeam`);

--
-- Ограничения внешнего ключа таблицы `teams`
--
ALTER TABLE `teams`
  ADD CONSTRAINT `teams_ibfk_1` FOREIGN KEY (`idDiscipline`) REFERENCES `disciplines` (`idDiscipline`);

--
-- Ограничения внешнего ключа таблицы `tournamentmembers`
--
ALTER TABLE `tournamentmembers`
  ADD CONSTRAINT `tournamentMembers_ibfk_1` FOREIGN KEY (`idTournament`) REFERENCES `tournaments` (`idtournament`),
  ADD CONSTRAINT `tournamentMembers_ibfk_2` FOREIGN KEY (`idTeam`) REFERENCES `teams` (`idTeam`);

--
-- Ограничения внешнего ключа таблицы `tournamentresults`
--
ALTER TABLE `tournamentresults`
  ADD CONSTRAINT `tournamentResults_ibfk_2` FOREIGN KEY (`idTeam`) REFERENCES `teams` (`idTeam`),
  ADD CONSTRAINT `tournamentresults_ibfk_1` FOREIGN KEY (`idTournament`) REFERENCES `tournaments` (`idTournament`);

--
-- Ограничения внешнего ключа таблицы `tournaments`
--
ALTER TABLE `tournaments`
  ADD CONSTRAINT `tournaments_ibfk_1` FOREIGN KEY (`idRegion`) REFERENCES `regions` (`idRegion`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
