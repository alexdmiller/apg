package apg.game;

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