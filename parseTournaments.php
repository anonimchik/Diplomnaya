<?php
set_time_limit(600);
include_once('libraries/curl_query.php');
include_once('libraries/simplehtmldom_1_7/simple_html_dom.php');
include_once('classes.php');
$startTime=microtime(true);
$siteRef='https://www.cybersport.ru';
$tournament=new Tournament;
for ($i=0; $i<1; $i++) 
{ 
    if($href!=null)
    {
        $html=curl_get($siteRef.$href); //получение страницы
        $dom=str_get_html($html); //формирование объекта
    }
    else
    {
        $html=curl_get($siteRef."/base/tournaments?disciplines=21&status=past"); //получение страницы
        $dom=str_get_html($html); //формирование объекта                
    }
    foreach($dom->find('.tournaments__list .revers') as $mainBlock)
    {
        $pageHref=$mainBlock->href;
        $description=$mainBlock->plaintext;
        $html=curl_get($siteRef.$pageHref);
        $dom=str_get_html($html);
        echo $siteRef.$pageHref."<br>";
        foreach($dom->find('.layer--page') as $tournamentPage)
        {
            if(is_object($tournamentPage->children(2)))
            {
                if(is_object($tournamentPage->children(2)->children(2)))
                {
                    $tournamentPage->children(2)->children(2)->children(1)->children(0)->children(1)->outertext="";
                    $tournamentPage->children(2)->children(2)->children(2)->outertext="";
                    $tournamentPage->children(2)->children(2)->children(4)->outertext="";
                }
                else
                {
                    if(is_object($tournamentPage->children(2)->children(1)->children(1)->children(0)->children(1)))
                    {
                    $tournamentPage->children(2)->children(1)->children(1)->children(0)->children(1)->children(0)->outertext="";
                    }
                    else
                    {
                        $tournamentPage->children(2)->children(1)->children(1)->outertext="";
                        $tournamentPage->children(2)->children(1)->children(3)->outertext="";
                    }
                    $tournamentPage->children(2)->children(1)->children(2)->outertext="";
                    $tournamentPage->children(2)->children(1)->children(4)->outertext="";
                }
            }
            else
            {
                if(!is_object($tournamentPage->children(1)->children(2)))
                {
                    $tournamentPage->children(1)->children(1)->children(1)->children(0)->children(1)->outertext="";
                    $tournamentPage->children(1)->children(1)->children(2)->outertext="";
                    $tournamentPage->children(1)->children(1)->children(4)->outertext="";
                }
                else
                {
                    if(is_object($tournamentPage->children(1)->children(2)->children(1)->children(0)->children(1)))
                    {
                        $tournamentPage->children(1)->children(2)->children(1)->children(0)->children(1)->outertext="";
                    }
                    else
                    {
                        $tournamentPage->children(1)->children(2)->children(1)->outertext=""; 
                        $tournamentPage->children(1)->children(2)->children(3)->outertext="";
                    }
                    $tournamentPage->children(1)->children(2)->children(2)->outertext="";
                    $tournamentPage->children(1)->children(2)->children(4)->outertext="";
                }  
            }
            //echo $tournamentPage;
            if(!is_object($tournamentPage->children(1)->children(0)->children(0)->children(0)))
            {
                $tournament->stageHref[]=$tournamentPage->children(1)->children(0)->children(0)->href;
                $tournament->stage[]=$tournamentPage->children(1)->children(0)->children(0)->plaintext;
                $tournament->stageHref[]=$tournamentPage->children(1)->children(0)->children(1)->href;
                $tournament->stage[]=$tournamentPage->children(1)->children(0)->children(1)->plaintext;
                $tournament->stageHref[]=$tournamentPage->children(1)->children(0)->children(2)->href;
                $tournament->stage[]=$tournamentPage->children(1)->children(0)->children(2)->plaintext;
            }
            else
            {
                $tournament->seria[]=preg_replace('(Серия)', '', $tournamentPage->children(1)->children(0)->children(0)->children(0)->children(0)->plaintext);
                $tournament->location[]=preg_replace('(Локация)', '', $tournamentPage->children(1)->children(0)->children(0)->children(0)->children(1)->plaintext);
                $tournament->format[]= preg_replace('(Формат)', '', $tournamentPage->children(1)->children(0)->children(0)->children(0)->children(2)->plaintext);
                $tournament->prize[]=preg_replace('(\D)', '', $tournamentPage->children(1)->children(0)->children(0)->children(0)->children(3)->plaintext);
                $datas[]=explode('-', preg_replace('(Дата проведения|\s)', '', $tournamentPage->children(1)->children(0)->children(0)->children(0)->children(4)->plaintext));
                $tournament->begDate[]=$datas[0];
                $tournament->endDate[]=$datas[1];
                $tournament->description[]=$tournamentPage->children(1)->children(0)->children(0)->children(1);
            }
        }
    }
}
?>