<?php
require_once 'classes/GoogleAuth.php';

$service = (isset($serviceType)) ? $serviceType : GoogleAuth::DEFAULT_SERVICE;
if( isset($GET['service']) ) $service = $GET['service'];

// here is the strategy
//    we're going to check the database for an access token for the service
$auth = new GoogleAuth( );

if (! isset($_GET['code'])) {
    $auth->client->setRedirectUri(GoogleAuth::redirectUrl($service));
    $auth_url = $auth->client->createAuthUrl();
    header('Location: ' . filter_var($auth_url, FILTER_SANITIZE_URL));
} else {
    $auth->saveAuthTokens( $service, GoogleAuth::DEFAULT_ACCOUNT, $auth->client->authenticate($_GET['code']) );
    
    
    
    $_SESSION['access_token'] = $auth->client->getAccessToken();
    $redirect_uri = 'http://' . $_SERVER['HTTP_HOST'] . '/';
    header('Location: ' . filter_var($redirect_uri, FILTER_SANITIZE_URL));
}
?>
