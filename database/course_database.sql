-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Мар 09 2019 г., 14:01
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkTeam` (IN `team` VARCHAR(255))  NO SQL
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
-- Структура таблицы `matchDescription`
--

CREATE TABLE `matchDescription` (
  `idMatch` int(11) NOT NULL COMMENT 'id матча',
  `idFormat` int(11) NOT NULL COMMENT 'id формата',
  `firstWinner` int(11) NOT NULL COMMENT 'победитель 1-ой карты',
  `secondWinner` int(11) NOT NULL COMMENT 'победитель 2-ой карты',
  `thirdWinner` int(11) NOT NULL COMMENT 'победитель 3-ей карты',
  `fourthWinner` int(11) NOT NULL COMMENT 'победитель 4-ой карты',
  `fifthWinner` int(11) NOT NULL COMMENT 'победитель 5-ой карты',
  `finalScore` varchar(10) NOT NULL COMMENT 'итоговый счет'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `matches`
--

CREATE TABLE `matches` (
  `idMatch` int(11) NOT NULL COMMENT 'id матча',
  `idFirstTeam` int(11) NOT NULL COMMENT 'id первой команды',
  `idSecondTeam` int(11) NOT NULL COMMENT 'id второй команды',
  `idTournament` int(11) NOT NULL COMMENT 'id турнира',
  `date` datetime NOT NULL COMMENT 'дата проведения матча'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `matchFormats`
--

CREATE TABLE `matchFormats` (
  `idMatchFormat` int(11) NOT NULL COMMENT 'id формата',
  `matchFormat` varchar(50) NOT NULL COMMENT 'формат'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `matchFormats`
--

INSERT INTO `matchFormats` (`idMatchFormat`, `matchFormat`) VALUES
(1, 'Best of 1'),
(2, 'Best of 2'),
(3, 'Best of 3'),
(4, 'Best of 5');

-- --------------------------------------------------------

--
-- Структура таблицы `participantTournament`
--

CREATE TABLE `participantTournament` (
  `idTournament` int(11) NOT NULL COMMENT 'id турнира',
  `idParticipant` int(11) NOT NULL COMMENT 'id участника'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `players`
--

CREATE TABLE `players` (
  `idPlayer` int(11) NOT NULL COMMENT 'id игрока',
  `idTeam` int(11) NOT NULL COMMENT 'id команды',
  `idDiscipline` int(11) NOT NULL COMMENT 'id дисциплины',
  `facts` varchar(500) NOT NULL COMMENT 'факты ',
  `country` int(11) NOT NULL COMMENT 'страна',
  `description` text NOT NULL COMMENT 'описание',
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
-- Структура таблицы `prizeTournament`
--

CREATE TABLE `prizeTournament` (
  `idTournament` int(11) NOT NULL COMMENT 'id турнира',
  `place` varchar(50) NOT NULL COMMENT 'призовое место',
  `prize` int(11) NOT NULL COMMENT 'сумма призовых'
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

-- --------------------------------------------------------

--
-- Структура таблицы `tournaments`
--

CREATE TABLE `tournaments` (
  `idTournament` int(11) NOT NULL COMMENT 'id турнира',
  `description` varchar(1500) NOT NULL COMMENT 'описание ',
  `prize` int(11) NOT NULL COMMENT 'сумма призовых',
  `countTeam` int(11) NOT NULL COMMENT 'количество команд',
  `dateBegin` date NOT NULL COMMENT 'дата начала турнира',
  `deteEnd` date NOT NULL COMMENT 'дата окончания турнира',
  `seria` varchar(100) NOT NULL COMMENT 'серия',
  `location` varchar(100) NOT NULL COMMENT 'локация',
  `format` varchar(100) NOT NULL COMMENT 'формат',
  `stage` int(11) NOT NULL COMMENT 'этап',
  `status` int(11) NOT NULL COMMENT 'статус турнира'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `tournamentStages`
--

CREATE TABLE `tournamentStages` (
  `idStage` int(11) NOT NULL COMMENT 'id этапа',
  `stage` varchar(100) NOT NULL COMMENT 'этап'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `tournamentStages`
--

INSERT INTO `tournamentStages` (`idStage`, `stage`) VALUES
(1, 'Финальная часть'),
(3, 'Открытые квалификации'),
(4, 'Закрытая квалификация'),
(5, 'Плей-офф'),
(6, 'Групповой этап');

-- --------------------------------------------------------

--
-- Структура таблицы `tournamentStatus`
--

CREATE TABLE `tournamentStatus` (
  `idStatus` int(11) NOT NULL COMMENT 'id статуса',
  `status` varchar(20) NOT NULL COMMENT 'статус'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `tournamentStatus`
--

INSERT INTO `tournamentStatus` (`idStatus`, `status`) VALUES
(1, 'В ожидании'),
(2, 'Идет'),
(3, 'Завершен');

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
-- Индексы таблицы `disciplines`
--
ALTER TABLE `disciplines`
  ADD PRIMARY KEY (`idDiscipline`);

--
-- Индексы таблицы `matchDescription`
--
ALTER TABLE `matchDescription`
  ADD KEY `idFormat` (`idFormat`),
  ADD KEY `firstWinner` (`firstWinner`),
  ADD KEY `secondWinner` (`secondWinner`),
  ADD KEY `thirdWinner` (`thirdWinner`),
  ADD KEY `fourthWinner` (`fourthWinner`),
  ADD KEY `fifthWinner` (`fifthWinner`),
  ADD KEY `idMatch` (`idMatch`);

--
-- Индексы таблицы `matches`
--
ALTER TABLE `matches`
  ADD PRIMARY KEY (`idMatch`),
  ADD KEY `idFirstTeam` (`idFirstTeam`),
  ADD KEY `idSecondTeam` (`idSecondTeam`),
  ADD KEY `idTournament` (`idTournament`);

--
-- Индексы таблицы `matchFormats`
--
ALTER TABLE `matchFormats`
  ADD PRIMARY KEY (`idMatchFormat`);

--
-- Индексы таблицы `participantTournament`
--
ALTER TABLE `participantTournament`
  ADD PRIMARY KEY (`idTournament`),
  ADD KEY `idParticipant` (`idParticipant`),
  ADD KEY `idTournament` (`idTournament`);

--
-- Индексы таблицы `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`idPlayer`),
  ADD KEY `idTeam` (`idTeam`),
  ADD KEY `idRole` (`idRole`),
  ADD KEY `idDiscipline` (`idDiscipline`),
  ADD KEY `status` (`status`);

--
-- Индексы таблицы `playerTransfers`
--
ALTER TABLE `playerTransfers`
  ADD PRIMARY KEY (`idTransfer`),
  ADD KEY `idPlayer` (`idPlayer`),
  ADD KEY `idTeam` (`idTeam`);

--
-- Индексы таблицы `prizeTournament`
--
ALTER TABLE `prizeTournament`
  ADD PRIMARY KEY (`idTournament`);

--
-- Индексы таблицы `prognoz`
--
ALTER TABLE `prognoz`
  ADD PRIMARY KEY (`idUser`);

--
-- Индексы таблицы `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`idRole`),
  ADD KEY `idDiscipline` (`idDiscipline`);

--
-- Индексы таблицы `statuses`
--
ALTER TABLE `statuses`
  ADD PRIMARY KEY (`idStatus`);

--
-- Индексы таблицы `substitutions`
--
ALTER TABLE `substitutions`
  ADD PRIMARY KEY (`idSubstitution`),
  ADD KEY `idSubstitution` (`idSubstitution`),
  ADD KEY `idPlayer1` (`idPlayer1`),
  ADD KEY `idMatch` (`idMatch`),
  ADD KEY `idTeam1` (`idTeam1`),
  ADD KEY `idTeam` (`idTeam`),
  ADD KEY `idTournament` (`idTournament`),
  ADD KEY `idPlayer` (`idPlayer`);

--
-- Индексы таблицы `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`idTeam`),
  ADD KEY `idTeam` (`idTeam`),
  ADD KEY `idDiscipline` (`idDiscipline`);

--
-- Индексы таблицы `tournaments`
--
ALTER TABLE `tournaments`
  ADD PRIMARY KEY (`idTournament`),
  ADD KEY `stage` (`stage`),
  ADD KEY `status` (`status`);

--
-- Индексы таблицы `tournamentStages`
--
ALTER TABLE `tournamentStages`
  ADD PRIMARY KEY (`idStage`);

--
-- Индексы таблицы `tournamentStatus`
--
ALTER TABLE `tournamentStatus`
  ADD PRIMARY KEY (`idStatus`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `autorization`
--
ALTER TABLE `autorization`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `disciplines`
--
ALTER TABLE `disciplines`
  MODIFY `idDiscipline` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id дисциплины', AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `matches`
--
ALTER TABLE `matches`
  MODIFY `idMatch` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id матча';

--
-- AUTO_INCREMENT для таблицы `matchFormats`
--
ALTER TABLE `matchFormats`
  MODIFY `idMatchFormat` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id формата', AUTO_INCREMENT=5;

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
-- AUTO_INCREMENT для таблицы `prizeTournament`
--
ALTER TABLE `prizeTournament`
  MODIFY `idTournament` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id турнира';

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
-- AUTO_INCREMENT для таблицы `tournaments`
--
ALTER TABLE `tournaments`
  MODIFY `idTournament` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id турнира';

--
-- AUTO_INCREMENT для таблицы `tournamentStages`
--
ALTER TABLE `tournamentStages`
  MODIFY `idStage` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id этапа', AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `tournamentStatus`
--
ALTER TABLE `tournamentStatus`
  MODIFY `idStatus` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id статуса', AUTO_INCREMENT=4;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `matchDescription`
--
ALTER TABLE `matchDescription`
  ADD CONSTRAINT `matchdescription_ibfk_1` FOREIGN KEY (`idFormat`) REFERENCES `matchFormats` (`idMatchFormat`),
  ADD CONSTRAINT `matchdescription_ibfk_2` FOREIGN KEY (`idMatch`) REFERENCES `matches` (`idMatch`),
  ADD CONSTRAINT `matchdescription_ibfk_3` FOREIGN KEY (`firstWinner`) REFERENCES `teams` (`idTeam`),
  ADD CONSTRAINT `matchdescription_ibfk_4` FOREIGN KEY (`secondWinner`) REFERENCES `teams` (`idTeam`),
  ADD CONSTRAINT `matchdescription_ibfk_5` FOREIGN KEY (`thirdWinner`) REFERENCES `teams` (`idTeam`),
  ADD CONSTRAINT `matchdescription_ibfk_6` FOREIGN KEY (`fourthWinner`) REFERENCES `teams` (`idTeam`),
  ADD CONSTRAINT `matchdescription_ibfk_7` FOREIGN KEY (`fifthWinner`) REFERENCES `teams` (`idTeam`);

--
-- Ограничения внешнего ключа таблицы `matches`
--
ALTER TABLE `matches`
  ADD CONSTRAINT `matches_ibfk_1` FOREIGN KEY (`idFirstTeam`) REFERENCES `teams` (`idTeam`),
  ADD CONSTRAINT `matches_ibfk_2` FOREIGN KEY (`idSecondTeam`) REFERENCES `teams` (`idTeam`),
  ADD CONSTRAINT `matches_ibfk_3` FOREIGN KEY (`idTournament`) REFERENCES `tournaments` (`idTournament`),
  ADD CONSTRAINT `matches_ibfk_4` FOREIGN KEY (`idMatch`) REFERENCES `substitutions` (`idMatch`);

--
-- Ограничения внешнего ключа таблицы `participantTournament`
--
ALTER TABLE `participantTournament`
  ADD CONSTRAINT `participanttournament_ibfk_1` FOREIGN KEY (`idTournament`) REFERENCES `tournaments` (`idTournament`),
  ADD CONSTRAINT `participanttournament_ibfk_2` FOREIGN KEY (`idParticipant`) REFERENCES `teams` (`idTeam`);

--
-- Ограничения внешнего ключа таблицы `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`idTeam`) REFERENCES `teams` (`idTeam`),
  ADD CONSTRAINT `players_ibfk_2` FOREIGN KEY (`idRole`) REFERENCES `roles` (`idRole`),
  ADD CONSTRAINT `players_ibfk_3` FOREIGN KEY (`idDiscipline`) REFERENCES `disciplines` (`idDiscipline`),
  ADD CONSTRAINT `players_ibfk_4` FOREIGN KEY (`idPlayer`) REFERENCES `playerTransfers` (`idPlayer`),
  ADD CONSTRAINT `players_ibfk_5` FOREIGN KEY (`status`) REFERENCES `statuses` (`idStatus`);

--
-- Ограничения внешнего ключа таблицы `playerTransfers`
--
ALTER TABLE `playerTransfers`
  ADD CONSTRAINT `playertransfers_ibfk_1` FOREIGN KEY (`idTeam`) REFERENCES `teams` (`idTeam`),
  ADD CONSTRAINT `playertransfers_ibfk_2` FOREIGN KEY (`idPlayer`) REFERENCES `players` (`idPlayer`);

--
-- Ограничения внешнего ключа таблицы `substitutions`
--
ALTER TABLE `substitutions`
  ADD CONSTRAINT `substitutions_ibfk_1` FOREIGN KEY (`idPlayer`) REFERENCES `players` (`idPlayer`),
  ADD CONSTRAINT `substitutions_ibfk_2` FOREIGN KEY (`idPlayer1`) REFERENCES `players` (`idPlayer`),
  ADD CONSTRAINT `substitutions_ibfk_3` FOREIGN KEY (`idTeam`) REFERENCES `teams` (`idTeam`),
  ADD CONSTRAINT `substitutions_ibfk_4` FOREIGN KEY (`idTeam1`) REFERENCES `teams` (`idTeam`),
  ADD CONSTRAINT `substitutions_ibfk_5` FOREIGN KEY (`idTournament`) REFERENCES `tournaments` (`idTournament`);

--
-- Ограничения внешнего ключа таблицы `teams`
--
ALTER TABLE `teams`
  ADD CONSTRAINT `teams_ibfk_1` FOREIGN KEY (`idDiscipline`) REFERENCES `disciplines` (`idDiscipline`),
  ADD CONSTRAINT `teams_ibfk_2` FOREIGN KEY (`idTeam`) REFERENCES `participantTournament` (`idParticipant`);

--
-- Ограничения внешнего ключа таблицы `tournaments`
--
ALTER TABLE `tournaments`
  ADD CONSTRAINT `tournaments_ibfk_1` FOREIGN KEY (`idTournament`) REFERENCES `prizeTournament` (`idTournament`),
  ADD CONSTRAINT `tournaments_ibfk_2` FOREIGN KEY (`stage`) REFERENCES `tournamentStages` (`idStage`),
  ADD CONSTRAINT `tournaments_ibfk_3` FOREIGN KEY (`status`) REFERENCES `tournamentStatus` (`idStatus`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;