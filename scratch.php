<?php
    class newClass{
        var $team1;
        var $team2;
        var $date;
        var $flag;
        var $guestLogin;
        var $guestId;
        var $hostname="localhost";
        var $username="root";
        var $password="";
        var $databaseName="newdb";
    }
    function parseData()
    {
        include_once('libraries/curl_query.php');
        include_once('libraries/simplehtmldom_1_7/simple_html_dom.php');
        $html=curl_get('https://game-tournaments.com/dota-2/matches');
        $dom=str_get_html($html);
        $teamname1=$dom->find('#block_matches_current .c1');
        $teamname2=$dom->find('#block_matches_current .c2');
        $datetime=$dom->find('#block_matches_current .sct');
        foreach ($dom->find('#block_matches_current .flag') as $flagPath) {
            $flagPath="game-tournaments.com".$flagPath->src."<br>";
        }
        $object=new newClass;
        $montName=array("Января","Февраля","Марта","Апреля","Мая","Июня","Июля","Августа","Сентября","Октября","Ноября","Декабря");
        for($i=0; $i<count($datetime)-1; $i++)//массив дат
        {
            $datetime[$i]=$datetime[$i]->plaintext;
            $date=new DateTime($datetime[$i]);
            $date->add(new DateInterval("PT3H"));
            $date=date_format($date, "d n Y H:i");
            $month=explode(" ", $date);
            $month[1]=$montName[$month[1]-1];
            $object->date[$i]=implode($month, " ");
        }
        for($i=0; $i<count($teamname1); $i++)//массив 1-ых команд
        {
            $object->team1[$i]=$teamname1[$i]->plaintext;
        }
        for($i=0; $i<count($teamname2); $i++)//массив 2-ых команд
        {
            $object->team2[$i]=$teamname2[$i]->plaintext;
        }
        for($i=0; $i<count($flagPicture); $i++)//массив 1-ых команд
        {
            $object->flag[$i]=$flagPicture[$i]->outertext;
            echo $object->flag[$i]."<br>";
        }
        var_dump($object->team1[1],$object->team2[1], $object->date[1]);
    }
    function enterToSystem()
    {
        echo"asd";
        $login=$_POST['lgn'];
        $password=$_POST['psd'];
        $object=new newClass;
        $link = mysql_connect($object->hostname, $object->username, $object->password) or die('Не удалось соединиться: ' . mysql_error());
        mysql_select_db($object->databaseName) or die('Не удалось выбрать базу данных');
        $query = "select * from autorization where login='$login' and password=md5('$password')";
        $result = mysql_query($query) or die('Запрос не удался: ' . mysql_error());
        if(mysql_num_rows($result)!=0){ //проверка логина и пароля
            while($row = mysql_fetch_array($result)) 
            {
                $object->guestLogin=$row['login'];
                $object->guestId=$row['user_id'];
            }
        }
        else echo "Неверный логин и пароль";
    }
    function registrationPerson()
    {
        $login=$_POST['lgn'];
        $password=$_POST['psd'];
        $object=new newClass;
        $link = mysql_connect($object->hostname, $object->username, $object->password) or die('Не удалось соединиться: ' . mysql_error());
        mysql_select_db($object->databaseName) or die('Не удалось выбрать базу данных');
        $query = "insert into autorization(login,password) values('$login',md5('$password'))";
        $result = mysql_query($query) or die(mysql_error());
    }

    function parseData1()
    {
        include_once('libraries/curl_query.php');
        include_once('libraries/simplehtmldom_1_7/simple_html_dom.php');
        $html=curl_get('https://dota2.ru/esport/teams/');
        $dom=str_get_html($html);
        $referal=$dom->find('.esport-team-list-single');
        foreach ($referal as $teamBlock) {
            echo $teamBlock->plaintext;
        }       
    }

    switch ($_POST["input"]) {
        case 'enter':
            enterToSystem();
        break;
        case 'registration':
            registrationPerson();
        break;
        case 'parse':
            parseData1();
        break;   
    }
    /*while($row = mysql_fetch_array($result))
    {
        echo "login: ".$row['login']."<br>\n";
        echo "password:".$row['password']."<br>\n";
    }*/
?>
