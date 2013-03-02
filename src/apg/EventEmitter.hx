package apg;

import flash.ui.ContextMenuItem;
import flash.events.ContextMenuEvent;

/**
 *  An object which registers event listeners. Can be used as a
 *  stand-alone event manager, or extended to give another class
 *  event capabilities.
 *  
 *  @author alexmiller@gmail.com
 **/
class EventEmitter {
  private static var tracking : Bool = false;
  private static var emitters : List<EventEmitter>;

  public static function startTracking() : Void {
    tracking = true;
    // var emitterItem : ContextMenuItem =
    //     new ContextMenuItem("Trace Emitters", true);
    // emitterItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,
    //     onTraceEmittersSelected);
    // flash.Lib.current.contextMenu.customItems.push(emitterItem);
  }

  private static function onTraceEmittersSelected(event : ContextMenuEvent) : Void {
    traceEmitters();
  }

  private static function trackEmitter(emitter : EventEmitter) : Void {
    if (emitters == null) {
      emitters = new List<EventEmitter>();
    }
    emitters.add(emitter);
  }

  public static function traceEmitters() : Void {
    var totalSum : Int = 0;
    for (emitter in emitters) {
      var totalFunctions : Int = 0;
      var emitterList : String = "";
      for (event in emitter.listeners.keys()) {
        var listenersArray = emitter.listeners.get(event);
        emitterList += " " + event;
        if (listenersArray != null) {
          totalFunctions += listenersArray.length;
        }
      }
      totalSum += totalFunctions;
      if (totalFunctions > 0) {
        trace(emitter + ": " + totalFunctions + ", " + emitterList);
      }
    }
    trace(totalSum + " listener functions registered.");
    trace(emitters.length + " emitters created total.");
  }

  /**
   *  A hash from event names (Strings) to lists of event handler
   *  functions.
   *  
   *  @private
   **/
  private var listeners : Hash<List<Dynamic -> Void>>;
  
  /**
   *  Constructs a new EventEmitter. Initially, the EventEmitter has no
   *  event listeners registered.
   **/
  public function new() {
    if (EventEmitter.tracking) {
      EventEmitter.trackEmitter(this);
    }
    listeners = new Hash<List<Dynamic -> Void>>();
  }
  
  /**
   *  Constructs a list for storing event handler functions for the passed
   *  event name.
   *  
   *  @param 
   **/
  private function createListenerList(event : String) {
    if (!listensFor(event)) {
      var list = new List<Dynamic -> Void>();
      listeners.set(event, list);
    }
  }
  
  /**
   *  Registers an event listener for the passed event name. When a call
   *  to dispatch is made for the passed event, the event handler function
   *  will be called.
   *  
   *  @param event The name of the event to listen for.
   *  @param fn An event listener function. Will be called when event is dispatched.
   **/
  public function on(event : String, fn : Dynamic -> Void) {
    createListenerList(event);
    listeners.get(event).add(fn);
  }
  
  /**
   *  Removes an event handler function from the passed event. Other listeners
   *  for that event will still persist.
   *  
   *  @param event The name of the event to stop listening for.
   *  @param fn The event listener to remove for the passed event.
   **/
  public function off(event : String, fn : Dynamic -> Void) {
    var list = listeners.get(event);
    if (list != null) {
      list.remove(fn);
    }
  }
  
  /**
   *  Removes all event listeners for the passed event name.
   *  
   *  @param event The event name to stop listening for.
   **/
  public function allOff(event : String) {
    listeners.get(event).clear();
    listeners.set(event, null);
  }

  /**
   *  Removes all event listeners for all events.
   **/
  public function dropListeners() {
    for (event in listeners.keys()) {
      allOff(event);
    }
  }
  
  /**
   *  Returns true if there are event handlers registered for the passed
   *  event string, and false otherwise.
   *  
   *  @param event The name of the event to check.
   *  @return True if the object listens for the event.
   **/
  public function listensFor(event : String) {
    return listeners.exists(event) && listeners.get(event) != null && 
        listeners.get(event).length != 0;
  }
  
  /**
   *  Calls all functions which have been registered to listen for the
   *  passed event. An optional parameter object is passed as an argument
   *  to the event handlers.
   *  
   *  @param event The name of the event to dispatch.
   *  @param params Optional object of parameters which is passed to all event
   *  listener functions.
   **/
  public function dispatch(event : String, ?params : Dynamic = null) {
    if (params == null) {
      params = {dispatcher: this};
    } else {
      params.dispatcher = this;
    }
    if (listensFor(event)) {
      for (fun in listeners.get(event)) {
        params.f = fun;
        fun(params);
      }  
    }
  }
}