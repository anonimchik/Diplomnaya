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
        if($this->link){echo "успешно";}
    }
    function close_connection()
    {
        mysql_close($this->link);
    }
    function setQuery($query)
    {
        $this->query=$query;
    }
    function execute_query()
    {
        $result=mysql_query($this->query);
        /*while($row = mysql_fetch_array($result))
        {
            echo "Номер: ".$row['idTeam']."<br>\n";
        }*/
    }
}
?>