<?php

require_once $_SERVER['DOCUMENT_ROOT'].'/vendor/autoload.php';
require_once 'Database.php';


/** Authorize access to stuff using the Google API */
class GoogleAuth {

    /** constant for requesting calendar service */
    public const CALENDAR_SERVICE = "calendar";
    /** constant for requesting notes service */
    public const NOTES_SERVICE = 'notes';

    /** constant for requesting the default service */
    public const DEFAULT_SERVICE = GoogleAuth::CALENDAR_SERVICE;
    /** constant for requesting the default account */
    public const DEFAULT_ACCOUNT = 'tanner';
    
    /** constant for request the authorization request url */
    public const AUTH_URL = '/valhalla/requestAuth.php';
    
    /** constant for checking time validity */
    private const VALID_TIME = 3600; // 60 minutes

    /** private database item */
    private $data = null;
    
    /** private the google client made public */
    public $client = null;

    /** 
     * constructor builds the clients, databases and service requests as needed
     * @param $client a previously created google client if it exists
     * @param $db a previously created database object if it exists
     * @param $service the service to request the auth for
     */
    public function __construct( 
        $client = null, 
        $db = null, 
        $service = GoogleAuth::DEFAULT_SERVICE
    ){
        if( $db == NULL ){
            $this->data = new Database();
        } else {
            $this->data = $db;
        }
        
        if( $client == NULL ){
            $this->client = new Google_Client();
            $this->client->setAuthConfig(GoogleAuth::configFile($service));
            
            // TODO Update to handle different services
            $this->client->addScope(Google_Service_Calendar::CALENDAR);
            $this->client->setAccessType('offline');
        } else {
            $this->client = client;
        }
    }
    
    /**
     * Static function to generate a redirect url based on the service requested
     * @param $service the service to request the url for
     * @return string to the redirect url for the oauth
     */
    public static function redirectURL( 
        $service = GoogleAuth::DEFAULT_SERVICE
    ){
        $base = 'http://localhost/valhalla/';
        if( $service == GoogleAuth::CALENDAR_SERVICE ){
            return $base.'calendarOAuthCallback.php';
        }
    }
    
    /**
     * Static function to request the configuration file for the auth
     * @param $service the service to request the config file for
     * @return string to the json file with the client config
     */
    public static function configFile( $service = GoogleAuth::DEFAULT_SERVICE ){
        if( $service == GoogleAuth::CALENDAR_SERVICE ){
            return $_SERVER['DOCUMENT_ROOT'].'/.auth/valhalla/client_secret_137796887745-frg5n9c7ano3jphful46nfrn3ud3v712.apps.googleusercontent.com.json';
        }
    }
    
    /**
     * checks if there is an entry for our authorizations
     * @param $service service to check for an entry\
     * @param $account the account to check for an entry in database
     * @return bool true if entry exists, false otherwise
     * 
     */
    public function hasEntry( 
        $service = GoogleAuth::DEFAULT_SERVICE, 
        $account = GoogleAuth::DEFAULT_ACCOUNT 
    ){
        if( $this->data == null || $service == null ){
            return false;
        }
        
        $stmt = $this->data->prepare("SELECT * FROM `auth_blocks` WHERE service = ? AND account = ? LIMIT 1");
        
        return $this->data->execute( $stmt, array($service, $account) ) && $stmt->rowCount() > 0;
    }
    
    /**
     * save the auth tokens an a return from the google oauth
     * @param $service the service to save the auth token for
     * @param $account account to save auth token for
     * @param $accessToken the access token from google oauth
     */
    public function saveAuthTokens( 
        $service = GoogleAuth::DEFAULT_SERVICE, 
        $account = GoogleAuth::DEFAULT_ACCOUNT, 
        $accessToken 
    ) {
        $accessJSON = json_encode($accessToken);
        $this->saveAccessToken($service, $account, $accessJSON);
        $this->saveRefreshToken($service, $account, $accessJSON);
    }
    
    /**
     * Save the access token to use with each request
     * @param $service the service to save access token for
     * @param $account account tot save access token for
     * @param $accessToken access token to save for use
     */
    public function saveAccessToken( 
        $service = GoogleAuth::DEFAULT_SERVICE, 
        $account = GoogleAuth::DEFAULT_ACCOUNT, 
        $accessToken 
    ){
        if( !$this->hasEntry($service,$account) ){
            $stmt = $this->data->prepare("INSERT INTO auth_blocks (auth_json, account, service) VALUES (?, ?, ?)");
        } else {
            $stmt = $this->data->prepare("UPDATE auth_blocks SET auth_json=? WHERE account=? AND service=?");
        }
        return $this->data->execute( $stmt, array( $accessToken, $account, $service ) );
    }
    
    /**
     * Save the refresh token for later use when access expires
     * @param $service service to save token for
     * @param $account account to save token for
     * @param $accessToken the original access token with refresh token
     */
    public function saveRefreshToken( 
        $service = GoogleAuth::DEFAULT_SERVICE, 
        $account = GoogleAuth::DEFAULT_ACCOUNT, 
        $accessToken 
    ){
        $stmt = $this->data->prepare("UPDATE auth_blocks SET refresh_json=? WHERE account=? AND service=?");
        return $this->data->execute( $stmt, array( $accessToken, $account, $service ) );
    }
    
    /**
     * Load the access token for use
     * @param $service the service to load the token for
     * @param $account the account to load the token for
     * @return the json authorization to be used
     */
    public function loadAccessToken(
        $service = GoogleAuth::DEFAULT_SERVICE,
        $account = GoogleAuth::DEFAULT_ACCOUNT
    ){
        $stmt = $this->data->prepare("SELECT auth_json FROM auth_blocks WHERE account=? AND service=?");
        $result = $this->data->execute( $stmt, array( $account, $service ) );
        
        if( !$result || $stmt->rowCount() <= 0 ){
            return null;
        }
        
        $row = $stmt->fetch( PDO::FETCH_ASSOC );
        return $row['auth_json'];
        
    }
    
    /**
     * Load the refresh token so the accesstoken can be updated
     * @param $service the service to load the token for
     * @param $account the account to load the token for
     * @return the refresh token to use for refreshing the access token
     */
    public function loadRefreshToken(
        $service = GoogleAuth::DEFAULT_SERVICE,
        $account = GoogleAuth::DEFAULT_ACCOUNT
    ){
        $stmt = $this->data->prepare("SELECT refresh_json FROM auth_blocks WHERE account=? AND service=?");
        $result = $this->data->execute( $stmt, array( $account, $service ) );
        
        if( !$result || $stmt->rowCount() <= 0 ){
            return null;
        }
        
        $row = $stmt->fetch( PDO::FETCH_ASSOC );
        return json_decode($row['refresh_json'])->refresh_token;
        
    }
    
    /**
     * load the authentication into this page load so that future calls to the
     * client will be useable
     * @param string $service the service to request for e.g. 'calendar'
     * @param string $account the name of the account for auth, e.g. 'tanner'
     */
    public function loadAuth( 
        $service = GoogleAuth::DEFAULT_SERVICE, 
        $account  = GoogleAuth::DEFAULT_ACCOUNT 
    ) {
    
        $accessToken = json_decode($this->loadAccessToken($service, $account),true);
        // setAccessToken() expects json
        $refreshToken = $this->loadRefreshToken($service, $account);
        $accessToken['refresh_token'] = $refreshToken;
        $this->client->setAccessToken($accessToken);

        if ($this->client->isAccessTokenExpired()) {
            // reuse the same refresh token
            $this->client->refreshToken($this->loadRefreshToken($service, $account));
            // save the new access token (which comes without any refrsh token)
            $this->saveAccessToken($service, $account, json_encode($this->client->getAccessToken()));
        }
    }
    
    /**
     * Manages service specific requests to authorize the client
     * currently just passes responsibility to the loadAuth method
     * @todo handle the case that the auth has been revoked
     * @param string $service the service to request auth for e.g. 'calendar'
     * @param strign $account the account to request auth for e.g. 'tanner'
     */
    public function authClient( 
        $service = GoogleAuth::DEFAULT_SERVICE, 
        $account = GoogleAuth::DEFAULT_ACCOUNT 
    ){
        $this->loadAuth( $service, $account );
        
        if( $service == "calendar" ){
        
        }
    }
    
    /**
     * Checks if the we have an auth record available for this service
     * @param string $service the service to request auth for, e.g. 'calendar'
     * @param string $account the account to request auth for e.g. 'tanner'
     * @return bool true if there is an entry for this client and the request
     * has succeeded, false if there is no entry or the auth has been revoked
     */
    public function checkAuth(
        $service = GoogleAuth::DEFAULT_SERVICE, 
        $account = GoogleAuth::DEFAULT_ACCOUNT
    
    ){
        if( $this->hasEntry($service, $account) ){
            // try the auth we have
            $this->authClient( $service, $account );
            return true;
        } else {
            header('Location: ' . filter_var(GoogleAuth::AUTH_URL, FILTER_SANITIZE_URL));
            return false;
        }
    }

}
?>
