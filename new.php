<?php
set_time_limit(600);
include_once('libraries/curl_query.php');
include_once('libraries/simplehtmldom_1_7/simple_html_dom.php');
include_once('database/connection.php');
include_once('classes.php');
$team=new Team;
$player=new Players;
$db=new Database('localhost', 'root', '', 'course_database');
$startTime=microtime(true);
$teamName=""; //переменная для хранения информации о названии команды
$ref=""; //переменная для хранения ссылки конкретной команды
$teamPage="";
$siteRef='https://www.cybersport.ru';
for ($i=0; $i<1; $i++) 
{ 
    if($href!=null)
    {
        $html=curl_get($siteRef.$href); //получение страницы
        $dom=str_get_html($html); //формирование объекта
    }
    else
    {
        $html=curl_get($siteRef."/base/teams?disciplines=21"); //получение страницы
        $dom=str_get_html($html); //формирование объекта
    }
    foreach ($dom->find('.pagination__item--next') as $pagination) {
        $href="/base/teams?disciplines=21&".substr($pagination->href, strpos($pagination->href, "page")); //получение ссылки на следущую страницу
    }
    foreach ($dom->find('#active tr') as $teamTable)
    {
        if($teamTable->children(1)->plaintext!="Команда")
        {
            $ref=substr($teamTable->children(1)->innertext, strpos($teamTable->children(1)->innertext, '"')+1, strpos($teamTable->children(1)->innertext, '" ')-2-strpos($teamTable->children(1)->innertext, '="')); //ссылка на страницу команды
        }
        if($teamTable->children(3)->plaintext!="Сумма призовых"){$team->prize[]=$teamTable->children(3);} //сумма призовых
        if($ref!=null)
        {
            $html=curl_get($siteRef.$ref); //получение страницы
            $dom=str_get_html($html); //формирование объекта
        }
        foreach ($dom->find('.page--team') as $page) 
        {
            $team->logo[]=substr($page->children(1)->children(0)->children(0)->innertext, strpos($page->children(1)->children(0)->children(0)->innertext, '"')+1, strpos($page->children(1)->children(0)->children(0)->innertext, '" ')-1-strpos($page->children(1)->children(0)->children(0)->innertext, '"')); //ссылка на лого команды
            $team->name[]=$teamName=$page->children(1)->children(0)->children(1)->children(0)->children(0)->plaintext; //название команды
            $team->appearenceDate[]=$page->children(1)->children(0)->children(1)->children(0)->children(1)->plaintext; //дата появления команды
            $team->site[]=substr($page->children(1)->children(0)->children(1)->children(0)->children(2)->plaintext, strpos($page->children(1)->children(0)->children(1)->children(0)->children(2)->plaintext, " ")); //сайт команды
            $team->prize[]=substr($page->children(1)->children(0)->children(1)->children(1)->plaintext, strpos($page->children(1)->children(0)->children(1)->children(1)->plaintext, " ")+1); //призовые команды
            $team->description[]=$page->children(1)->children(2)->children(1)->children(0)->plaintext; //описание команды
            $team->achievement[]=$page->children(1)->children(2)->children(1)->children(1)->plaintext; //достижения команды
            foreach ($dom->find('.gamers__list--active') as $players) {
                $players->children(0)->outertext=""; //удаление первого блока-потомка
                if(is_object($players->children(1))) //получение данных 1-ого игрока
                {
                    $player->nickname[]=$players->children(1)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                    $player->photoRef[]=$players->children(1)->children(0)->children(0)->children(0)->children(0)->src; //ссылка на фото игрока
                    $player->team[]=$teamName; //команда игрока
                    $player->status[]=$players->children(1)->children(1)->plaintext; //статус игрока
                    $player->role[]=$players->children(1)->children(2)->plaintext; //позиция игрока
                    $player->accessionDate[]=$players->children(1)->children(3)->plaintext; //дата присоединения к команде
                }
                if(is_object($players->children(2))) //получение данных 2-ого игрока
                {
                    $player->nickname[]=$players->children(2)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                    $player->photoRef[]=$players->children(2)->children(0)->children(0)->children(0)->children(0)->src; //ссылка на фото игрока
                    $player->team[]=$teamName; //команда игрока
                    $player->status[]=$players->children(2)->children(1)->plaintext; //статус игрока
                    $player->role[]=$players->children(2)->children(2)->plaintext; //позиция игрока
                    $player->accessionDate[]=$players->children(2)->children(3)->plaintext; //дата присоединения к команде
                }
                if(is_object($players->children(3))) //получение данных 3-его игрока
                {
                    $player->nickname[]=$players->children(3)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                    $player->photoRef[]=$players->children(3)->children(0)->children(0)->children(0)->children(0)->src; //ссылка на фото игрока
                    $player->team[]=$teamName; //команда игрока
                    $player->status[]=$players->children(3)->children(1)->plaintext; //статус игрока
                    $player->role[]=$players->children(3)->children(2)->plaintext; //позиция игрока
                    $player->accessionDate[]=$players->children(3)->children(3)->plaintext; //дата присоединения к команде
                }
                if(is_object($players->children(4))) //получение данных 4-ого игрока
                {
                    $player->nickname[]=$players->children(4)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                    $player->photoRef[]=$players->children(4)->children(0)->children(0)->children(0)->children(0)->src; //ссылка на фото игрока
                    $player->team[]=$teamName; //команда игрока
                    $player->status[]=$players->children(4)->children(1)->plaintext; //статус игрока
                    $player->role[]=$players->children(4)->children(2)->plaintext; //позиция игрока
                    $player->accessionDate[]=$players->children(4)->children(3)->plaintext; //дата присоединения к команде
                }
                if(is_object($players->children(5))) //получение данных 5-ого игрока
                {
                    $player->nickname[]=$players->children(5)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                    $player->photoRef[]=$players->children(5)->children(0)->children(0)->children(0)->children(0)->src; //ссылка на фото игрока
                    $player->team[]=$teamName; //команда игрока
                    $player->status[]=$players->children(5)->children(1)->plaintext; //статус игрока
                    $player->role[]=$players->children(5)->children(2)->plaintext; //позиция игрока
                    $player->accessionDate[]=$players->children(5)->children(3)->plaintext; //дата присоединения к команде
                }
                if(is_object($players->children(6))) //получение данных 6-ого игрока
                {
                    $player->nickname[]=$players->children(6)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                    $player->photoRef[]=$players->children(6)->children(0)->children(0)->children(0)->children(0)->src; //ссылка на фото игрока
                    $player->team[]=$teamName; //команда игрока
                    $player->status[]=$players->children(6)->children(1)->plaintext; //статус игрока
                    $player->role[]=$players->children(6)->children(2)->plaintext; //позиция игрока
                    $player->accessionDate[]=$players->children(6)->children(3)->plaintext; //дата присоединения к команде
                }
            }
        }
    }
}
$db->setDbSettings("localhost", "root", "", "course_database");
$db->open_connection();
for($i=0; $i<count($team->logo); $i++)
{
    if(strpos($team->logo[$i], "bez-nazvaniya")===false)
    {
        //saveImage("", $team->logo[$i], "./images/teamLogos/".mb_convert_encoding($team->name[$i], 'cp1251', 'utf-8').".png");
        $db->setQuery("insert into teams(name, logo, appereanceDate, site, prize, description, achievement) values('".$team->name[$i]."', ./images/teamLogos/),".mb_convert_encoding($team->name[$i], 'cp1251', 'utf-8').".png,  
        '".$team->appearenceDate[$i]."','".$team->site[$i]."', ".$team->prize[$i].", '".$team->description[$i]."', '".$team->achievement[$i]."' )");
        $db->execute_query();
        break;
    }       
}
/*for($i=0; $i<count($player->photoRef); $i++)
{
    if($player->photoRef[$i]!=null)
    {
        saveImage("", $player->photoRef[$i], "./images/playerPhotos/".mb_convert_encoding($player->nickname[$i], 'cp1251', 'utf-8').'.png');
    }
}*/
//$db->setQuery("select * from teams");
$db->close_connection();
echo number_format((microtime(true)-$startTime)/60, 2, ":" ,"");
?>