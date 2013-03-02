package apg.game;

/**
 *  Implement this class to create a factory. GameBoard uses a factory to
 *  build objects.
 */
interface GameObjectFactory {
  public function create(options : Dynamic) : GameObject;
}