<?php
function open_connection()
{
    $hostname="localhost";
    $username="root";
    $password="";
    $databaseName="newdb";
    $link = mysql_connect($hostname, $username, $password) or die('Не удалось соединиться: ' . mysql_error());
    mysql_select_db($databaseName) or die('Не удалось выбрать базу данных');
}
?>