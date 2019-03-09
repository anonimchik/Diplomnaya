<?php
set_time_limit(600);
include_once('libraries/curl_query.php');
include_once('libraries/simplehtmldom_1_7/simple_html_dom.php');
include_once('classes.php');
$startTime=microtime(true);
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
        $html=curl_get($siteRef."/base/tournaments?disciplines=21&status=past"); //получение страницы
        $dom=str_get_html($html); //формирование объекта
    }
    foreach($dom->find('.tournaments__list .revers') as $mainBlock)
    {
        //$mainBlock->children(0)->outertext="";
        echo $mainBlock->href."<br>";
        echo $mainBlock->plaintext."<br>";
    }
}
?>