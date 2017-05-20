<?php

require_once 'GoogleAuth.php';
require_once 'Database.php';

/** Request events for the authorized user */
class Events {

    /** The private database to reference or save archived events */
    private $db = null;

    /** The private auth object that holdes the client to get our service */
    private $auth = null;
    
    /** The google service object for getting the calendar events */
    private $service = null;
    
    public const TZ_DEFAULT = "Europe/Berlin";

    /** Consructs a new instance of the events class for referencing
      * @param Database $db provide a database object already created for use
      * @param GoogleAuth $auth provide an auth object already created for use
      */
    public function __construct(  
        $db = null,
        $auth = null
    ){
        if( $db == null ){
            $this->db = new Database();
        } else {
            $this->db = $db;
        }
        
        if( $auth == null ){
            $this->auth = new GoogleAuth();
        } else {
            $this->auth = $auth;
        }
        
        $this->service = new Google_Service_Calendar($this->auth->client);
    }

    /** Get all event entries for a certain month and year and return the 
      * Google Services generated object from their api
      * @param mixed $month string or integer, as long as its a number of the
      *                     month being requested (e.g. January would be 1)
      * @param mixed $year string or integer, as long as its a number of the
      *                    year being requested (e.g. 2018)
      * @return GoogleCollection returns a collection of events for the month
      *         the results may be iterated over using for each
      */
    public function getMonth( $month, $year ){
        
        $calendarId = 'primary';
        $dateStart = date('c',strtotime($month.'/'.$month.'/'.$year));
        $dateEnd = date('c',strtotime($dateStart . ' +1 month'));
        
        
        $optParams = array(
            'orderBy' => 'startTime',
            'singleEvents'=>TRUE,
            'timeMin'=> $dateStart,
            'timeMax'=> $dateEnd
        );
        $results = $this->service->events->listEvents($calendarId, $optParams);
        
        return $results->getItems();
        
        // TODO take the result items and filter out all the nonsense I don't
        // really care about
        
        /*
        if (count($results->getItems()) == 0) {
          print "No upcoming events found.\n";
        } else {
            echo json_encode( $results->getItems() );
            
          print "Upcoming events:\n";
          foreach ($results->getItems() as $event) {
            $start = $event->start->dateTime;
            if (empty($start)) {
              $start = $event->start->date;
            }
            printf("%s (%s)\n", $event->getSummary(), $start);
          }
          */
    }
    
    public static function set_timezone( $timezone = Events::TZ_DEFAULT )
    {
        date_default_timezone_set($timezone);
    }

}

?>
