package apg.game;

/**
 *  Implement this interface to define a new physical model. For example, if you
 *  wanted to use a physics engine with APG, you can implement a class which
 *  wraps around the physics engine body and implements this interface. Then
 *  the physics engine can be integrated with the APG GameObjects.
 */
interface PhysicalModel {
  public function getX() : Float;
  public function setX(value : Float) : Float;
  public function getY() : Float ;
  public function setY(value : Float) : Float;
  public function getVX() : Float;
  public function setVX(value : Float) : Float;
  public function getVY() : Float;
  public function setVY(value : Float) : Float;
  public function getAngle() : Float;
  public function setAngle(value : Float) : Float;
}