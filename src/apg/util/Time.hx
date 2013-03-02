package apg.util;

import haxe.Timer;

class Time {
  public static function wait(time : Int, fun : Void -> Void) : Timer {
    var t : Timer = new Timer(time);
    t.run = function() {
      fun();
      t.stop();
    }
    return t;
  }
}