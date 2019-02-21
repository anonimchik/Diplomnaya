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
set_time_limit(600);
$team=new Team;
$player=new Players;
$startTime=microtime(true);
$teamName=""; //переменная для хранения информации о названии команды
$ref=""; //переменная для хранения ссылки конкретной команды
$href="";
$teamPage="";
$siteRef='https://www.cybersport.ru';
    include_once('libraries/curl_query.php');
    include_once('libraries/simplehtmldom_1_7/simple_html_dom.php');
    for($i=0; $i<2; $i++)
    {
        if($href==null)
        {
            $html=curl_get("https://www.cybersport.ru/base/teams?sort=amount&page=1&disciplines=21");
        }
        else
        {
            $html=curl_get($siteRef.$href);
        }
        echo $siteRef.$href."<br>";
        $dom=str_get_html($html);
        foreach($dom->find('.pagination__item--next') as $pagination) //получение ссылки на следующую страницу
        {
            $href=$pagination->href;
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
                $html=curl_get($siteRef.$ref);
                $dom=str_get_html($html);
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
                    $players->children(0)->outertext="";
                    if(is_object($players->children(1))) //получение данных 1-ого игрока
                    {
                        $player->nickname[]=$players->children(1)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                        $player->photoRef[]=substr($players->children(1)->children(0)->children(0)->children(0)->innertext, strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, 'https'), strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, '" ')-2-strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, 'https')); //ссылка на фото игрока
                        $player->team[]=$teamName; //команда игрока
                        $player->status[]=$players->children(1)->children(1)->plaintext; //статус игрока
                        $player->role[]=$players->children(1)->children(2)->plaintext; //позиция игрока
                        $player->accessionDate[]=$players->children(1)->children(3)->plaintext; //дата присоединения к команде
                    }
                    if(is_object($players->children(2))) //получение данных 2-ого игрока
                    {
                        $player->nickname[]=$players->children(2)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                        $player->photoRef[]=substr($players->children(2)->children(0)->children(0)->children(0)->innertext, strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, 'https'), strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, '" ')-2-strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, 'https')); //ссылка на фото игрока
                        $player->team[]=$teamName; //команда игрока
                        $player->status[]=$players->children(2)->children(1)->plaintext; //статус игрока
                        $player->role[]=$players->children(2)->children(2)->plaintext; //позиция игрока
                        $player->accessionDate[]=$players->children(2)->children(3)->plaintext; //дата присоединения к команде
                    }
                    if(is_object($players->children(3))) //получение данных 3-его игрока
                    {
                        $player->nickname[]=$players->children(3)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                        $player->photoRef[]=substr($players->children(3)->children(0)->children(0)->children(0)->innertext, strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, 'https'), strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, '" ')-2-strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, 'https')); //ссылка на фото игрока
                        $player->team[]=$teamName; //команда игрока
                        $player->status[]=$players->children(3)->children(1)->plaintext; //статус игрока
                        $player->role[]=$players->children(3)->children(2)->plaintext; //позиция игрока
                        $player->accessionDate[]=$players->children(3)->children(3)->plaintext; //дата присоединения к команде
                    }
                    if(is_object($players->children(4))) //получение данных 4-ого игрока
                    {
                        $player->nickname[]=$players->children(4)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                        $player->photoRef[]=substr($players->children(4)->children(0)->children(0)->children(0)->innertext, strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, 'https'), strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, '" ')-2-strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, 'https')); //ссылка на фото игрока
                        $player->team[]=$teamName; //команда игрока
                        $player->status[]=$players->children(4)->children(1)->plaintext; //статус игрока
                        $player->role[]=$players->children(4)->children(2)->plaintext; //позиция игрока
                        $player->accessionDate[]=$players->children(4)->children(3)->plaintext; //дата присоединения к команде
                    }
                    if(is_object($players->children(5))) //получение данных 5-ого игрока
                    {
                        $player->nickname[]=$players->children(5)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                        $player->photoRef[]=substr($players->children(5)->children(0)->children(0)->children(0)->innertext, strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, 'https'), strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, '" ')-2-strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, 'https')); //ссылка на фото игрока
                        $player->team[]=$teamName; //команда игрока
                        $player->status[]=$players->children(5)->children(1)->plaintext; //статус игрока
                        $player->role[]=$players->children(5)->children(2)->plaintext; //позиция игрока
                        $player->accessionDate[]=$players->children(5)->children(3)->plaintext; //дата присоединения к команде
                    }
                    if(is_object($players->children(6))) //получение данных 6-ого игрока
                    {
                        $player->nickname[]=$players->children(6)->children(0)->children(0)->children(1)->children(0)->plaintext; //никнейм игрока
                        $player->photoRef[]=substr($players->children(6)->children(0)->children(0)->children(0)->innertext, strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, 'https'), strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, '" ')-2-strpos($players->children(1)->children(0)->children(0)->children(0)->innertext, 'https')); //ссылка на фото игрока
                        $player->team[]=$teamName; //команда игрока
                        $player->status[]=$players->children(6)->children(1)->plaintext; //статус игрока
                        $player->role[]=$players->children(6)->children(2)->plaintext; //позиция игрока
                        $player->accessionDate[]=$players->children(6)->children(3)->plaintext; //дата присоединения к команде
                    }
                }
            }
        }
    }
    /*foreach($team->logo as $img)
    {
        saveImage($teamRef, $teamRef.$img, "./images/countryFlags/".mb_convert_encoding($img, 'cp1251', 'utf-8').".png"); //сохранение флагов 
    }*/
    echo number_format((microtime(true)-$startTime)/60, 2, ":" ,"");
?>