-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3006
-- Время создания: Мар 03 2019 г., 22:20
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
CREATE DEFINER=`root`@`%` PROCEDURE `checkTeam` (IN `team` VARCHAR(255))  NO SQL
    COMMENT 'проверка существования записи о данной команде'
IF team in(SELECT name FROM teams) THEN
	SIGNAL SQLSTATE '50000'
	SET MESSAGE_TEXT="Такая команда уже существует";
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
(9, 'asd', '7815696ecbf1c96e6894b779456d330e');

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
-- Структура таблицы `currentMatches`
--

CREATE TABLE `currentMatches` (
  `idMatch` int(11) NOT NULL COMMENT 'id матча',
  `idFirstTeam` int(11) NOT NULL COMMENT 'id первой команды',
  `idSecondTeam` int(11) NOT NULL COMMENT 'id второй команды',
  `idTournament` int(11) NOT NULL COMMENT 'id турнира',
  `date` datetime NOT NULL COMMENT 'дата проведения матча'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
(1, 'Dota 2'),
(2, 'Dota 2'),
(3, 'CS:GO'),
(4, 'CS:GO');

-- --------------------------------------------------------

--
-- Структура таблицы `players`
--

CREATE TABLE `players` (
  `idPlayer` int(11) NOT NULL COMMENT 'id игрока',
  `idTeam` int(11) NOT NULL COMMENT 'id команды',
  `idDiscipline` int(11) NOT NULL COMMENT 'id дисциплины',
  `nickname` varchar(50) NOT NULL COMMENT 'никнейм',
  `photoRef` varchar(250) NOT NULL COMMENT 'фото',
  `status` int(11) NOT NULL COMMENT 'статус',
  `idRole` int(11) NOT NULL COMMENT 'id роли'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `playerTransfers`
--

CREATE TABLE `playerTransfers` (
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

--
-- Дамп данных таблицы `prognoz`
--

INSERT INTO `prognoz` (`idUser`, `idTeam`, `idMatch`) VALUES
(1, 1, 1),
(2, 2, 2);

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
(1, 'Кери', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `statuses`
--

CREATE TABLE `statuses` (
  `idStatus` int(11) NOT NULL COMMENT 'id статуса',
  `status` varchar(50) NOT NULL COMMENT 'статус'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `statuses`
--

INSERT INTO `statuses` (`idStatus`, `status`) VALUES
(1, 'Игрок'),
(2, 'Капитан'),
(3, 'Запасной'),
(4, 'Свободный агент');

-- --------------------------------------------------------

--
-- Структура таблицы `substitutions`
--

CREATE TABLE `substitutions` (
  `idSubstitution` int(11) NOT NULL COMMENT 'id замены',
  `idPlayer` int(11) NOT NULL COMMENT 'id игрока, которого заменили',
  `idPlayer1` int(11) NOT NULL COMMENT 'id заменившего игрока',
  `idMatch` int(11) NOT NULL COMMENT 'id матча',
  `idTeam` int(11) NOT NULL COMMENT 'id команды / id команды, которую заменили',
  `idTeam1` int(11) NOT NULL COMMENT 'id заменившей команды',
  `idTournament` int(11) NOT NULL COMMENT 'id турнира'
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
  `appearenceDate` year(4) NOT NULL COMMENT 'дата основания',
  `site` varchar(1500) NOT NULL COMMENT 'сайт',
  `prize` decimal(11,0) NOT NULL COMMENT 'сумма призовых',
  `description` text NOT NULL COMMENT 'описание',
  `achievement` text NOT NULL COMMENT 'достижения'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `autorization`
--
ALTER TABLE `autorization`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `currentMatches`
--
ALTER TABLE `currentMatches`
  ADD PRIMARY KEY (`idMatch`);

--
-- Индексы таблицы `disciplines`
--
ALTER TABLE `disciplines`
  ADD PRIMARY KEY (`idDiscipline`);

--
-- Индексы таблицы `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`idPlayer`),
  ADD KEY `idTeam` (`idTeam`),
  ADD KEY `idRole` (`idRole`),
  ADD KEY `idDiscipline` (`idDiscipline`);

--
-- Индексы таблицы `playerTransfers`
--
ALTER TABLE `playerTransfers`
  ADD PRIMARY KEY (`idTransfer`),
  ADD KEY `idPlayer` (`idPlayer`),
  ADD KEY `idTeam` (`idTeam`);

--
-- Индексы таблицы `prognoz`
--
ALTER TABLE `prognoz`
  ADD PRIMARY KEY (`idUser`);

--
-- Индексы таблицы `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`idRole`);

--
-- Индексы таблицы `statuses`
--
ALTER TABLE `statuses`
  ADD PRIMARY KEY (`idStatus`);

--
-- Индексы таблицы `substitutions`
--
ALTER TABLE `substitutions`
  ADD PRIMARY KEY (`idSubstitution`);

--
-- Индексы таблицы `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`idTeam`),
  ADD KEY `idTeam` (`idTeam`),
  ADD KEY `idDiscipline` (`idDiscipline`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `autorization`
--
ALTER TABLE `autorization`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `currentMatches`
--
ALTER TABLE `currentMatches`
  MODIFY `idMatch` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id матча';

--
-- AUTO_INCREMENT для таблицы `disciplines`
--
ALTER TABLE `disciplines`
  MODIFY `idDiscipline` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id дисциплины', AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `players`
--
ALTER TABLE `players`
  MODIFY `idPlayer` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id игрока';

--
-- AUTO_INCREMENT для таблицы `playerTransfers`
--
ALTER TABLE `playerTransfers`
  MODIFY `idTransfer` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id трансфера';

--
-- AUTO_INCREMENT для таблицы `prognoz`
--
ALTER TABLE `prognoz`
  MODIFY `idUser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `roles`
--
ALTER TABLE `roles`
  MODIFY `idRole` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id роли', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `statuses`
--
ALTER TABLE `statuses`
  MODIFY `idStatus` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id статуса', AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `substitutions`
--
ALTER TABLE `substitutions`
  MODIFY `idSubstitution` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id замены';

--
-- AUTO_INCREMENT для таблицы `teams`
--
ALTER TABLE `teams`
  MODIFY `idTeam` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id команды';

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`idTeam`) REFERENCES `teams` (`idTeam`),
  ADD CONSTRAINT `players_ibfk_2` FOREIGN KEY (`idRole`) REFERENCES `roles` (`idRole`),
  ADD CONSTRAINT `players_ibfk_3` FOREIGN KEY (`idDiscipline`) REFERENCES `disciplines` (`idDiscipline`);

--
-- Ограничения внешнего ключа таблицы `playerTransfers`
--
ALTER TABLE `playerTransfers`
  ADD CONSTRAINT `playertransfers_ibfk_1` FOREIGN KEY (`idTeam`) REFERENCES `teams` (`idTeam`),
  ADD CONSTRAINT `playertransfers_ibfk_2` FOREIGN KEY (`idPlayer`) REFERENCES `players` (`idPlayer`);

--
-- Ограничения внешнего ключа таблицы `teams`
--
ALTER TABLE `teams`
  ADD CONSTRAINT `teams_ibfk_1` FOREIGN KEY (`idDiscipline`) REFERENCES `disciplines` (`idDiscipline`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
