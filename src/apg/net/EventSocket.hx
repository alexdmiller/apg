package apg.net;

/**
 *  Interface that defines a simple Socket abstraction. Appropriate for
 *  use in both server and client side code.
 *  
 *  Author: Alex Miller 
 */
interface EventSocket {
  public var debug(default, default) : Bool;
  
  public function connect(host : String, port : Int) : Void;
  public function disconnect() : Void;
  public function send(message : String, ?data : Dynamic = null) : Void;
  public function on(type : String, fn : Dynamic -> Void) : Void;
  public function off(type : String, fn : Dynamic -> Void) : Void;
}