<?php 

require_once 'classes/Database.php';
require_once 'classes/GoogleAuth.php';
require_once 'classes/Events.php';

$db = new Database();
$gAuth = new GoogleAuth( null, $db );

$valid = $gAuth->checkAuth();

if( !$valid ) die;

$events = new Events( $db, $gAuth );

$events->getMonth(2,2018);

?>
