<?php

set_time_limit(600);
include_once('libraries/curl_query.php');
include_once('libraries/simplehtmldom_1_7/simple_html_dom.php');
include_once('classes.php');
$team=new Team;
$player=new Players;
$db=new Database('localhost', 'root', '', 'course_database');
$tournament=new Tournament;
$startTime=microtime(true);
$teamName=""; //переменная для хранения информации о названии команды
$ref=""; //переменная для хранения ссылки конкретной команды
$teamPage="";
$siteRef='https://ggscore.com';

for($i=0; $i<2; $i++) //передвижение по страницам
{
    if($href!=null)
    {
        $html=curl_get($siteRef.$href);
        $dom=str_get_html($html);
    }
    else
    {
        $html=curl_get($siteRef."/ru/dota-2/tournaments");
        $dom=str_get_html($html);
    }
    switch ($i) {
        case 0:
            foreach($dom->find(".pagination") as $pagination)
            {
            $href=$pagination->children(1)->children(0)->href;
            }
        break;
        case 1:
            foreach($dom->find(".pagination") as $pagination)
            {
            $href=$pagination->children(2)->children(0)->href;
            }
        break;
        default:
            foreach($dom->find(".pagination") as $pagination)
            {
            $href=$pagination->children(3)->children(0)->href;
            }
        break;
    }
    foreach($dom->find(".t-item") as $match_table) 
    {
        $html=curl_get($siteRef.$match_table->children(0)->children(0)->href);
        $dom=str_get_html($html);
        foreach ($dom->find(".t-top") as $main_block) 
        {
            //echo $main_block;
            //$tournament->event[]=preg_replace("(Dota 2 турнир)", "", $main_block->children(1)->plaintext);
            if(!is_object($main_block->children(3))) // турнир ожидается
            {
                $tournament->logo[]=$main_block->children(2)->children(0)->children(0)->children(0)->children(0)->children(0)->src;
                $tournament->event[]=$main_block->children(2)->children(0)->children(0)->children(0)->children(1)->children(0)->plaintext;
                $tournament->description[]=$main_block->children(2)->children(0)->children(0)->children(0)->children(1)->children(2)->plaintext;
                $tournament->begDate[]=$tournament->description[]=$main_block->children(2)->children(0)->children(0)->children(0)->children(1)->children(1)->children(0)->children(0)->children(1)->plaintext; 
                $tournament->prize[]=preg_replace('(\$ )', "", $main_block->children(2)->children(0)->children(0)->children(0)->children(1)->children(1)->children(0)->children(1)->children(1));
                
            }
            else //турнир прошел или длится
            {
                $tournament->logo[]=$main_block->children(3)->children(0)->children(0)->children(0)->children(0)->children(0)->src;
                $tournament->event[]=$main_block->children(3)->children(0)->children(0)->children(0)->children(1)->children(0)->plaintext;
                $tournament->description[]=$main_block->children(3)->children(0)->children(0)->children(0)->children(1)->children(2)->plaintext;
                $tournament->begDate[]=$tournament->description[]=$main_block->children(3)->children(0)->children(0)->children(0)->children(1)->children(1)->children(0)->children(0)->children(1)->plaintext; 
                $tournament->prize[]=preg_replace('(\$ )', "", $main_block->children(3)->children(0)->children(0)->children(0)->children(1)->children(1)->children(0)->children(1)->children(1));
                if(is_object($main_block->children(3)->children(0)->children(0)->children(0)->children(1)->children(1)->children(0)->children(3)))
                {
                    $tournament->location[]=$main_block->children(3)->children(0)->children(0)->children(0)->children(1)->children(1)->children(0)->children(3)->children(1)->plaintext;
                }
                foreach($dom->find('div.tb') as $team_card)
                {
                    if(!is_object($team_card->children(0)->children(0)))
                    {
                        $tournament->team[]=$teamName=$team_card->children(0)->plaintext;
                        $team->href[]=$team_card->children(0)->href;
                        $team->logo[]=$team_card->children(1)->children(0)->children(0)->src;
                        $tournament->qualification[]=$team_card->children(1)->children(2)->plaintext;
                        if(is_object($team_card->children(1)->children(1)))
                        {

                            if(is_object($team_card->children(1)->children(1)->children(0)->children(0)))
                            {
                               echo $team_card->children(1)->children(1)->children(0);
                                foreach($dom->find('.teamcard table tbody tr') as $player_card)
                                {
                                    echo $player_card;
                                    $html=curl_get($siteRef."/ru/dota-2/player/".$player_card->children(1)->children(1)->plaintext);
                                    //var_dump($html);
                                    $dom=str_get_html($html);
                                    break;
                                }
                            }
                            else
                            {
                                //   
                            }
                        }                    
                    }
                    else
                    {
                       $tournament->logo[]=$team_card->children(0)->children(0)->children(0)->src;
                       $tournament->slot[]=$team_card->children(0)->children(2)->plaintext;
                    }
                }
            }   
            
        }
        
    }
}


/*
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
        if($ref!=null)
        {
            $html=curl_get($siteRef.$ref); //получение страницы
            $dom=str_get_html($html); //формирование объекта
        }
        foreach ($dom->find('.page--team') as $page) 
        { 
            $team->logo[]=substr($page->children(1)->children(0)->children(0)->innertext, strpos($page->children(1)->children(0)->children(0)->innertext, '"')+1, strpos($page->children(1)->children(0)->children(0)->innertext, '" ')-1-strpos($page->children(1)->children(0)->children(0)->innertext, '"')); //ссылка на лого команды
            $team->name[]=$teamName=$page->children(1)->children(0)->children(1)->children(0)->children(0)->plaintext; //название команды
            $team->appearenceDate[]=substr($page->children(1)->children(0)->children(1)->children(0)->children(1)->plaintext, strrpos($page->children(1)->children(0)->children(1)->children(0)->children(1)->plaintext, " "), strrpos($page->children(1)->children(0)->children(1)->children(0)->children(1)->plaintext, ".")-strrpos($page->children(1)->children(0)->children(1)->children(0)->children(1)->plaintext, " ")); //дата появления команды
            $team->site[]=substr($page->children(1)->children(0)->children(1)->children(0)->children(2)->plaintext, strpos($page->children(1)->children(0)->children(1)->children(0)->children(2)->plaintext, " ")); //сайт команды
            $team->prize[]=preg_replace('(\s|\$)', '', substr($page->children(1)->children(0)->children(1)->children(1)->plaintext, strpos($page->children(1)->children(0)->children(1)->children(1)->plaintext, " ")+1)); //призовые команды
            $team->description[]=$page->children(1)->children(2)->children(1)->children(0)->plaintext; //описание команды
            $team->achievement[]=$page->children(1)->children(2)->children(1)->children(1)->plaintext; //достижения команды
            foreach ($dom->find('.gamers__list--active') as $players) 
            {
                $players->children(0)->outertext=""; //удаление первого блока-потомка
                if(is_object($players->children(1))) //получение данных 1-ого игрока
                {
                    $player->nickname[]=$players->children(1)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                    $player->photoRef[]=$players->children(1)->children(0)->children(0)->children(0)->children(0)->src; //ссылка на фото игрока
                    $player->team[]=$teamName; //команда игрока
                    $player->status[]=$players->children(1)->children(1)->plaintext; //статус игрока
                    $player->role[]=$players->children(1)->children(2)->plaintext; //позиция игрока
                    $player->accessionDate[]=$players->children(1)->children(3)->plaintext; //дата присоединения к команде
                    $ref=$players->children(1)->children(0)->children(0)->href;
                    $html=curl_get($siteRef.$ref);
                    $dom=str_get_html($html);
                    foreach($dom->find('.facts__description') as $playerBlock)
                    {
                        $player->facts[]=$playerBlock->children(0)->children(1)->plaintext; //факты
                        $player->biography[]=$playerBlock->children(1); //биография
                    }
                }
                if(is_object($players->children(2))) //получение данных 2-ого игрока
                {
                    $player->nickname[]=$players->children(2)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                    $player->photoRef[]=$players->children(2)->children(0)->children(0)->children(0)->children(0)->src; //ссылка на фото игрока
                    $player->team[]=$teamName; //команда игрока
                    $player->status[]=$players->children(2)->children(1)->plaintext; //статус игрока
                    $player->role[]=$players->children(2)->children(2)->plaintext; //позиция игрока
                    $player->accessionDate[]=$players->children(2)->children(3)->plaintext; //дата присоединения к команде
                    $ref=$players->children(2)->children(0)->children(0)->href;
                    foreach($dom->find('.facts__description') as $playerBlock)
                    {
                        $player->facts[]=$playerBlock->children(0)->children(1)->plaintext; //факты
                        $player->biography[]=$playerBlock->children(1); //биография
                    }
                }
                if(is_object($players->children(3))) //получение данных 3-его игрока
                {
                    $player->nickname[]=$players->children(3)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                    $player->photoRef[]=$players->children(3)->children(0)->children(0)->children(0)->children(0)->src; //ссылка на фото игрока
                    $player->team[]=$teamName; //команда игрока
                    $player->status[]=$players->children(3)->children(1)->plaintext; //статус игрока
                    $player->role[]=$players->children(3)->children(2)->plaintext; //позиция игрока
                    $player->accessionDate[]=$players->children(3)->children(3)->plaintext; //дата присоединения к команде
                    $ref=$player->ref[]=$players->children(3)->children(0)->children(0)->href;
                    foreach($dom->find('.facts__description') as $playerBlock)
                    {
                        $player->facts[]=$playerBlock->children(0)->children(1)->plaintext; //факты
                        $player->biography[]=$playerBlock->children(1); //биография
                    }
                }
                if(is_object($players->children(4))) //получение данных 4-ого игрока
                {
                    $player->nickname[]=$players->children(4)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                    $player->photoRef[]=$players->children(4)->children(0)->children(0)->children(0)->children(0)->src; //ссылка на фото игрока
                    $player->team[]=$teamName; //команда игрока
                    $player->status[]=$players->children(4)->children(1)->plaintext; //статус игрока
                    $player->role[]=$players->children(4)->children(2)->plaintext; //позиция игрока
                    $player->accessionDate[]=$players->children(4)->children(3)->plaintext; //дата присоединения к команде
                    $ref=$players->children(4)->children(0)->children(0)->href;
                    foreach($dom->find('.facts__description') as $playerBlock)
                    {
                        $player->facts[]=$playerBlock->children(0)->children(1)->plaintext; //факты
                        $player->biography[]=$playerBlock->children(1); //биография
                    }
                }
                if(is_object($players->children(5))) //получение данных 5-ого игрока
                {
                    $player->nickname[]=$players->children(5)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                    $player->photoRef[]=$players->children(5)->children(0)->children(0)->children(0)->children(0)->src; //ссылка на фото игрока
                    $player->team[]=$teamName; //команда игрока
                    $player->status[]=$players->children(5)->children(1)->plaintext; //статус игрока
                    $player->role[]=$players->children(5)->children(2)->plaintext; //позиция игрока
                    $player->accessionDate[]=$players->children(5)->children(3)->plaintext; //дата присоединения к команде
                    $ref=$players->children(5)->children(0)->children(0)->href;
                    foreach($dom->find('.facts__description') as $playerBlock)
                    {
                        $player->facts[]=$playerBlock->children(0)->children(1)->plaintext; //факты
                        $player->biography[]=$playerBlock->children(1); //биография
                    }
                }
                if(is_object($players->children(6))) //получение данных 6-ого игрока
                {
                    $player->nickname[]=$players->children(6)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                    $player->photoRef[]=$players->children(6)->children(0)->children(0)->children(0)->children(0)->src; //ссылка на фото игрока
                    $player->team[]=$teamName; //команда игрока
                    $player->status[]=$players->children(6)->children(1)->plaintext; //статус игрока
                    $player->role[]=$players->children(6)->children(2)->plaintext; //позиция игрока
                    $player->accessionDate[]=$players->children(6)->children(3)->plaintext; //дата присоединения к команде
                    $ref=$players->children(1)->children(0)->children(0)->href;
                    foreach($dom->find('.facts__description') as $playerBlock)
                    {
                        $player->facts[]=$playerBlock->children(0)->children(1)->plaintext; //факты
                        $player->biography[]=$playerBlock->children(1); //биография
                    }
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
        /*saveImage("", $team->logo[$i], "./images/teamLogos/".mb_convert_encoding($team->name[$i], 'cp1251', 'utf-8').".png");
        $db->setQuery("insert into teams(name, logo, appearenceDate, site, prize, description, achievement) values('".$team->name[$i]."', './images/teamLogos/".mb_convert_encoding($team->name[$i], 'cp1251', 'utf-8').".png',  
        ".$team->appearenceDate[$i].",'".$team->site[$i]."', ".$team->prize[$i].", '".$team->description[$i]."', '".$team->achievement[$i]."' )");
        $db->insert_record();*/
   /* }   
}
for($i=0; $i<count($player->photoRef); $i++)
{
    /*if($player->photoRef[$i]!=null)
    {
        $db->setQuery("select idTeam from teams where name='".$player->team[$i]."'");
        $idTeam=$db->show_record("idTeam");
        $db->setQuery("select idStatus from statuses where status='".$player->status[$i]."'");
        //saveImage("", $player->photoRef[$i], "./images/playerPhotos/".mb_convert_encoding($player->nickname[$i], 'cp1251', 'utf-8').'.png');
        $db->setQuery("insert into players(idTeam, nickname, photoRef, status, role) values(".$idTeam.", '".$player->nickname[$i]."', './images/playerPhotos/".mb_convert_encoding($player->nickname[$i], 'cp1251', 'utf-8').".png', ".$db->show_record("idStatus").", ".$player->role[$i].")");
        $db->insert_record();
    }*//*
}
$db->close_connection();
*/
echo number_format((microtime(true)-$startTime)/60, 2, ":" ,"");
?>