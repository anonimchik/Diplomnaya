<?php
$link;
function open_connection()
{
    global $link;
    $hostname="localhost";
    $username="root";
    $password="";
    $databaseName="newdb";
    global $link;
    $link = mysql_connect($hostname, $username, $password) or die('Не удалось соединиться: ' . mysql_error());
    mysql_select_db($databaseName) or die('Не удалось выбрать базу данных');
    if($link){echo "успешно";}
}
function close_connection()
{
    global $link; 
    mysql_close($link);
}
?>