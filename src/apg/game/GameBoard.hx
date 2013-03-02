package apg.game;

/**
 *  <p>A GameBoard captures the "physical" state and behavior of a game. This
 *  consists of maintaining a list of all the GameObjects currently in the
 *  game. It is the core piece of the game model, tying together a collection
 *  of GameObjects and dispatching events to them.</p>
 *  
 *  <p>This class can be used as-is, or extended if you need specific functionality
 *  for your game.</p>
 *  
 *  @author alexmiller@gmail.com
 **/
class GameBoard extends EventEmitter {
  /**
   *  The width of the GameBoard in pixels.
   **/
  public var width(default, null) : Float;
  
  /**
   *  The height of the GameBoard in pixels.
   **/
  public var height(default, null) : Float;

  public var name(default, null) : String;
  
  /**
   *  Used to construct GameObjects for the GameBoard.
   **/
  private var factory : GameObjectFactory;
  
  /**
   *  List of GameObjects contained within the GameBoard.
   **/
  private var gameObjects(default, null) : Hash<GameObject>;
  
  /**
   *  Constructs a new GameBoard. Initially, the GameBoard has no GameObjects
   *  stored within it. The passed GameObjectFactory will be used to construct
   *  GameObjects on subsequent calls to <code>createObject()</code>.
   *  
   *  @param width The width, in pixels, of the GameBoard
   *  @param height The height, in pixels, of the GameBoard
   *  @param factory A <code>GameObjectFactory</code> used to create new GameObjects
   **/
  public function new(width : Float, height : Float, factory : GameObjectFactory, ?name : String = null) {
    super();
    gameObjects = new Hash<GameObject>();
		this.width = width;
		this.height = height;
		this.factory = factory;
    this.name = name;
  }

  /**
   *  <p>Creates a new GameObject of the specified type. The GameObject is
   *  composed of behaviors associated with the passed types. The behaviors
   *  for each GameObject are defined in the "objectDefinitions" field. The GameObject
   *  is added to the GameBoard after it is created. </p>
   *  
   *  <p>Dispatches the <code>object_added</code> event after the object is created.</p>
   *  
   *  @param options A dynamic options object which is passed to the object factory.
   *  @return Returns the created object. It is also added to the GameBoard.
   **/
  public function createObject(options : Dynamic) : GameObject {
    if (options.id == null) {
      options.id = getNewObjectID();
    }
    var obj = factory.create(options);
    gameObjects.set(obj.id, obj);
    dispatch('object_added', {object: obj});
    return obj;
  }
  
  /**
   *  <p>Removes the GameObject with the passed id from the GameBoard. Returns the
   *  removed GameObject. If no GameObject with the passed id is found, returns
   *  null.</p>
   *  
   *  <p>Dispatches the <code>object_removed</code> event after the object is removed.</p>
   *  
   *  @param id The id of the object to remove.
   *  @return Returns the object that is removed if it is found.
   **/
  public function removeObject(id : String) : GameObject {
    var obj = getObject(id);
    if (obj != null) {
      gameObjects.remove(id);
      dispatch('object_removed', {object: obj});
    }
    obj.dropListeners();
    return obj;
  }

  /**
   *  Returns the GameObject with the passed id. Returns null if no GameObject
   *  is found with the passed id.
   *  
   *  @param id ID of the object to look for.
   *  @return GameObject with the passed ID.
   **/
  public function getObject(id : String) : GameObject {
    return gameObjects.get(id);
  }
  
  /**
   *  Returns the first object of the passed type.
   *  TODO: Return an array of objects.
   **/
  public function getObjectByType(type : String) : GameObject {
    for (obj in gameObjects) {
      if (obj.type == type){
        return obj;
      }
    }
    return null;
  }
  
  /**
   * Collects all of the objects that have the passed attribute name mapped to
   * the passed attribute value.
   */
  public function getObjectsWithAttribute(attributeName : String,
      attributeValue : Dynamic) : Array<GameObject> {
    var results = [];
    for (obj in gameObjects) {
      if (obj.hasAttribute(attributeName) && obj.getAttribute(attributeName) ==
          attributeValue) {
        results.push(obj);
      }
    }
    return results;
  }

  /**
   *  Returns a string id which does not collide with the id's of any GameObject
   *  currently added to the GameBoard.
   *  
   *  @todo is there a better alg for this?
   *  @return New ID for an Object. This ID does not collide with any
   *          other GameObject's ID.
   **/
  public function getNewObjectID() {
    var id = Std.random(10000) + "";
    while (gameObjects.exists(id)) {
      id = Std.random(10000) + "";
    }
    return id;
  }
  
  /**
   *  Returns an iterator over the GameObjects contained within the GameBoard.
   *  
   *  @return An iterator over the GameObjects contained within the GameBoard
   **/
  public function iterator() {
    return gameObjects.iterator();
  }
  
  /**
   *  Returns a dynamic object representation of the state of the GameBoard.
   *  @todo can this be replaced by serialize?
   *  
   *  @return Dynamic representation of the state of the GameBoard.
   **/
  public function export() {
    var exp = {
      width: width,
      height: height,
      gameObjects: []
    }
    for (obj in gameObjects) {
      exp.gameObjects.push(obj.export());
    }
    return exp;
  }
  
  /**
   *  Dispatches an event to all objects within the GameBoard. Also dispatches
   *  the event to the GameBoard itself. A reference to the board is added to
   *  the event information that is passed to each GameObject. This allows
   *  GameObjects to access the board which dispatches the event.
   *  
   *  @param event Name of the event to dispatch.
   *  @data data Optional data to send along with the event.
   **/
  public function dispatchToObjects(event : String, ?data : Dynamic = null) {
    dispatch(event, data);
    if (data == null) {
      data = {board: this}
    } else {
      data.board = this;
    }
    for (object in gameObjects) {
      object.dispatch(event, data);
    }
  }

  /**
   *  Removes all event listeners from the GameBoard, and removes all event
   *  listeners from child GameObjects.
   */
  public function clean() {
    dropListeners();
    for (obj in gameObjects) {
      obj.clean();
    }
  }
}