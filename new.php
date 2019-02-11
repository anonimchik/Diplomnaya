<?php
class Team
{
    var $name;
    var $place;
    var $prize; 
}
$team=new Team;
$teamName=""; //переменная для хранения информации о названии команды
$ref=""; //переменная для хранения ссылки конкретной команды
$teamRef='https://www.cybersport.ru';
    include_once('libraries/curl_query.php');
    include_once('libraries/simplehtmldom_1_7/simple_html_dom.php');
    $html=curl_get("https://www.cybersport.ru/base/teams?sort=amount&page=1&disciplines=21");
    $dom=str_get_html($html);
    foreach ($dom->find('#active tr') as $teamTable){
        if($teamTable->children(1)->plaintext!="Команда"){
            $teamName=$teamTable->children(1); //название команды
            $ref=substr($teamTable->children(1)->innertext, strpos($teamTable->children(1)->innertext, '"')+1, strpos($teamTable->children(1)->innertext, '" ')-2-strpos($teamTable->children(1)->innertext, '="')); //ссылка на страницу команды
            //echo substr($teamTable->children(1)->innertext, strrpos($teamTable->children(1)->innertext, "https"), strrpos($teamTable->children(1)->innertext, '")')-strrpos($teamTable->children(1)->innertext, "https"))."<br>"; //ссылка на лого команды
        }
        if($teamTable->children(3)->plaintext!="Сумма призовых"){$team->prize[]=$teamTable->children(3);} //сумма призовых
        if($ref!=null)
        {
            $html=curl_get($teamRef.$ref);
            $dom=str_get_html($html);
            echo $teamRef.$ref."<br>";
        }
    }
?>