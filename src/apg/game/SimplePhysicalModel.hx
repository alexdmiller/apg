package apg.game;

/**
 * @todo make this conform to haxe standards
 */  
class SimplePhysicalModel implements PhysicalModel {
  private var _x : Float;
  private var _y : Float;
  private var _vx : Float;
  private var _vy : Float;
  private var _angle : Float;
  
  public function new() {
    setX(0);
    setY(0);
    setVX(0);
    setVY(0);
    setAngle(0);
  }
  
  /**
   *  Test method comment.
   **/
  public function getX() : Float {
    return _x;
  }
  
  public function setX(value : Float) : Float {
    _x = value;
    return _x;
  }
  
  public function getY() : Float  {
    return _y;
  }
  
  public function setY(value : Float) : Float  {
    _y = value;
    return _y;
  }
  
  public function getVX() : Float  {
    return _vx;
  }
  
  public function setVX(value : Float) : Float  {
    _vx = value;
    return _vx;
  }
  
  public function getVY() : Float  {
    return _vy;
  }
  
  public function setVY(value : Float) : Float  {
    _vy = value;
    return _vy;
  }
  
  public function getAngle() : Float  {
    return _angle;
  }
  
  public function setAngle(value : Float) : Float  {
    _angle = value;
    return _angle;
  }
}