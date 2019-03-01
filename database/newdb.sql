-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3006
-- Время создания: Фев 27 2019 г., 21:36
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
-- База данных: `newdb`
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
-- Структура таблицы `currentMatches`
--

CREATE TABLE `currentMatches` (
  `idMatch` int(11) NOT NULL COMMENT 'id матча',
  `idFirstTeam` int(11) NOT NULL COMMENT 'id первой команды',
  `idSecondTeam` int(11) NOT NULL COMMENT 'id второй команды',
  `date` datetime NOT NULL COMMENT 'время проведения матча'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `players`
--

CREATE TABLE `players` (
  `id` int(11) NOT NULL COMMENT 'id игрока',
  `idTeam` int(11) NOT NULL COMMENT 'id команды',
  `photo` varchar(1500) NOT NULL COMMENT 'ссылка на фото',
  `status` int(11) NOT NULL COMMENT 'статус',
  `role` int(11) NOT NULL COMMENT 'роль',
  `accessionData` date NOT NULL COMMENT 'дата присоединения'
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
-- Структура таблицы `teams`
--

CREATE TABLE `teams` (
  `idTeam` int(11) NOT NULL COMMENT 'id команды',
  `name` varchar(255) NOT NULL COMMENT 'название команды',
  `logo` varchar(1500) NOT NULL COMMENT 'путь к лого',
  `appearenceDate` date NOT NULL COMMENT 'дата основания',
  `site` varchar(1500) NOT NULL COMMENT 'сайт',
  `prize` int(11) NOT NULL COMMENT 'сумма призовых',
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
-- Индексы таблицы `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `prognoz`
--
ALTER TABLE `prognoz`
  ADD PRIMARY KEY (`idUser`);

--
-- Индексы таблицы `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`idTeam`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `autorization`
--
ALTER TABLE `autorization`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id игрока';

--
-- AUTO_INCREMENT для таблицы `prognoz`
--
ALTER TABLE `prognoz`
  MODIFY `idUser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `teams`
--
ALTER TABLE `teams`
  MODIFY `idTeam` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id команды', AUTO_INCREMENT=17;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
