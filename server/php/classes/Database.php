<?php
require_once $_SERVER['DOCUMENT_ROOT'].'/.auth/valhalla/database.php';

/** handle standard database connections easily with this class */
class Database {

    /** The PDO database connection here */
    private $db = null;
    
    /** the current resutls that can be used to iterate if i so choose */
    private $current = null;
    
    /** Construct the new database instance */
    public function __construct(){
        global $database_config;
        
        try {
            $this->db = new PDO('mysql:host='.$database_config['host'].
                ';dbname='.$database_config['database'], 
                $database_config['user'], 
                $database_config['password']);
            $this->db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            echo 'Connection failed: ' . $e->getMessage();
        }
    }

    /** Destroy any references I may have created in here */
    public function __destruct(){
        $this->db = null;
        $this->current = null;
    }
    
    /** pass along a prepare request while watching for errors 
     *  @param string $string the string to prepare an SQL request for
     *  @return PDO::Statement returns a statement object for use later
     */
    public function prepare( $string ) {
        try {
            return $this->db->prepare( $string );
        } catch (PDOException $e) {
            echo 'Prepare failed: ' . $e->getMessage();
            return null;
        }
    }
    
    /** Execute a prepared statement and apply any variables we're trying
      * to do stuff with and watch for errors
      * @param PDO::Statement $stmt the statement to execute
      * @param array $args the arguments to bind to the statement
      * @return the results of the execution of the statement
      */
    public function execute( $stmt, $args ){
        try {
            return $stmt->execute( $args );
        } catch (PDOException $e) {
            echo 'Execute failed: ' . $e->getMessage();
            return null;
        }    
    }

}
?>
