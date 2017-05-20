<?php


$handle = popen('date +%Z','r');
$systemTimeZone = fread($handle, 3);
pclose($handle);
date_default_timezone_set($systemTimeZone);
echo date('c',strtotime('1/1/2017'));
?>
