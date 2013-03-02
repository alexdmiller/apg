package apg.game;

/**
 *  <p>A GameObject is the building block of a game. It combines the state and
 *  behavior of a GameObject. Certain pieces of state are baked in, such as
 *  the id, position, velocity and angle of the object.</p>
 *  
 *  <p>If you wish to extend the functionality of the GameObject, do not extend
 *  it with a new class. Instead, the behavior and state of the object can
 *  be modified dynamically. Extending the Behavior class with your own custom
 *  behaviors and then adding them to a GameObject allows you to define new
 *  behavior. Behaviors receive all events dispatched to the GameObject.</p>
 *  
 *  @author alexmiller@gmail.com
 **/
class GameObject extends EventEmitter {
  /**
   *  Unique identification string for the GameObject.
   **/
  public var id(default, null) : String;
  
  /**
   *  The name of the GameObject's type.
   **/
  public var type(default, null) : String;
  
  /**
   *  The x component of the object's position.
   **/
  public var x(getX, setX) : Float;
  
  /**
   *  The y component of the object's position.
   **/
  public var y(getY, setY) : Float;
  
  /**
   *  The x component of the object's velocity.
   **/
  public var vx(getVX, setVX) : Float;
  
  /**
   *  The y component of the object's velocity.
   **/
  public var vy(getVY, setVY) : Float;
  
  /**
   *  The object's angle in radians. 
   **/
  public var angle(getAngle, setAngle) : Float;
  
  public var board(default, default) : GameBoard;
  
  /**
   *  Indicates whether or not the object is dead or not. This can have various
   *  meanings depending on the semantics of your game, but it could be used as
   *  a clue to the GameBoard to clean up the object.
   **/
  public var dead : Bool;

  /**
   *  Contains dynamic attributes of the object.
   **/
  private var attributes : Dynamic;
  
  /**
   *  Contains behavior components.
   **/
  private var behaviors : List<Behavior>;

  /**
   *  The GameObject's underlying physical model.
   **/
  private var model : PhysicalModel;
  
  /**
   *  Constructs a new GameObject. Initially, the GameObject has no attributes
   *  or behaviors. It's physical model is initialized to have no velocity.
   *  
   *  @param type The type name of the object
   *  @param id The object's unique ID
   **/
  public function new(type, id) {
    super();
    this.type = type;
    this.id = id;
    attributes = {};
    behaviors = new List<Behavior>();
    model = new SimplePhysicalModel();
  }

  public function clean() {
    dead = true;
    board = null;
    for (behavior in behaviors) {
      behavior.dropListeners();
    }
    dropListeners();
    model = null;
    behaviors.clear();
  }
  
  /**
   *  Adds the passed behavior to the GameObject. All events dispatched to the 
   *  GameObject will also be sent to the behavior. Dispatches an <code>added</code>
   *  event to the passed behavior.
   *  
   *  @param behavior Behavior to add
   *  @param dispatchEvent If true, then the <code>added</code> event will be dispatched to the behavior
   **/
  public function addBehavior(behavior : Behavior, ?dispatchEvent = true) : Void {
    behaviors.add(behavior);
    if (dispatchEvent) {
      behavior.dispatch('added', {object: this});
    }
  }
  
  /**
   *  Removes the passed behavior from the GameObject. The <code>removed</code> event
   *  event will be dispatched to the behavior after it has been removed.
   *  
   *  @param behavior Behavior to remove
   **/
  public function removeBehavior(behavior : Behavior) : Void {
    behaviors.remove(behavior);
    behavior.dispatch('removed', {object: this});
  }

  /**
   * Tests to see if game object contains the passed behavior.
   *
   * @param behavior Behavior to search for
   * @return True if the behavior is contained by the game object, false otherwise.
   */
  public function hasBehavior(behavior : Behavior) : Bool {
    for (b in behaviors) {
      if (b == behavior) {
        return true;
      }
    }
    return false;
  }

  /**
   * Tests to see if game object contains a behavior of the passed type. 
   *
   * @param type The behavior type to search for
   * @return True if a behavior of the passed type is contained by the game object,
   *  false otherwise.
   */
  public function hasBehaviorByType(type : String) : Bool {
    for (behavior in behaviors) {
      if (behavior.type == type) {
        return true;
      }
    }
    return false;
  }
  
  /**
   *  Sets the passed attribute to the passed value. Dispatches the <code>attribute_set</code>
   *  event on the GameObject.
   *  
   *  @param attribute Name of the attribute to set
   *  @param value Value to set the attribute to
   **/
  public function setAttribute(attr : String, value : Dynamic) {
    Reflect.setField(attributes, attr, value);
    dispatch('attribute_set', {attr: attr, value: value});
  }
  
  /**
   *  Returns the value of the attribute passed. Returns null if that attribute
   *  has not been set.
   *  
   *  @param attribute The name of the attribute to retrieve.
   *  @return Value of the attribute or null
   **/
  public function getAttribute(attr : String) : Dynamic {
    return Reflect.field(attributes, attr);
  }
  
  public function hasAttribute(attr : String) : Dynamic {
    return Reflect.hasField(attributes, attr);
  }
  
  /**
   *  Returns a Dynamic object which contains just the state of the GameObject.
   *  Behaviors are translated into behavior names. Perfect for serializing and
   *  sending across the network.
   *  
   *  @return A Dynamic object representation of the GameObject.
   **/
  public function export() : Dynamic {
    var behaviorNames = [];
    for (behavior in behaviors) {
      behaviorNames.push(behavior.type);
    }
    return {
      type: type,
      id: id, 
      x: this.x, y: this.y,
      vx: this.vx, vy: this.vy,
      angle: this.angle,
      behaviors: behaviorNames, 
      attributes: attributes
    };
  }
  
  /**
   *  Dispatches the passed event to the GameObject, and all of the behaviors
   *  currently attached to the GameObject. Each behavior will receive a reference
   *  to the GameObject in the data object passed as a second parameter.
   *  
   *  @param name Name of the event to pass
   *  @param data Data associated with event 
   **/
  override public function dispatch(event : String, ?data : Dynamic = null) {
    super.dispatch(event, data);
    if (data == null) {
      data = {object: this};
    } else {
      data.object = this;
    }
    for (behavior in behaviors) {
      behavior.dispatch(event, data);
    }
  }
  
  /**
   *  Marks a GameObject as dead by setting the dead field to true. Dispatches
   *  a <code>dead</code> event.
   **/
  public function destroy() {
    dead = true;
    dispatch('dead');
  }
  
  private function getX() : Float {
    return model.getX();
  }
  
  private function setX(value : Float) : Float {
    return model.setX(value);
  }
  
  private function getY() : Float {
    return model.getY();
  }
  
  private function setY(value : Float) : Float {
    return model.setY(value);
  }
  
  private function getVX() : Float {
    return model.getVX();
  }
  
  private function setVX(value : Float) : Float {
    return model.setVX(value);
  }
  
  private function getVY() : Float {
    return model.getVY();
  }
  
  private function setVY(value : Float) : Float {
    return model.setVY(value);
  }
  
  private function getAngle() : Float {
    return model.getAngle();
  }
  
  private function setAngle(value : Float) : Float {
    return model.setAngle(value);
  }
}