<?php
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
      
    /*     работа с сайтом */

    function show_tournaments()
    {
        global $monthName;
        $result=mysql_query($this->query);
        if(!mysql_error($this->link))
        {
            while($row = mysql_fetch_array($result)) 
            {
                echo ' 
                <div class="tournament-block-wrapper" data-href=tournament1.php?idtour='.$row[0].'>
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

            $this->query="select idTournament, event, tournamentLogo, DATE_FORMAT(dateBegin, '%e'), DATE_FORMAT(dateBegin, '%c'), DATE_FORMAT(dateBegin, '%Y'), prize 
            from tournaments where dateBegin<=now() limit 10";
            $result=mysql_query($this->query);
            if(!mysql_error($this->link))
            {
                while($row = mysql_fetch_array($result)) 
                {
                    echo ' 
                    <div class="tournament-block-wrapper" data-href=tournament1.php?idtour='.$row[0].'>
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
                    <div class="tournament-block-wrapper" data-href=tournament1.php?idtour='.$row[0].'>
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
                    <div class="tournament-block-wrapper" data-href=tournament1.php?idtour='.$row[0].'>
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
            $this->query="select idTournament, event, tournamentLogo, DATE_FORMAT(dateBegin, '%e'), DATE_FORMAT(dateBegin, '%c'), DATE_FORMAT(dateBegin, '%Y'), prize 
            from tournaments where idTournament=$idtour";
            $result=mysql_query($this->query);
            if(!mysql_error($this->link))
            {
                while($row = mysql_fetch_array($result)) 
                {
                    /*echo ' 
                    <div class="tournament-block-wrapper" data-href=tournament1.php?idtour='.$row[0].'>
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
                    </div>';*/
                }
            }
            else
            {
                echo "Запрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";
            }
        }
    }
}
?>