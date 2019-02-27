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
class Query
{
    public $result;
    function execute_query($query)
    {
        $result=mysql_query($query);
        while($row = mysql_fetch_array($result))
        {
        echo "Номер: ".$row['idTeam']."<br>\n";
        }
    }
}

?>