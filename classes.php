<?php
class Team
{
    var $name;
    var $place;
    var $prize; 
    var $description;
    var $wonTournaments;
    var $logo;
    var $appearenceDate;
    var $site;
    var $achievement;
}
class Players
{
    var $nickname;
    var $team;
    var $photoRef;
    var $status;
    var $role;
    var $accessionDate;
    var $facts;
    var $biography;
}   
class Tournament
{
    var $event;
    var $seria;
    var $location;
    var $prize;
    var $begDate;
    var $endDate;
    var $description;
    var $format;
    var $status;
    var $stage;
    var $stageHref;
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
    function insert_record()
    {  
        mysql_query($this->query);
        if(mysql_error($this->link))
        {echo $this->query."\nЗапрос не был выполнен. Код ошибки -".mysql_errno().". Cообщение ошибки - ".mysql_error().".";}
    }
    function show_record($columnName)
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
}
?>