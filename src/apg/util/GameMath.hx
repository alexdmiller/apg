package apg.util;

class GameMath {
  /**
   * Returns the euclidean distance between the points (x1, y1) and (x2, y2).
   */
  public static function distance(x1 : Float, y1 : Float, x2 : Float,
      y2 : Float) : Float {
    var dx = x1 - x2;
    var dy = y1 - y2;
    return Math.sqrt(dx * dx + dy * dy);
  }

  /**
   * Returns the angle between the points (x1, y1) and (x2, y2).
   */
  public static function angle(x1 : Float, y1 : Float, x2 : Float,
      y2 : Float) : Float {
    var dx = x1 - x2;
    var dy = y1 - y2;
    return Math.atan2(dy, dx);
  }
}