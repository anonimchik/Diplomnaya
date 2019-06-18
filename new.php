<?php

set_time_limit(1000);
include_once('libraries/curl_query.php');
include_once('libraries/simplehtmldom_1_7/simple_html_dom.php');
include_once('classes.php');
$team=new Team;
$player=new Players;
$db=new Database('localhost', 'root', '', 'course_database');
$match=new Match;
$tournament=new Tournament;
/*$montName=array("Января","Февраля","Марта","Апреля","Мая","Июня","Июля","Августа","Сентября","Октября","Ноября","Декабря");
for($i=0; $i<count($datetime)-1; $i++)//массив дат
{
    $datetime[$i]=$datetime[$i]->plaintext;
    $date=new DateTime($datetime[$i]);
    $date->add(new DateInterval("PT3H"));
    $date=date_format($date, "d n Y H:i");
    $month=explode(" ", $date);
    $month[1]=$montName[$month[1]-1];
    $object->date[$i]=implode($month, ' ');
}*/
$startTime=microtime(true);
$teamName=""; //переменная для хранения информации о названии команды
$ref=""; //переменная для хранения ссылки конкретной команды
$teamPage="";
$event="";
$siteRef='https://ggscore.com';

for($i=0; $i<1; $i++) //передвижение по страницам
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
        $tournament->miniLogo[]=$match_table->children(1)->plaintext."|".$match_table->children(0)->children(0)->children(0)->src."<br>";
        foreach ($dom->find(".t-top") as $main_block) 
        {    
            if(!is_object($main_block->children(3))) // турнир ожидается
            {
                $tournament->seria[]=$main_block->children(2)->children(0)->children(0)->children(0)->children(1)->children(1)->children(0)->children(2)->children(1)->plaintext;
                $tournament->logo[]=$main_block->children(2)->children(0)->children(0)->children(0)->children(0)->children(0)->src;
                $tournament->alt[]=preg_replace("( logo)", "", $main_block->children(2)->children(0)->children(0)->children(0)->children(0)->children(0)->getAttribute("alt"));
                $tournament->event[]=$event=$main_block->children(2)->children(0)->children(0)->children(0)->children(1)->children(0)->plaintext;
                $tournament->description[]=$main_block->children(2)->children(0)->children(0)->children(0)->children(1)->children(2)->plaintext;
                $tournament->begDate[]=$main_block->children(2)->children(0)->children(0)->children(0)->children(1)->children(1)->children(0)->children(0)->children(1)->plaintext; 
                $tournament->prize[]=preg_replace('(\$ )', "", $main_block->children(2)->children(0)->children(0)->children(0)->children(1)->children(1)->children(0)->children(1)->children(1)->plaintext);   
            }
            else //турнир прошел или длится
            {
                if(is_object($main_block->children(3)->children(0)->children(0)->children(0)->children(1)->children(1)->children(0)->children(2)))
                {
                   $tournament->seria[]=$main_block->children(3)->children(0)->children(0)->children(0)->children(1)->children(1)->children(0)->children(2)->children(1)->plaintext;
                }
                $tournament->logo[]=$main_block->children(3)->children(0)->children(0)->children(0)->children(0)->children(0)->src;
                $tournament->alt[]=preg_replace("( logo)", "", $main_block->children(3)->children(0)->children(0)->children(0)->children(0)->children(0)->getAttribute("alt"));
                $tournament->event[]=$event=$main_block->children(3)->children(0)->children(0)->children(0)->children(1)->children(0)->plaintext;
                $tournament->description[]=$main_block->children(3)->children(0)->children(0)->children(0)->children(1)->children(2)->plaintext;
                $tournament->begDate[]=$main_block->children(3)->children(0)->children(0)->children(0)->children(1)->children(1)->children(0)->children(0)->children(1)->plaintext; 
                $tournament->prize[]=preg_replace('(\$ )', "", $main_block->children(3)->children(0)->children(0)->children(0)->children(1)->children(1)->children(0)->children(1)->children(1)->plaintext);
                foreach($dom->find('div.tb') as $team_card)
                {
                    if(!is_object($team_card->children(0)->children(0)))
                    {
                        $html=curl_get($siteRef.$team_card->children(0)->href);
                        $dom1=str_get_html($html);
                        foreach($dom1->find(".pAvaBg") as $teamBlock)
                        {
                            $team->logo[]=$teamBlock->children(0)->children(0)->src;
                            $team->name[]=$teamName=$teamBlock->children(1)->children(0)->children(0)->plaintext;
                            $team->countryFlag[]=$teamBlock->children(1)->children(1)->children(0)->children(1)->children(0)->src;
                            $team->country[]=$teamBlock->children(1)->children(1)->children(0)->children(1)->plaintext;
                            $team->prize[]=$teamBlock->children(1)->children(1)->children(7)->children(1)->children(1)->plaintext;
                        }
                        $tournament->qualification[]=$event."|".$team_card->children(1)->children(2)->plaintext."|".$teamName;
                        $tournament->team[]=$event."|".$teamName;
                        if(is_object($team_card->children(1)->children(1)))
                        {
                            for($i=0; $i<5; $i++)
                            {
                                if(is_object($team_card->children(1)->children(1)->children(0)->children(0)))
                                {
                                    $player->position[]=$team_card->children(1)->children(1)->children(0)->children(0)->children(0)->plaintext;
                                    $html=curl_get($siteRef.'/ru/dota-2/player/'.$team_card->children(1)->children(1)->children(0)->children($i)->children(1)->children(1)->plaintext);
                                    $dom=str_get_html($html);
                                    if(is_object($dom))
                                    {
                                        foreach($dom->find('.pAvaBg') as $player_card)
                                        {
                                            if(is_object($player_card->children(2)) and is_object($player_card->children(1)->children(2)))
                                            {
                                                $player->photoRef[]=$player_card->children(0)->children(0)->src;
                                                $player->nickname[]=$player_card->children(1)->children(1)->plaintext;
                                                $player->name[]=$player_card->children(1)->children(2)->children(0)->children(1)->plaintext;
                                                $player->age[]=preg_replace('( лет|год|года)', '', $player_card->children(1)->children(2)->children(1)->children(1))->plaintext;
                                                $player->country[]=$player_card->children(1)->children(2)->children(2)->children(1)->plaintext;
                                                $player->countryFlag[]=$player_card->children(1)->children(2)->children(2)->children(1)->children(0)->src;
                                                $player->team[]=$teamName;
                                                $player->role[]=$player_card->children(1)->children(2)->children(4)->children(1)->plaintext;
                                                $player->line[]=$player_card->children(1)->children(2)->children(5)->children(1)->plaintext;
                                                $player->prize[]=$player_card->children(1)->children(2)->children(7)->children(1)->plaintext;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }                    
                }
            } 
            
        }
        
    }    
}
$db->setDbSettings("localhost", "root", "", "course_database");
$db->open_connection();
echo number_format((microtime(true)-$startTime)/60, 2, ":" ,"");
?>
