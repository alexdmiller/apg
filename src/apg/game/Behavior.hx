package apg.game;

/**
 *  A component of a GameObject's behavior. Meant to be extended and added to 
 *  a GameObject.
 *  
 *  @author alexmiller@gmail.com
 **/
class Behavior extends EventEmitter {
  /**
   *  The name of the behavior's type.
   **/
  public var type(default, null) : String;
  
  /**
   *  Constructs a new Behavior.
   *  
   *  @param type The behavior's type name.
   **/
  public function new(type : String) {
    super();
    this.type = type;
  }
}