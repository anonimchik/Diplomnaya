<?php
$db=new Database;
switch ($_POST['action']) {
    case 'deleteTournament':
        $db->deleteTournament();
        break;
    case 'createTournament':
        $db->createTournament();
        break;
    case 'add tournament member':
        $db->addTournamentMember();   
        break;
    case 'update tournament data':
        $db->updateTornamentData();
        break;
    default:
        break;
}
$monthName=array(1=>"Января",
                2=>"Февраля",
                3=>"Марта",
                4=>"Апреля",
                5=>"Мая",
                6=>"Июня",
                7=>"Июля",
                8=>"Августа",
                9=>"Сентября",
                10=>"Октября",
                11=>"Ноября",
                12=>"Декабря");
class Team
{
    var $name;
    var $prize; 
    var $description;
    var $wonTournaments;
    var $logo;
    var $country;
    var $countryFlag;
    var $appearenceDate;
    var $site;
    var $achievement;
}
class Match
{
    var $event;
    var $datetime;
    var $teams;
    var $score;
    var $matchRef;
    var $format;
    var $round;
    var $status;
}
class Players
{
    var $nickname;
    var $team;
    var $age;
    var $country;
    var $countryFlag;
    var $line;
    var $name;
    var $photoRef;
    var $status;
    var $role;
    var $position;
    var $accessionDate;
    var $facts;
    var $biography;
    var $prize;
}   
class Tournament
{
    var $event;
    var $logo;
    var $alt;
    var $seria;
    var $slot;
    var $qualification;
    var $team;
    var $location;
    var $prize;
    var $begDate;
    var $endDate;
    var $description;
    var $format;
    var $status;
    var $linkTournament;
    var $miniLogo;
}
class Database
{
    private $link;
    private $hostname;
    private $username;
    private $password;
    private $database;
    private $query;
    function setDbSettings($hostname, $username, $password, $database)
    {
        $this->hostname=$hostname;
        $this->username=$username;
        $this->password=$password;
        $this->database=$database;
    }
    function open_connection()
    {
        $this->link = mysql_connect($this->hostname, $this->username, $this->password) or die('Не удалось соединиться: ' . mysql_error());
        mysql_select_db($this->database) or die('Не удалось выбрать базу данных');
    }
    function close_connection()
    {
        mysql_close($this->link);
    }
    function setQuery($query)
    {
        $this->query=$query;
    }
    function find_id($columnName)
    {
        $result=mysql_query($this->query);
        if(!mysql_error($this->link))
        {
            while($row = mysql_fetch_array($result)) 
            {
                return $row["$columnName"];
            }
        }
        else
        {
            echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
        }
    }
    function insert_members()
    {
        mysql_query($this->query);
        if(mysql_error($this->link))
        {
            echo $this->query."\nЗапрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
        }
    }
    function insert_team($team)
    {  
        mysql_query("call checkTeam('".$team."')");
        if(mysql_error($this->link))
        {
            echo $this->query."\nЗапрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
        }
        else
        {
            mysql_query($this->query);
            if(mysql_error($this->link))
            {
                echo $this->query."\nЗапрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
        }
    }

    function insert_player($player)
    {
        mysql_query("call checkPlayer('".$player."')");
        if(mysql_error($this->link))
        {
            echo "\nЗапрос не был выполнен. Такая никнейм уже существует";
        }
        else
        {
            mysql_query($this->query);
            if(mysql_error($this->link))
            {
                echo $this->query."\nЗапрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".<br>";
            }
        }
    }

    /*     работа с сайтом */
    
    function getMatchesForMainPage()
    {
        $this->query="SELECT matches.idMatch, name, date_format(date, '%d.%c.%Y %H:%i'), countryFlag, country, event, miniTournamentLogo, firstFinalScore
                    from matches
                    inner join teams on matches.idFirstTeam=teams.idTeam
                    inner join tournaments on matches.idTournament=tournaments.idTournament
                    left join matchdescription on matches.idMatch=matchdescription.idMatch
                    where status=-1
                    order by date desc";
        $result=mysql_query($this->query);
        $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, secondFinalScore
                    from matches
                    inner join teams on matches.idSecondTeam=teams.idTeam
                    inner join tournaments on matches.idTournament=tournaments.idTournament
                    left join matchdescription on matches.idMatch=matchdescription.idMatch
                    where status=-1
                    order by date desc";
        $subResult=mysql_query($this->query);
        if(!mysql_error($this->link))
        {
            while($row=mysql_fetch_array($result) and $subRow=mysql_fetch_array($subResult))
            {
                echo
                '
                    <div class="match-block-wrapper" data-href="matches1.php?idmatch='.$row['idMatch'].'">
                        <div class="teams-block-wrapper">
                            <div class="first-team">
                                <span>'.$row['name'].'</span>
                                <img src="'.$row['countryFlag'].'" title="'.$row['country'].'">
                            </div>
                            <span class="match-score">'.$row['firstFinalScore'].':'.$subRow['secondFinalScore'].'</span>
                            <div class="second-team">
                                <img src="'.$subRow['countryFlag'].'" title="'.$subRow['country'].'">
                                <span>'.$subRow['name'].'</span>
                            </div>
                        </div>
                        <div class="tournament-date-block">
                            <span class="datetime">'.$row[2].'</span>
                            <img  src="'.$row['miniTournamentLogo'].'" title="'.$subRow['event'].'">
                        </div>
                    </div>
                ';
            }
        }        
    }

    function show_tournaments()
    {
        global $monthName;
        $result=mysql_query($this->query);
        if(!mysql_error($this->link))
        {
            while($row = mysql_fetch_array($result)) 
            {
                echo '
                <div class="tournament-block-wrapper" data-href=tournaments1.php?idtour='.$row[0].'>
                    <label class="checkbox-del-tour"><i class="fas fa-check"></i><input type="checkbox" id="del-tour"></label>
                    <div class="tournament-block">
                        <div class="tournament-title-img">
                            <img src="./'.$row["tournamentLogo"].'" title="'.$row["event"].'" class="tournament-img">
                            <span class="tournament-name">'.$row["event"].'</span>
                        </div>
                        <div class="date-prize">
                            <span class="date">'.$row[3]." ".$monthName[$row[4]]." $row[5]".'</span>
                            <span class="prize">$'.$row["prize"].'</span>
                        </div>
                    </div>
                </div>';
            }
        }
        else
        {
            echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
        }
    }
    
    function getTournamentName($idtour)
    {
        if(!isset($idtour))
        {
            echo '<span class="tournament-title">Турниры</span>';
        }
        else
        {
            $this->query="select event from tournaments where idTournament=".$idtour;
            $result=mysql_query($this->query);
            if(!mysql_error($this->link))
            {
                while($row = mysql_fetch_array($result)) 
                {
                    echo '<span class="tournament-title">Турнир '.$row['event'].'</span>';
                }
            }
        }
    }

    function getTournamentPage($idtour)
    {
        global $monthName;
        if(!isset($idtour))
        {
            echo '
                <ul class="tabs">
                    <li class="tab-link current" data-tab="tab-1"><a href="">Прошедшие</a></li>
                    <li class="tab-link" data-tab="tab-2"><a href="">Текущие</a></li>
                    <li class="tab-link" data-tab="tab-3"><a href="">Будущие</a></li>
                </ul>
                <div id="tab-1" class="tab-content current">
                    <div class="tournament-indexx-wrapper">
                        <h3 class="tournament-header"><i class="fas fa-trophy"></i>Турниры</h3>';

            $this->query="select idTournament, event, tournamentLogo, DATE_FORMAT(dateBegin, '%e'), DATE_FORMAT(dateBegin, '%c'), DATE_FORMAT(dateBegin, '%Y'), dateEnd, prize, region 
                        from tournaments 
                        left JOIN regions on tournaments.idRegion=regions.idRegion
                        where dateEnd<=now()
                        limit 10";
            $result=mysql_query($this->query);
            if(!mysql_error($this->link))
            {
                while($row = mysql_fetch_array($result)) 
                {
                    echo '
                    <div class="tournament-block-wrapper" data-href=tournaments1.php?idtour='.$row[0].'>
                        <label class="checkbox-del-tour"><i class="fas fa-check"></i><input type="checkbox" id="del-tour"></label>
                        <div class="tournament-block">
                            <div class="tournament-title-img">
                                <img src="'.$row["tournamentLogo"].'" title="'.$row["event"].'" class="tournament-img">
                                <span class="tournament-name">'.$row["event"].'</span>
                            </div>
                            <div class="date-prize">
                                <span class="date">'.$row[3]." ".$monthName[$row[4]]." $row[5]".'</span>
                                <span class="prize">$'.$row["prize"].'</span>
                            </div>
                        </div>
                    </div>';
                }
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
            echo '
                    </div>
                </div>';

            echo ' 
                <div id="tab-2" class="tab-content">
                    <div class="tournament-indexx-wrapper">
                        <h3 class="tournament-header"><i class="fas fa-trophy"></i>Турниры</h3>';

            $this->query="select idTournament, event, tournamentLogo, DATE_FORMAT(dateBegin, '%e'), DATE_FORMAT(dateBegin, '%c'), DATE_FORMAT(dateBegin, '%Y'), prize 
            from tournaments where dateBegin<=now() limit 10";
            $result=mysql_query($this->query);
            if(!mysql_error($this->link))
            {
                while($row = mysql_fetch_array($result)) 
                {
                    echo '
                    <div class="tournament-block-wrapper" data-href=tournaments1.php?idtour='.$row[0].'>
                        <label class="checkbox-del-tour"><i class="fas fa-check"></i><input type="checkbox" id="del-tour"></label>
                        <div class="tournament-block">
                            <div class="tournament-title-img">
                                <img src="'.$row["tournamentLogo"].'" title="'.$row["event"].'" class="tournament-img">
                                <span class="tournament-name">'.$row["event"].'</span>
                            </div>
                            <div class="date-prize">
                                <span class="date">'.$row[3]." ".$monthName[$row[4]]." $row[5]".'</span>
                                <span class="prize">$'.$row["prize"].'</span>
                            </div>
                        </div>
                    </div>';
                }
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
            echo '
                    </div>
                </div>';

            echo '
                <div id="tab-3" class="tab-content">
                    <div class="tournament-indexx-wrapper">
                        <h3 class="tournament-header"><i class="fas fa-trophy"></i>Турниры</h3>';

            $this->query="select idTournament, event, tournamentLogo, DATE_FORMAT(dateBegin, '%e'), DATE_FORMAT(dateBegin, '%c'), DATE_FORMAT(dateBegin, '%Y'), prize 
            from tournaments where dateBegin>now() limit 10";
            if(!mysql_error($this->link))
            {
                while($row = mysql_fetch_array($result)) 
                {
                    echo ' 
                    <div class="tournament-block-wrapper" data-href=tournaments1.php?idtour='.$row[0].'>
                        <label class="checkbox-del-tour"><i class="fas fa-check"></i><input type="checkbox" id="del-tour"></label>
                        <div class="tournament-block">
                            <div class="tournament-title-img">
                                <img src="'.$row["tournamentLogo"].'" title="'.$row["event"].'" class="tournament-img">
                                <span class="tournament-name">'.$row["event"].'</span>
                            </div>
                            <div class="date-prize">
                                <span class="date">'.$row[3]." ".$monthName[$row[4]]." $row[5]".'</span>
                                <span class="prize">$'.$row["prize"].'</span>
                            </div>
                        </div>
                    </div>';
                }
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
            echo '
                    </div>
                </div>';
        }
        else
        {
            $this->getTournamentInfo($idtour);   
            $this->getTournamentMembers($idtour);
            echo /* создание блока добавления участника турнира */
            '
                <div class="team-block"> 
                    <i class="far fa-plus-square"></i>
                    <select id="tournament-member">
                        <option selected>Выберите команду</option>
            ';
                $query="SELECT idTeam, name FROM teams ORDER BY name";
                $this->getOptionsForSelect($query, "idTeam", "name");
            echo  
            '
                    </select>
                    <button id="add-tournament-member"><i class="fas fa-plus"></i>Добавить участника</button>
                </div>

                            </div>
                            </div>
                        </div>
                    </div>
                </div>
            ';
            echo
            '
                <div class="matches-prize-places-block-wrapper">
                    <div class="matches-block-wrapper">
                        <ul class="tabs">
                                <li class="tab-link current" data-tab="tab-1"><a href="">Прошедшие</a></li>
                                <li class="tab-link" data-tab="tab-2"><a href="">Текущие</a></li>
                                <li class="tab-link" data-tab="tab-3"><a href="">Будущие</a></li>
                        </ul>
            ';
                $this->getMatches($idtour);
            echo
            '    
            </div>
                <div class="prize-places-block-wrapper">
                    <h3 class="prize-places-header">Призовые места</h3>
                    <div class="prize-places-block">&nbsp;</div>
                </div>
            </div>
            ';

        }
    }

    function getTournamentMembers($teamId)
    {
        $team="";
        $this->query="SELECT DISTINCT teams.idTeam, teams.name, tournamentmembers.invited, teams.logo
                    FROM tournamentmembers 
                    left JOIN teams ON tournamentmembers.idTeam=teams.idTeam
                    left join players on tournamentmembers.idTeam=players.idTeam
                    where tournamentmembers.idTournament=".$teamId."";
        $result=mysql_query($this->query);
        if(!mysql_error($this->link))
        {
            while($row = mysql_fetch_array($result)) 
            {
                $team=$row['name'];
                echo 
                    ' 
                    <div class="team-block" data-href="teams1.php?idteam='.$row['idTeam'].'">
                        <a href="" class="team-title">'.$team.'</a>
                        <div class="players-wrapper-block">';
                        
                        $this->query="SELECT distinct idPlayer, players.idRole, players.countryFlag, players.nickname, players.country
                                    FROM tournamentmembers 
                                    left JOIN teams ON tournamentmembers.idTeam=teams.idTeam
                                    left join players on tournamentmembers.idTeam=players.idTeam
                                    where tournamentmembers.idTournament=".$teamId." and teams.name='".$team."'";
                        $subResult=mysql_query($this->query);
                        if(!mysql_error($this->link))
                        {
                            while($subRow=mysql_fetch_array($subResult))
                            {
                                echo 
                                    '
                                        <div class="players-block">
                                            <div class="position-block">
                                                <span class="position-number">'.$subRow['idRole'].'&nbsp;</span>
                                            </div>
                                            <div class="flag-nick" data-href="players1.php?idplayer='.$subRow['idPlayer'].'">
                                                <img src="'.$subRow['countryFlag'].'" title="'.$subRow['country'].'" class="player-country">
                                                <a href="" class="player">&nbsp;'.$subRow['nickname'].'&nbsp;</a>
                                            </div>
                                        </div>
                                    ';
                            }
                        }
                        
                echo
                    ' 
                        </div>     
                        <img src="'.$row['logo'].'" class="team-logo">  
                        <a class="invite">Europe</a>
                    </div>
                    ';
            }
        }
        else
        {
            echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
        }

        
    }
    
    function getMatches($idtour)
    {
        $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, firstFinalScore
                    from matches
                    inner join teams on matches.idFirstTeam=teams.idTeam
                    inner join tournaments on matches.idTournament=tournaments.idTournament
                    left join matchdescription on matches.idMatch=matchdescription.idMatch
                    where matches.idTournament=".$idtour." and status=1
                    order by date desc";
        $result=mysql_query($this->query);
        $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, secondFinalScore
            from matches
            inner join teams on matches.idSecondTeam=teams.idTeam
            inner join tournaments on matches.idTournament=tournaments.idTournament
            left join matchdescription on matches.idMatch=matchdescription.idMatch
            where matches.idTournament=".$idtour." and status=1
            order by date desc";
        $subResult=mysql_query($this->query);
        echo
        '
            <div id="tab-1" class="tab-content current">
                <div class="tournament-indexx-wrapper">
                <h3 class="matches-block-header"><i class="fas fa-gamepad">Матчи</i></h3>
        ';
        
        if(!mysql_error($this->link))
        {
            if(mysql_num_rows($result)!=0)
            {
                while($row=mysql_fetch_array($result) and $subRow=mysql_fetch_array($subResult))
                {
                    echo 
                    '
                        <div class="match-block-wrapper" data-href="matches1.php?idmatch='.$row['idMatch'].'">
                            <div class="teams-block-wrapper">
                                <div class="first-team">
                                    <span>'.$row['name'].'</span>
                                    <img src="'.$row['countryFlag'].'" title="'.$row['country'].'">
                                </div>
                                <span class="match-score">'.$row['fistFinalScore'].':'.$subRow['secondFinalScore'].'</span>
                                <div class="second-team">
                                    <img src="'.$subRow['countryFlag'].'" title="'.$subRow['country'].'">
                                    <span>'.$subRow['name'].'</span>
                                </div>
                            </div>
                            <div class="tournament-date-block">
                                <span class="datetime">'.$row['date'].'</span>
                                <img  src="'.$row['miniTournamentLogo'].'" title="'.$subRow['event'].'">
                            </div>
                        </div>
                    ';
                }
            }
            else
            {
                echo 
                '
                    <div class="match-block-wrapper">
                        &nbsp;
                    </div>
                ';
            }
        }
        else
        {
            echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
        }
        echo 
        '
                </div>
            </div>
        ';

        echo 
        '
            <div id="tab-2" class="tab-content">
                <div class="tournament-indexx-wrapper">
                <h3 class="matches-block-header"><i class="fas fa-gamepad">Матчи</i></h3>
        ';
        $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, firstFinalScore
                    from matches
                    inner join teams on matches.idFirstTeam=teams.idTeam
                    inner join tournaments on matches.idTournament=tournaments.idTournament
                    left join matchdescription on matches.idMatch=matchdescription.idMatch
                    where matches.idTournament=".$idtour." and status=0
                    order by date desc";
        $result=mysql_query($this->query);
        $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, secondFinalScore
                    from matches
                    inner join teams on matches.idSecondTeam=teams.idTeam
                    inner join tournaments on matches.idTournament=tournaments.idTournament
                    left join matchdescription on matches.idMatch=matchdescription.idMatch
                    where matches.idTournament=".$idtour." and status=0
                    order by date desc";
        $subResult=mysql_query($this->query);
        if(!mysql_error($this->link))
        {
            if(mysql_num_rows($result)!=0)
            {
                while($row=mysql_fetch_array($result) and $subRow=mysql_fetch_array($subResult))
                {
                    echo 
                    '
                        <div class="match-block-wrapper" data-href="matches1.php?idmatch='.$row['idMatch'].'">
                            <div class="teams-block-wrapper">
                                <div class="first-team">
                                    <span>'.$row['name'].'</span>
                                    <img src="'.$row['countryFlag'].'" title="'.$row['country'].'">
                                </div>
                                <span class="match-score">'.$row['firstFinalScore'].':'.$subRow['secondFinalScore'].'</span>
                                <div class="second-team">
                                    <img src="'.$subRow['countryFlag'].'" title="'.$subRow['country'].'">
                                    <span>'.$subRow['name'].'</span>
                                </div>
                            </div>
                            <div class="tournament-date-block">
                                <span class="datetime">'.$row['date'].'</span>
                                <img  src="'.$row['miniTournamentLogo'].'" title="'.$subRow['event'].'">
                            </div>
                        </div>
                    ';
                }
            }
            else
            {
                echo
                '
                    <div class="match-block-wrapper">
                        &nbsp;
                    </div>
                ';
            }
        }
        else
        {
            echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
        }
        echo 
        '
               </div>
            </div>
        '; 
        
        echo 
        '
            <div id="tab-3" class="tab-content">
                <div class="tournament-indexx-wrapper">
                <h3 class="matches-block-header"><i class="fas fa-gamepad">Матчи</i></h3>
        ';
        $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, firstFinalScore
                    from matches
                    inner join teams on matches.idFirstTeam=teams.idTeam
                    inner join tournaments on matches.idTournament=tournaments.idTournament
                    left join matchdescription on matches.idMatch=matchdescription.idMatch
                    where matches.idTournament=".$idtour." and status=-1
                    order by date desc";
        $result=mysql_query($this->query);
        $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, secondFinalScore
                    from matches
                    inner join teams on matches.idSecondTeam=teams.idTeam
                    inner join tournaments on matches.idTournament=tournaments.idTournament
                    left join matchdescription on matches.idMatch=matchdescription.idMatch
                    where matches.idTournament=".$idtour." and status=-1
                    order by date desc";
        $subResult=mysql_query($this->query);
        if(!mysql_error($this->link))
        {
            if(mysql_num_rows($result)!=0)
            {
                while($row=mysql_fetch_array($result) and $subRow=mysql_fetch_array($subResult))
                {
                    echo 
                    '
                        <div class="match-block-wrapper" data-href="matches1.php?idmatch='.$row['idMatch'].'">
                            <div class="teams-block-wrapper">
                                <div class="first-team">
                                    <span>'.$row['name'].'</span>
                                    <img src="'.$row['countryFlag'].'" title="'.$row['country'].'">
                                </div>
                                <span class="match-score">'.$row['firstFinalScore'].':'.$subRow['secondFinalScore'].'</span>
                                <div class="second-team">
                                    <img src="'.$subRow['countryFlag'].'" title="'.$subRow['country'].'">
                                    <span>'.$subRow['name'].'</span>
                                </div>
                            </div>
                            <div class="tournament-date-block">
                                <span class="datetime">'.$row['date'].'</span>
                                <img  src="'.$row['miniTournamentLogo'].'" title="'.$subRow['event'].'">
                            </div>
                        </div>
                    ';
                }
            }
            else
            {
                echo
                '
                    <div class="match-block-wrapper">
                        &nbsp;
                    </div>
                ';
            }
        }
        else
        {
            echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
        }
        echo 
        '
                </div>
            </div>  
        ';

    }

    function getTournamentInfo($idtour)
    {
        global $monthName;
        $this->query="SELECT date_format(dateBegin, '%d'), date_format(dateBegin, '%c'), date_format(dateBegin, '%Y'), date_format(dateBegin, '%m'), event, prize, seria, tournamentLogo
                    FROM tournaments
                    WHERE idTournament=".$idtour."";
        $result=mysql_query($this->query);
        if(!mysql_error($this->link))
        {
            while($row=mysql_fetch_array($result))
            {
                echo 
                '
                    <div class="tournament-wrapper">
                        <div class="tournament-page-block">
                            <div class="tournament-info-block">
                            <form>
                                <span class="change-information"><i class="fas fa-pen-square"></i></span>
                                <div class="hidden-action-panel">
                                    <button id="safe-changes"><i class="fas fa-check"></i>Сохранить изменения</button>
                                    <button id="no-safe-changes"><i class="fas fa-times"></i>Отмена</button>
                                </div>
                                <label class="tour-img">
                                    <img src="'.$row['tournamentLogo'].'" title="'.$row['event'].'">
                                </label>
                                <input type="file" id="tournament-img" required accept="image/*">
                                <div class="tournament-info-title">
                                    <span id="primary-tournament-title">'.$row['event'].'</span>
                                    <input id="tournament-title" type="text" value="'.$row['event'].'">
                                </div>
                                <div class="begDate-block">
                                    <label for="begDate">Дата начала</label>
                                    <span class="begDate" id="primary-begDate">'.$row[0].' '.$monthName[$row[1]].' '.$row[2].'</span>
                                    <input id="begDate" type="date" value="'.$row[2].'-'.$row[3].'-'.$row[0].'">
                                </div>
                                <div class="prize-block">
                                    <label for="prize-fond">Призовой фонд</label>
                                    <span class="prize" id="primary-prize">$ '.$row['prize'].'</span>
                                    <div class="numeric-field">
                                        <i class="fas fa-minus-circle"></i>
                                        <input type="number" required min="0" id="prize-fond" value="'.$row['prize'].'">
                                        <i class="fas fa-plus-circle"></i>
                                    </div>
                                </div>
                                <div class="seria-block">
                                    <label for="seria">Серия</label>
                                    <span class="seria" id="primary-seria">'.$row['seria'].'</span>
                                    <input type="text" id="seria" value="'.$row['seria'].'">
                                </div>
                            </form>
                            </div>
                            <div class="teams-wrapper-block">
                                <h3 class="teams-title"><i class="fas fa-users">Команды</i></h3>
                                <div class="teams-block">
                                    <div class="team-block-wrapper">
                ';
            }
        }
        else
        {
            echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
        }
    }

    function getTeamName($idteam)
    {
        if(!isset($idteam))
        {
            echo 
            '
                <span class="tournament-title">Команды</span>
            ';
        }
        else
        {
            $this->query="select name from teams where idTeam=".$idteam;
            $result=mysql_query($this->query);
            if(!mysql_error($this->link))
            {
                while($row = mysql_fetch_array($result)) 
                {
                    echo '<span class="tournament-title">Команда '.$row['name'].'</span>';
                }
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
        }
    }

    function getTeamInfo($idteam)
    {
        $this->query="SELECT name, logo, country, countryFlag, prize, description, site, appearenceDate 
                    FROM teams 
                    WHERE idTeam=".$idteam."";
        $result=mysql_query($this->query);
        if(!mysql_error($this->link))
        {
            while($row=mysql_fetch_array($result))
            {
                echo
                '
                    <div class="team-info-wrapper">
                        <img class="flag" src="'.$row['logo'].'" title="'.$row['name'].'">
                        <span class="team-title">'.$row['name'].'</span>
                        <div class="country-block">
                            <span>Страна</span>
                            <div class="country-flag">
                                <img class="country" src="'.$row['countryFlag'].'" title="'.$row['country'].'">
                                <span>'.$row['country'].'</span>
                            </div>
                        </div>
                        <div class="team-prize-block">
                            <span>Заработок</span>
                            <span class="prize">$ '.$row['prize'].'</span>
                        </div>
                        <div class="site-block">
                            <span>Сайт</span>
                            <a href="'.$row['site'].'">'.$row['site'].'</a>
                        </div>
                        <div class="appereance-date-block">
                            <span>Год образования</span>
                            <span>'.$row['appearenceDate'].'</span>
                        </div>
                        </div>
                        <div class="description-wrapper">
                            <h3 class="description-title"><i class="fas fa-info">Описание</i></h3>
                            <div class="description-block">'.$row['description'].'</div>
                        </div>
                    </div>
                ';
            }
        }
        else
        {
            echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
        }
        
    }

    function getLineup($idteam)
    {
        $this->query="SELECT idPlayer, photoRef, idRole, line, nickname, players.countryFlag, players.country
                    FROM teams
                    left JOIN players ON teams.idTeam=players.idTeam
                    WHERE teams.idTeam=".$idteam."";
        $result=mysql_query($this->query);
        if(!mysql_error($this->link))
        {
            while($row=mysql_fetch_array($result))
            {
                echo
                '
                    <div class="line-up-block">
                        <span class="position">'.$row['idRole'].'</span>
                        <img class="player-photo" src="'.$row['photoRef'].'" title="'.$row['nickname'].'">
                        <div class="nickname-block">
                            <span>Игрок</span>
                            <span class="nickname">'.$row['nickname'].'</span>
                        </div>
                        <div class="role-block">
                            <span>Роль</span>
                            <span>'.$row['line'].'</span>
                        </div>
                        <div class="country-block">
                            <span>Страна</span>
                            <div class="country-flag">
                                <img class="country" src="'.$row['countryFlag'].'" title="'.$row['country'].'">
                                <span>'.$row['country'].'</span>
                            </div>
                        </div>
                    </div>
                ';
            }
        }
        else
        {
            echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
        }
    }

    function getTeamPage($idteam)
    {
        if(!isset($idteam))
        {
            echo 
            '
                <div class="teams-wrapper">
                    <div class="list-header">
                        <span>Место</span>
                        <span style="flex-basis: 13%">Страна</span>
                        <span style="flex-basis: 15%">Команда</span>
                        <span style="flex-basis: 13%">Логотип</span>
                        <span>Заработано</span>
                    </div>
            ';
            $this->query="SELECT idTeam, name, logo, countryFlag, country, prize
                        FROM teams
                        ORDER BY prize desc";
            $result=mysql_query($this->query);
            if(!mysql_error($this->link))
            {
                $i=1;
                while($row=mysql_fetch_array($result))
                {
                    echo 
                    '
                        <div class="teams-block-wrapper">
                            <div class="team-teams-block" data-href="teams1.php?idteam='.$row['idTeam'].'">
                                <span>'.$i.'</span>
                                <img src="'.$row['countryFlag'].'" title="'.$row['country'].'">
                                <span>'.$row['name'].'</span>
                                <img class="teams-team-logo" src="'.$row['logo'].'" title="'.$row['name'].'">
                                <span>$ '.$row['prize'].'</span>
                            </div>
                        </div>
                    ';
                    $i++;
                }
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
        }
        else
        {
            echo
            '
                <div class="team-info-description-wrapper">
            ';
            $this->getTeamInfo($idteam);
            echo
            '
                <div class="line-up-block-wrapper">
                    <h3 class="line-up-title"><i class="fas fa-users">Состав</i></h3>
                    <div class="line-up-wrapper">  
            '; 
            $this->getLineup($idteam);
            echo
            '
                </div>
            ';
            echo
            '   </div>
                <div class="matches-achievements-wrapper">
                    <div class="matches-block">
                        <ul class="tabs">
                            <li class="tab-link current" data-tab="tab-1"><a href="">Прошедшие</a></li>
                            <li class="tab-link" data-tab="tab-2"><a href="">Текущие</a></li>
                            <li class="tab-link" data-tab="tab-3"><a href="">Будущие</a></li>
                        </ul>
                        <div id="tab-1" class="tab-content current">
                            <div class="tournament-indexx-wrapper">
                                <h3 class="matches-block-header"><i class="fas fa-gamepad">Матчи</i></h3>
            ';
            $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, firstFinalScore 
                        from matches 
                        left join teams on matches.idFirstTeam=teams.idTeam 
                        left join tournaments on matches.idTournament=tournaments.idTournament 
                        left join matchdescription on matches.idMatch=matchdescription.idMatch 
                        where matches.status=1 and matches.idFirstTeam=".$idteam." or matches.idSecondTeam=".$idteam."
                        order by date desc";
            $result=mysql_query($this->query);
            $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, secondFinalScore 
                        from matches 
                        left join teams on matches.idFirstTeam=teams.idTeam 
                        left join tournaments on matches.idTournament=tournaments.idTournament 
                        left join matchdescription on matches.idMatch=matchdescription.idMatch 
                        where matches.status=1 and matches.idFirstTeam=".$idteam." or matches.idSecondTeam=".$idteam." 
                        order by date desc";
            $subResult=mysql_query($this->query);           
            if(!mysql_error($this->link))
            {
                while($row=mysql_fetch_array($result) and $subRow=mysql_fetch_array($subResult))
                {
                    echo 
                    '
                        <div class="match-block-wrapper" data-href="matches1.php?idmatch='.$row['idMatch'].'">
                            <div class="teams-block-wrapper">
                                <div class="first-team">
                                    <span>'.$row['name'].'</span>
                                    <img src="'.$row['countryFlag'].'" title="'.$row['country'].'">
                                </div>
                                <span class="match-score">'.$row['firstFinalScore'].':'.$subRow['secondFinalScore'].'</span>
                                <div class="second-team">
                                    <img src="'.$subRow['countryFlag'].'" title="'.$subRow['country'].'">
                                    <span>'.$subRow['name'].'</span>       
                                </div>
                            </div>
                            <div class="tournament-date-block">
                                <span class="datetime">'.$row['date'].'</span>
                                <img  src="'.$row['miniTournamentLogo'].'" title="'.$subRow['event'].'">
                            </div>
                        </div>
                    ';
                }
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
            echo 
            '
                    </div>
                </div>
            ';

            echo 
            '
                <div id="tab-2" class="tab-content">
                    <div class="tournament-indexx-wrapper">
                        <h3 class="matches-block-header"><i class="fas fa-gamepad">Матчи</i></h3>
            ';
            $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, firstFinalScore 
                        from matches 
                        left join teams on matches.idFirstTeam=teams.idTeam 
                        left join tournaments on matches.idTournament=tournaments.idTournament 
                        left join matchdescription on matches.idMatch=matchdescription.idMatch 
                        where matches.status=0 and matches.idFirstTeam=".$idteam." or matches.idSecondTeam=".$idteam." 
                        order by date desc";
            $result=mysql_query($this->query);
            $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, secondFinalScore 
                        from matches 
                        left join teams on matches.idFirstTeam=teams.idTeam 
                        left join tournaments on matches.idTournament=tournaments.idTournament 
                        left join matchdescription on matches.idMatch=matchdescription.idMatch 
                        where matches.status=0 and matches.idFirstTeam=".$idteam." or matches.idSecondTeam=".$idteam."
                        order by date desc";
            $subResult=mysql_query($this->query);
            if(!mysql_error($this->link))
            {
                while($row=mysql_fetch_array($result) and $subRow=mysql_fetch_array($subResult))
                {
                    echo 
                    '
                        <div class="match-block-wrapper" data-href="matches1.php?idmatch='.$row['idMatch'].'">
                            <div class="teams-block-wrapper">
                                <div class="first-team">
                                    <span>'.$row['name'].'</span>
                                    <img src="'.$row['countryFlag'].'" title="'.$row['country'].'">
                                </div>
                                <span class="match-score">'.$row['firstFinalScore'].':'.$subRow['secondFinalScore'].'</span>
                                <div class="second-team">
                                    <img src="'.$subRow['countryFlag'].'" title="'.$subRow['country'].'">
                                    <span>'.$subRow['name'].'</span>  
                                </div>
                            </div>
                            <div class="tournament-date-block">
                                <span class="datetime">'.$row['date'].'</span>
                                <img  src="'.$row['miniTournamentLogo'].'" title="'.$subRow['event'].'">
                            </div>
                        </div>
                    ';
                }
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
            echo 
            '
                    </div>
                </div>
            '; 
            
            echo 
            '
                <div id="tab-3" class="tab-content">
                    <div class="tournament-indexx-wrapper">
                        <h3 class="matches-block-header"><i class="fas fa-gamepad">Матчи</i></h3>
            ';
            $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, firstFinalScore 
                        from matches 
                        left join teams on matches.idFirstTeam=teams.idTeam 
                        left join tournaments on matches.idTournament=tournaments.idTournament 
                        left join matchdescription on matches.idMatch=matchdescription.idMatch 
                        where matches.status=-1 and matches.idFirstTeam=".$idteam." or matches.idSecondTeam=".$idteam." 
                        order by date desc";
            $result=mysql_query($this->query);
            $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, secondFinalScore 
                        from matches 
                        left join teams on matches.idFirstTeam=teams.idTeam 
                        left join tournaments on matches.idTournament=tournaments.idTournament 
                        left join matchdescription on matches.idMatch=matchdescription.idMatch 
                        where matches.status=-1 and matches.idFirstTeam=".$idteam." or matches.idSecondTeam=".$idteam." 
                        order by date desc";
            $subResult=mysql_query($this->query);
            if(!mysql_error($this->link))
            {
                while($row=mysql_fetch_array($result) and $subRow=mysql_fetch_array($subResult))
                {
                    echo 
                    '
                        <div class="match-block-wrapper" data-href="matches1.php?idmatch='.$row['idMatch'].'">
                            <div class="teams-block-wrapper">
                                <span class="first-team">'.$row['name'].'</span>
                                <img src="'.$row['countryFlag'].'" title="'.$row['country'].'">
                                <span class="match-score">'.$row['firstFinalScore'].':'.$subRow['secondFinalScore'].'</span>
                                <img src="'.$subRow['countryFlag'].'" title="'.$subRow['country'].'">
                                <span class="second-team">'.$subRow['name'].'</span>                               
                            </div>
                            <div class="tournament-date-block">
                                <span class="datetime">'.$row['date'].'</span>
                                <img  src="'.$row['miniTournamentLogo'].'" title="'.$subRow['event'].'">
                            </div>
                        </div>
                    ';
                }
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
            echo 
            '
                            </div>
                        </div>
                    </div>
                    <div class="achievements-block">
                        <h3 class="achievements-header"><i class="fas fa-trophy">Достижения</i></h3>
                    </div>
                </div>
            ';
        }
    }

    function getPlayerName($idplayer)
    {
        if(!isset($idplayer))
        {
            echo 
            '
                <span class="tournament-title">Игроки</span>
            ';
        }
        else
        {
            $this->query="select nickname from players where idPlayer=".$idplayer;
            $result=mysql_query($this->query);
            if(!mysql_error($this->link))
            {
                while($row = mysql_fetch_array($result)) 
                {
                    echo '<span class="tournament-title">Игрок '.$row['nickname'].'</span>';
                }
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
        }
    }

    function getPlayerPage($idplayer)
    {
        if(!isset($idplayer))//формирование страницы с игроками
        {
            echo
            '
                <div class="list-header">
                    <span style="flex-basis: 10%">Срана</span>
                    <span style="flex-basis: 10%">Никнейм</span>
                    <span>Логотип команды</span>
                    <span>Название команды</span>
                    <span>Сумма призовых</span>
                </div>
            ';
            /* player-block-wrapper */
            $this->query="SELECT idPlayer, nickname, players.country, players.countryFlag, line, players.prize, teams.name, logo 
                        FROM players
                        LEFT JOIN teams ON teams.idTeam=players.idTeam 
                        ORDER BY prize desc
                        LIMIT 10";
            $result=mysql_query($this->query);
            if(!mysql_error($this->link))
            {
                while($row=mysql_fetch_array($result))
                {
                    echo 
                    '
                        <div class="player-index-block" data-href="players1.php?idplayer='.$row['idPlayer'].'">
                            <img src="'.$row['countryFlag'].'" title="'.$row['country'].'">
                            <span>'.$row['nickname'].'</span>
                            <img class="teams-team-logo" src="'.$row['logo'].'" title="'.$row['name'].'">
                            <span>'.$row['name'].'</span>
                            <span>$ '.$row['prize'].'</span>
                        </div>

                    ';
                }
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
        }
        else//формирование страницы конкретного игрока
        {
            $this->query="SELECT YEAR(now()) - YEAR(birthday) - (DATE_FORMAT(now(), '%m%d') < DATE_FORMAT(birthday, '%m%d')), nickname, players.name, players.country, players.description,
            players.countryFlag, photoRef, line, players.prize, role, teams.name, teams.idTeam
                        FROM players
                        LEFT JOIN teams ON teams.idTeam=players.idTeam
                        LEFT JOIN roles ON roles.idRole=players.idRole
                        WHERE idPlayer=".$idplayer."";
            $result=mysql_query($this->query);
            if(!mysql_error($this->link))
            {
                while($row=mysql_fetch_array($result))
                {
                    echo
                    '
                        <div class="player-info-wrapper">
                            <img class="players-photo" src="'.$row['photoRef'].'">
                            <span>'.$row['nickname'].'</span>
                            <div class="player-info-block">
                                <div>
                                    <span>Имя</span>
                                    <span>'.$row[2].'</span>
                                </div>
                                <div>
                                    <span>Возраст</span>
                                    <span>'.$row[0].' лет</span>
                                </div>
                                <div>
                                    <span>Страна</span>
                                    <span>'.$row['country'].' <img style="vertical-align: middle;" src="'.$row['countryFlag'].'" title="'.$row['country'].'"></span>
                                </div>
                                <div>
                                    <span>Команда</span>
                                    <a href="teams1.php?idteam='.$row['idTeam'].'">'.$row['name'].'</a>
                                </div>
                                <div>
                                    <span>Роль</span>
                                    <span>'.$row['role'].'</span>
                                </div>
                                <div>
                                    <span>Линия</span>
                                    <span>'.$row['line'].'</span>
                                </div>
                                <div>
                                    <span>Заработано</span>
                                    <span>$'.$row['prize'].'</span>
                                </div>
                            </div>
                        </div>
                        <div class="player-description-wrapper">
                            <h3 class="player-description-header"><i class="fas fa-info">Описание</i></h3>
                            <div class="description-block">'.$row[4].'</div>
                        </div>
                    ';
                }
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
        }
    }

    function getMatchName($idmatch)
    {
        if(!isset($idmatch))
        {
            echo 
            '
                <span class="tournament-title">Матчи</span>
            ';
        }
        else
        {
            $this->query="select name from matches
                        left join teams on matches.idFirstTeam=teams.idTeam 
                        where idMatch=".$idmatch."";
            $result=mysql_query($this->query);
            $this->query="select name from matches
                        left join teams on matches.idSecondTeam=teams.idTeam 
                        where idMatch=".$idmatch."";
            $subResult=mysql_query($this->query);
            if(!mysql_error($this->link))
            {
                while($row = mysql_fetch_array($result) and $subRow=mysql_fetch_array($subResult)) 
                {
                    echo '<span class="tournament-title">Матч  '.$row['name'].' vs '.$subRow['name'].'</span>';
                }
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
        }
    }

    function getMatchPage($idmatch)
    {
        $mapsArray=array(1=>"first",
                        2=>"second",
                        3=>"third",
                        4=>"fourth",
                        5=>"fifth");
        $idFirstTeam=0;
        $idSecondTeam=0;  
        if(!isset($idmatch))//формирование страницы с перечнем матчей
        {
            echo
            '
                <div class="matches-index-block">
                <ul class="tabs">
                    <li class="tab-link current" data-tab="tab-1"><a href="">Прошедшие</a></li>
                    <li class="tab-link" data-tab="tab-2"><a href="">Текущие</a></li>
                    <li class="tab-link" data-tab="tab-3"><a href="">Будущие</a></li>
                </ul>
                <div id="tab-1" class="tab-content current">
                    <div class="tournament-indexx-wrapper">
                        <h3 class="matches-block-header"><i class="fas fa-gamepad">Матчи</i></h3>
            ';
            $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, firstFinalScore 
                        from matches 
                        left join teams on matches.idFirstTeam=teams.idTeam 
                        left join tournaments on matches.idTournament=tournaments.idTournament 
                        left join matchdescription on matches.idMatch=matchdescription.idMatch 
                        where matches.status=1
                        order by date desc";
            $result=mysql_query($this->query);
            $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, secondFinalScore 
                        from matches 
                        left join teams on matches.idSecondTeam=teams.idTeam 
                        left join tournaments on matches.idTournament=tournaments.idTournament 
                        left join matchdescription on matches.idMatch=matchdescription.idMatch 
                        where matches.status=1
                        order by date desc";
            $subResult=mysql_query($this->query);           
            if(!mysql_error($this->link))//формирование блока с завершенными матчами
            {
                while($row=mysql_fetch_array($result) and $subRow=mysql_fetch_array($subResult))
                {
                    echo 
                    '
                        <div class="match-block-wrapper" data-href="matches1.php?idmatch='.$row['idMatch'].'">
                            <label class="checkbox-del-match"><i class="fas fa-check"></i><input type="checkbox" class="del-match"></label>
                            <div class="teams-tournament-block"> 
                                <div class="teams-block-wrapper">
                                    <div class="first-team">
                                        <span>'.$row['name'].'</span>
                                        <img src="'.$row['countryFlag'].'" title="'.$row['country'].'">
                                    </div>
                                    <span class="match-score">'.$row['firstFinalScore'].':'.$subRow['secondFinalScore'].'</span>
                                    <div class="second-team">
                                        <img src="'.$subRow['countryFlag'].'" title="'.$subRow['country'].'">
                                        <span>'.$subRow['name'].'</span>
                                    </div>
                                </div>
                                <div class="tournament-date-block">
                                    <span class="datetime">'.$row['date'].'</span>
                                    <img  src="'.$row['miniTournamentLogo'].'" title="'.$subRow['event'].'">
                                </div>
                            </div>
                        </div>
                    ';
                }
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
            echo 
            '
                    </div>
                </div>
            ';

            echo 
            '
                <div id="tab-2" class="tab-content">
                    <div class="tournament-indexx-wrapper">
                        <h3 class="matches-block-header"><i class="fas fa-gamepad">Матчи</i></h3>
            ';
            $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, firstFinalScore 
                        from matches 
                        left join teams on matches.idFirstTeam=teams.idTeam 
                        left join tournaments on matches.idTournament=tournaments.idTournament 
                        left join matchdescription on matches.idMatch=matchdescription.idMatch 
                        where matches.status=0 
                        order by date desc";
            $result=mysql_query($this->query);
            $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, secondFinalScore 
                        from matches 
                        left join teams on matches.idSecondTeam=teams.idTeam 
                        left join tournaments on matches.idTournament=tournaments.idTournament 
                        left join matchdescription on matches.idMatch=matchdescription.idMatch 
                        where matches.status=0
                        order by date desc";
            $subResult=mysql_query($this->query);
            if(!mysql_error($this->link))//формирование блока с лайв матчами
            {
                while($row=mysql_fetch_array($result) and $subRow=mysql_fetch_array($subResult))
                {
                    echo 
                    '
                        <div class="match-block-wrapper" data-href="matches1.php?idmatch='.$row['idMatch'].'">
                            <div class="teams-block-wrapper">
                                <idv class="first-team">
                                    <span>'.$row['name'].'</span>
                                    <img src="'.$row['countryFlag'].'" title="'.$row['country'].'">
                                </div>
                                <span class="match-score">'.$row['firstFinalScore'].':'.$subRow['secondFinalScore'].'</span>
                                <div class="second-team">
                                    <img src="'.$subRow['countryFlag'].'" title="'.$subRow['country'].'">
                                    <span>'.$subRow['name'].'</span>
                                </div>
                            </div>
                            <div class="tournament-date-block">
                                <span class="datetime">'.$row['date'].'</span>
                                <img  src="'.$row['miniTournamentLogo'].'" title="'.$subRow['event'].'">
                            </div>
                        </div>
                    ';
                }
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
            echo 
            '
                    </div>
                </div>
            '; 

            echo 
            '
                <div id="tab-3" class="tab-content">
                    <div class="tournament-indexx-wrapper">
                        <h3 class="matches-block-header"><i class="fas fa-gamepad">Матчи</i></h3>
            ';
            $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, firstFinalScore 
                        from matches 
                        left join teams on matches.idFirstTeam=teams.idTeam 
                        left join tournaments on matches.idTournament=tournaments.idTournament 
                        left join matchdescription on matches.idMatch=matchdescription.idMatch 
                        where matches.status=-1
                        order by date desc";
            $result=mysql_query($this->query);
            $this->query="SELECT matches.idMatch, name, date, countryFlag, country, event, miniTournamentLogo, secondFinalScore 
                        from matches 
                        left join teams on matches.idFirstTeam=teams.idTeam 
                        left join tournaments on matches.idTournament=tournaments.idTournament 
                        left join matchdescription on matches.idMatch=matchdescription.idMatch 
                        where matches.status=-1 
                        order by date desc";
            $subResult=mysql_query($this->query);
            if(!mysql_error($this->link))//формирование блока с будущими матчами
            {
                while($row=mysql_fetch_array($result) and $subRow=mysql_fetch_array($subResult))
                {
                    echo 
                    '
                        <div class="match-block-wrapper" data-href="matches1.php?idmatch='.$row['idMatch'].'">
                            <div class="teams-block-wrapper">
                                <div class="first-team">
                                    <span>'.$row['name'].'</span>
                                    <img src="'.$row['countryFlag'].'" title="'.$row['country'].'">
                                </div>
                                <span class="match-score">'.$row['firstFinalScore'].':'.$subRow['secondFinalScore'].'</span>
                                <div class="second-team">
                                    <img src="'.$subRow['countryFlag'].'" title="'.$subRow['country'].'">
                                    <span>'.$subRow['name'].'</span>
                                </div>
                            </div>
                            <div class="tournament-date-block">
                                <span class="datetime">'.$row['date'].'</span>
                                <img  src="'.$row['miniTournamentLogo'].'" title="'.$subRow['event'].'">
                            </div>
                        </div>
                    ';
                }
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
            echo 
            '
                    </div>
                </div> 
            ';
        }
        else //формирование старницы с конкретным матчем
        {
            $this->query="SELECT date, round, event, firstFinalScore, secondFinalScore, teams.name, logo, idTeam, matchFormat
                        from matches
                        LEFT JOIN matchdescription ON matchdescription.idMatch=matches.idMatch
                        LEFT JOIN matchformats ON matchformats.idMatchFormat=matchdescription.idFormat
                        LEFT JOIN teams ON teams.idTeam=matches.idFirstTeam
                        LEFT JOIN tournaments ON tournaments.idTournament=matches.idTournament
                        WHERE matches.idMatch=".$idmatch."";
            $result=mysql_query($this->query);
            if(!mysql_error($this->link))//вывод команды
            {
                while($row=mysql_fetch_array($result))
                {
                    $idFirstTeam=$row['idTeam'];
                    echo
                    '
                        <div class="match-description-wrapper">
                            <div class="first-team-description">
                                <div class="first-team-players-block">
                                    <div data-href="teams1.php?idteam='.$row['idTeam'].'" class="team">'.$row['name'].'</div>
                                        <div class="players-wrapper">
                    ';
                    $this->query="SELECT idPlayer, nickname, countryFlag, country
                                FROM players
                                LEFT JOIN matches ON matches.idFirstTeam=players.idTeam
                                WHERE matches.idFirstTeam=".$row['idTeam']."";
                    $player_result=mysql_query($this->query);
                    if(!mysql_error($this->link))//вывод игроков
                    {
                        while($playerRow=mysql_fetch_array($player_result))
                        {
                            echo 
                            '
                                <div class="player-block">
                                    <img src="'.$playerRow['countryFlag'].'" title="'.$playerRow['country'].'"><a href="players1.php?idplayer='.$playerRow['idPlayer'].'">'.$playerRow['nickname'].'</a>&nbsp;&nbsp; 
                                </div>
                            ';
                        }
                    }
                    else
                    {
                        echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
                    }
                    $matchFormat=$row['matchFormat'];
                    echo
                    '
                                            </div>
                                        </div>
                                    <img class="player-logo" src="'.$row['logo'].'" title="'.$row['name'].'">
                                </div>
                            <div class="match-description">
                                <div class="datetime">'.$row['date'].'</div> 
                                <div class=match-format>'.$row['matchFormat'].'</div>
                                <div data-score="'.$row['firstFinalScore'].':'.$row['secondFinalScore'].'" class="score">Показать счет</div>
                                <div>'.$row['event'].', '.$row['round'].'</div>
                            </div>
                    ';
                }
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
            $this->query="SELECT date, round, event, teams.name, logo, idTeam
                        from matches
                        LEFT JOIN matchdescription ON matchdescription.idMatch=matches.idMatch
                        LEFT JOIN teams ON teams.idTeam=matches.idSecondTeam
                        LEFT JOIN tournaments ON tournaments.idTournament=matches.idTournament
                        WHERE matches.idMatch=".$idmatch."";
            $subResult=mysql_query($this->query);
            if(!mysql_error($this->link))//вывод команды
            {
                while($subRow=mysql_fetch_array($subResult))
                {
                    $idSecondTeam=$subRow['idTeam'];
                    echo
                    '
                        <div class="match-description-wrapper">
                            <div class="first-team-description">
                                <img class="player-logo" src="'.$subRow['logo'].'" title="'.$subRow['name'].'">
                                <div class="second-team-players-block">
                                    <div data-href="teams1.php?idteam='.$subRow['idTeam'].'" class="team">'.$subRow['name'].'</div>
                                        <div class="players-wrapper">
                    ';
                    $this->query="SELECT idPlayer, nickname, countryFlag, country
                            FROM players
                            LEFT JOIN matches ON matches.idSecondTeam=players.idTeam
                            WHERE matches.idSecondTeam=".$subRow['idTeam']." and idMatch=".$idmatch."";
                    $playerSubResult=mysql_query($this->query);
                    if(!mysql_error($this->link))//вывод игроков
                    {
                        while($playerSubRow=mysql_fetch_array($playerSubResult))
                        {
                            echo 
                            '
                                <div class="player-match-block-wrapper">
                                    <img src="'.$playerSubRow['countryFlag'].'" title="'.$playerSubRow['country'].'"><a href="players1.php?idplayer='.$playerSubRow['idPlayer'].'">'.$playerSubRow['nickname'].'</a>&nbsp;&nbsp; 
                                </div>
                            ';
                        }
                    }
                    else
                    {
                        echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
                    }
                }
                
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
            echo
            '
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            ';
            
            $countMaps=preg_replace("(Best of)", "", $matchFormat);
            $i=1;
            echo
            '
                <div class="maps-block-wrapper">
                    <ul class="maps-tab">
            ';
            while($i<=$countMaps)
            {
               if($i==1)
               {
                   echo
                    '
                        <li class="map-link current" data-tab="tab-'.$i.'"><a href="">Игра '.$i.'</a></li>
                    ';
               }
               else
               {
                    echo
                    '
                        <li class="map-link" data-tab="tab-'.$i.'"><a href="">Игра '.$i.'</a></li>
                    ';
               }
               $i++;
            }
            echo
            '   
                </ul>
            ';

            $i=1;
            while($i<=$countMaps)
            {
                if($i==1)
                {
                    echo 
                    '
                        <div id="tab-'.$i.'" class="tab-content current">
                            <div class="img-container">
                    ';
                    $this->query="SELECT ".$mapsArray[$i]."MapPhoto 
                    FROM matches
                    LEFT JOIN matchdescription ON matchdescription.idMatch=matches.idMatch
                    WHERE matches.idMatch=".$idmatch."";
                    $result=mysql_query($this->query);  
                    if(!mysql_error ($this->link))
                    {
                        $row=mysql_fetch_array($result);
                        echo
                        '
                                    <img src="'.$row[$mapsArray[$i].'MapPhoto'].'">
                                </div>
                                <div class="match-info-panel"></div>
                            </div>
                        ';
                    }
                }
                else
                {
                    echo 
                    '
                        <div id="tab-'.$i.'" class="tab-content">
                            <div class="img-container">
                    ';
                    $this->query="SELECT ".$mapsArray[$i]."MapPhoto 
                    FROM matches
                    LEFT JOIN matchdescription ON matchdescription.idMatch=matches.idMatch
                    WHERE matches.idMatch=".$idmatch."";
                    $result=mysql_query($this->query);  
                    if(!mysql_error ($this->link))
                    {
                        $row=mysql_fetch_array($result);
                        echo
                        '
                                    <img src="'.$row[$mapsArray[$i].'MapPhoto'].'">
                                </div>
                                <div class="match-info-panel"></div>
                            </div>
                        ';
                    }
                    
                }
                $i++;
            }

            echo
            '        
                </div>
            ';
            $this->getPastMatches($idmatch, $idFirstTeam, $idSecondTeam);
        }
    }

    function getPastMatches($idmatch, $idFirstTeam, $idSecondTeam)
    {
        $this->query="SELECT name 
                    FROM teams 
                    WHERE idTeam=".$idFirstTeam."";
        $result=mysql_query($this->query);
        $row=mysql_fetch_array($result);
        echo
        '
            <div class="last-matches-wrapper">
            <div class="first-team-last-matches-block">
                <h3 class="first-team-last-matches-header"><i class="fas fa-gamepad">Последние матчи '.$row[0].'</i></h3>
        ';
        $this->query="SELECT idFirstTeam, idSecondTeam, firstFinalScore, date_format(date, '%c.%m.%Y %k:%i'), name, logo, event, miniTournamentLogo, matches.idMatch
                    FROM matches
                    LEFT JOIN matchdescription ON matchdescription.idMatch=matches.idMatch
                    LEFT JOIN teams ON teams.idTeam=matches.idFirstTeam
                    LEFT JOIN tournaments ON tournaments.idTournament=matches.idTournament
                    WHERE matches.idMatch<>".$idmatch." AND (idFirstTeam=".$idFirstTeam." OR idSecondTeam=".$idFirstTeam.")
                    ORDER BY date DESC";    
        $result=mysql_query($this->query);
        $this->query="SELECT idFirstTeam, idSecondTeam, secondFinalScore, date_format(date, '%c.%m.%Y %k:%i'), name, logo
                    FROM matches
                    LEFT JOIN matchdescription ON matchdescription.idMatch=matches.idMatch
                    LEFT JOIN teams ON teams.idTeam=matches.idSecondTeam
                    WHERE matches.idMatch<>".$idmatch." AND (idFirstTeam=".$idFirstTeam." OR idSecondTeam=".$idFirstTeam.")
                    ORDER BY date DESC";
        $subResult=mysql_query($this->query);
        if(!mysql_error($this->link))
        {
            while($row=mysql_fetch_array($result) and $subRow=mysql_fetch_array($subResult))
            {
                echo
                '
                    <div class="match-block" data-href="matches1.php?idmatch='.$row['idMatch'].'">
                        <div class="first-teams-block-wrapper">
                            <span>'.$row['name'].'</span>
                            <img src="'.$row['logo'].'" title="'.$row['name'].'">
                            <span>'.$subRow['secondFinalScore'].':'.$row['firstFinalScore'].'</span>
                            <img src="'.$subRow['logo'].'" title="'.$subRow['name'].'">
                            <span>'.$subRow['name'].'</span>
                        </div>
                        <div class="date-tournament-block">
                            <span>'.$row[3].'</span>
                            <img src="'.$row['miniTournamentLogo'].'" title="'.$row['event'].'">
                        </div>
                    </div>
                ';
            }
        }
        else
        {
            echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
        }
        echo 
        '
                </div>
        ';

        $this->query="SELECT name 
                    FROM teams 
                    WHERE idTeam=".$idSecondTeam."";
        $result=mysql_query($this->query);
        $row=mysql_fetch_array($result);
        echo
        '
            <div class="second-team-last-matches-block">
                <h3 class="second-team-last-matches-header"><i class="fas fa-gamepad">Последние матчи '.$row[0].'</i></h3>
        ';
        $this->query="SELECT idFirstTeam, idSecondTeam, firstFinalScore, date_format(date, '%c.%m.%Y %k:%i'), name, logo, event, miniTournamentLogo, matches.idMatch
                    FROM matches
                    LEFT JOIN matchdescription ON matchdescription.idMatch=matches.idMatch
                    LEFT JOIN teams ON teams.idTeam=matches.idFirstTeam
                    LEFT JOIN tournaments ON tournaments.idTournament=matches.idTournament
                    WHERE matches.idMatch<>".$idmatch." AND (idFirstTeam=".$idSecondTeam." OR idSecondTeam=".$idSecondTeam.")
                    ORDER BY date DESC";    
        $result=mysql_query($this->query);
        $this->query="SELECT idFirstTeam, idSecondTeam, secondFinalScore, date_format(date, '%c.%m.%Y %k:%i'), name, logo
                    FROM matches
                    LEFT JOIN matchdescription ON matchdescription.idMatch=matches.idMatch
                    LEFT JOIN teams ON teams.idTeam=matches.idSecondTeam
                    WHERE matches.idMatch<>".$idmatch." AND (idFirstTeam=".$idSecondTeam." OR idSecondTeam=".$idSecondTeam.")
                    ORDER BY date DESC";
        $subResult=mysql_query($this->query);
        if(!mysql_error($this->link))
        {
            while($row=mysql_fetch_array($result) and $subRow=mysql_fetch_array($subResult))
            {
                echo
                '
                    <div class="match-block" data-href="matches1.php?idmatch='.$row['idMatch'].'">
                        <div class="second-teams-block-wrapper">
                            <span>'.$row['name'].'</span>
                            <img src="'.$row['logo'].'" title="'.$row['name'].'">
                            <span>'.$row['firstFinalScore'].':'.$subRow['secondFinalScore'].'</span>
                            <img src="'.$subRow['logo'].'" title="'.$subRow['name'].'">
                            <span>'.$subRow['name'].'</span>
                        </div>
                        <div class="date-tournament-block">
                            <span>'.$row[3].'</span>
                            <img src="'.$row['miniTournamentLogo'].'" title="'.$row['event'].'">
                        </div>
                    </div>
                ';
            }
        }
        else
        {
            echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
        }
        echo
        '
            </div>
            </div>
        ';
    }

    function getOptionsForSelect($query, $idColumn, $nameColumn)
    {
        $this->query=$query;
        $result=mysql_query($this->query);
        if(!mysql_error($this->link))
        {
            while($row=mysql_fetch_array($result))
            {
                echo 
                '
                    <option value="'.$row[$idColumn].'">'.$row[$nameColumn].'</option>
                ';
            }
        }
        else
        {
            echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
        }
    }

    function deleteTournament()
    {
        $this->setDbSettings("localhost","root","","course_database");
        $this->open_connection();
        $this->query=$_POST['sql'];
        mysql_query($this->query);
        if(!mysql_error($this->link)){
            echo "Запись(и) удалена(ы) успешно";
        }
        else{
            echo "Запрос не выполнен. ".mysql_error();
        }

    }

    function createTournament()
    {
        $this->setDbSettings("localhost","root","","course_database");
        $this->open_connection();
        $this->query=$_POST['sql'];
        mysql_query($this->query);
        if(!mysql_error($this->link)){
            echo "Турнир успешно добавлен";
        }
        else{
            echo "Запрос не выполнен. ".mysql_error();
        }
    }

    function addTournamentMember()
    {
        $this->setDbSettings("localhost","root","","course_database");
        $this->open_connection();
        $this->query=$_POST['sql'];
        mysql_query($this->query);
        if(!mysql_error($this->link)){
            echo "Команда-участник успешно добавлена";
        }
        else{
            echo "Запрос не выполнен. ".mysql_error();
        }
    }

    function updateTornamentData()
    {
        $this->setDbSettings("localhost","root","","course_database");
        $this->open_connection();
        $this->query=$_POST['sql'];
        mysql_query($this->query);
        if(!mysql_error($this->link)){
            echo "Данные успешно изменены";
        }
        else{
            echo "Запрос не выполнен. ".mysql_error();
        }
    }

}

/*



*/

?>




