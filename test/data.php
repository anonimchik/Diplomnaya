<?php
$query="select * from prognoz";
$con_str=mysql_connect('localhost', 'root', '');
mysql_select_db('newdb',$con_str);
$result=mysql_query($query);
echo '<table class="tablestyle" border="1" cellspacing="0"><tr><th>User</th><th>Team</th><th>Match</th><tr>';
  while($row = mysql_fetch_array($result))
  {
    $idUser=$row['idUser'];
    $login=$row['idTeam'];
    $password=$row['idMatch'];
    echo"<tr><td>$idUser</td><td>$login</td><td>$password</td></tr>";
  }
echo '</table>';
mysql_close($con_str);
?>