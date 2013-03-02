package apg.view;

import flash.display.Sprite;
import apg.EventEmitter;

class EventSprite extends Sprite {
  public var emitter(default, default) : EventEmitter;
  
  public function new() {
    super();
    emitter = new EventEmitter();
  }
}