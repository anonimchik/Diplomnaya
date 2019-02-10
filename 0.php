<?php 
    include_once('libraries/curl_query.php');
    include_once('libraries/simplehtmldom_1_7/simple_html_dom.php');
    class team{ //класс команды
        var $flag;
        var $name;
        var $country;
        var $href;
        var $description;
        var $profit;
    }
    class player{ //класс игрока
        var $state;
        var $fullName;
        var $nickname;
        var $position;
        var $country;
        var $dateAccession;
        var $age;
        var $team;
    }
    class connection{ //класс соединения
        var $hostname="localhost";
        var $username="root";
        var $password="";
        var $databaseName="newdb";
    }
    $pageRefer="";
    a:
    $page='https://dota2.ru/esport/teams/'.$pageRefer;
    $html=curl_get($page);
    $dom=str_get_html($html);
    /*$team=new team;
    foreach ($dom->find('a.esport-team-list-single') as $referal) 
    {
        $team->href[]=$referal->href;
        $titleBlock=$referal->find('div.title');
        $imgBlock=$referal->find('div.image');
        $countryBlock=$referal->find('div.country');
        foreach ($titleBlock as $items) { //название команды
            $team->name[]=substr($items->innertext,0,stripos($items->innertext,"<br>"));
        }
        foreach ($countryBlock as $country) { //страна
            $team->country[]=$country->plaintext;
            $countryFlag=$country->find('img.flag');
            foreach ($countryFlag as $flag) { //флаг страны
                $team->flag[]=$flag->src;
            }
        }
    }   
    $player=new player;
    foreach ($team->href as $href) 
    {
        $html=curl_get("https://dota2.ru".$href);
        $dom=str_get_html($html);
        foreach ($dom->find('div.esport-team-view-info-other') as $descriptionBlock)
        {
            $team->description[]=substr($descriptionBlock->children(1)->plaintext,stripos($descriptionBlock->children(1)->plaintext," "));
            $team->profit[]=substr($descriptionBlock->children(2)->plaintext,stripos($descriptionBlock->children(2)->plaintext," "));   
        }
        foreach ($dom->find('div.esport-team-view-player-list') as $clearPlayerBlock) //парсинг информации о игроках
        { 
            $clearPlayerBlock->children(0)->outertext="";
            foreach ($clearPlayerBlock->find('div.esport-team-view-player-single') as $playerBlock) 
            {
                if($playerBlock->children(0)->plaintext!="Статус" && $playerBlock->children(0)->plaintext!="Тренер" && $playerBlock->children(0)->plaintext!="Запасной")
                {
                    if($playerBlock->children(0)->plaintext!="Статус"){$player->state[]=$playerBlock->children(0)->plaintext;}
                    if($playerBlock->children(1)->plaintext!="Игрок")
                    {
                        $player->nickname[]=substr($playerBlock->children(1)->plaintext, 0, stripos($playerBlock->children(1)->plaintext, " "));
                        $player->fullName[]=substr($playerBlock->children(1)->plaintext, stripos($playerBlock->children(1)->plaintext, " "));
                    }
                    if($playerBlock->children(2)->plaintext!="Позиция"){$player->position[]=$playerBlock->children(2)->plaintext;}
                    if($playerBlock->children(3)->plaintext!="Возраст"){$player->age[]=$playerBlock->children(3)->plaintext;}
                    if($playerBlock->children(4)->plaintext!="Страна"){$player->country[]=$playerBlock->children(4)->plaintext;}
                    if($playerBlock->children(5)->plaintext!="Принят"){$player->dateAccession[]=$playerBlock->children(5)->plaintext;}
                }
            }
        }
    }
    $connection=new connection;
    $pathPicture='./images/countryFlags/';
    for($i=0; $i<count($team->name); $i++) //запись в бд команд
    { 
        $link = mysql_connect($connection->hostname, $connection->username, $connection->password) or die('Не удалось соединиться: ' . mysql_error());
        mysql_select_db($connection->databaseName) or die('Не удалось выбрать базу данных');
        $query = "call checkTeam(trim(both from '".$team->name[$i]."'))";
        $result = mysql_query($query);
        if(!mysql_error())
        {
            saveImage("https://dota2.ru", "https://dota2.ru".$team->flag[$i], "./images/countryFlags/".mb_convert_encoding($team->country[$i], 'cp1251', 'utf-8').".png"); //сохранение флагов 
            $query="insert into teams(name, pathFlag, description) values(trim(both from '".$team->name[$i]."'),'".$pathPicture.$team->country[$i].".png', trim(both from '".$team->description[$i]."'))";
            $result=mysql_query($query) or die(mysql_error());
        }
    }
    foreach ($dom->find('.pagination_next') as $nextPage) 
    {
        $pageRefer=substr($nextPage->children(0)->href, strpos($nextPage->children(0)->href, "?"));
        goto a;
    }*/
    $page='https://dota2.ru/esport/teams/';
    $html=curl_get($page);
    $dom=str_get_html($html);
    foreach ($dom->find('.pagination_last a') as $countPage) {
        $countPage->children(0)->outertext="";
        $countPage=substr($countPage, strrpos($countPage, '="')+2, 2);
    }
    for ($i=0; $i<$countPage; $i++) 
    { 
        $html=curl_get($page);
        $dom=str_get_html($html);
        foreach ($dom->find('.pagination_next') as $nextPage) 
        {
            $pageRefer=substr($nextPage->children(0)->href, strpos($nextPage->children(0)->href, "?"));
            $page='https://dota2.ru/esport/teams/'.$pageRefer;
            break;
        }
        $team=new team;
        foreach ($dom->find('a.esport-team-list-single') as $referal) 
        {
            $team->href[]=$referal->href;
            $titleBlock=$referal->find('div.title');
            $imgBlock=$referal->find('div.image');
            $countryBlock=$referal->find('div.country');
            foreach ($titleBlock as $items) { //название команды
                $team->name[]=substr($items->innertext,0,stripos($items->innertext,"<br>"));
            }
            foreach ($countryBlock as $country) { //страна
                $team->country[]=$country->plaintext;
                $countryFlag=$country->find('img.flag');
                foreach ($countryFlag as $flag) { //флаг страны
                    $team->flag[]=$flag->src;
                }
            }
        }
    }
?>