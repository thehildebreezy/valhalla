<?php
require_once 'classes/GoogleAuth.php';

$service = GoogleAuth::DEFAULT_SERVICE;
if( isset($GET['service']) ) $service = $GET['service'];

// here is the strategy
//    we're going to check the database for an access token for the service
$auth = new GoogleAuth( );


if( $auth->hasEntry($service) ){
    // try the auth we have
    $auth->authClient( $service );
    
    echo 'authorized';
} else {
    // request a new auth
    $auth->client->setRedirectUri(GoogleAuth::redirectUrl($service));
    $auth_url = $auth->client->createAuthUrl();
    header('Location: ' . filter_var($auth_url, FILTER_SANITIZE_URL));
}

