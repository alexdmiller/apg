package apg.util;

import flash.display.DisplayObjectContainer;
import flash.display.DisplayObject;
import flash.geom.Matrix;

typedef Point = {
  var x : Float;
  var y : Float;
}

enum Mode {
  FREE;
  LAZY;
  SNAP;
}

class Camera {
  public var mode(default, default) : Mode;
  public var target : DisplayObject;
  public var x(getX, setX) : Float;
  public var y(getY, setY) : Float;
  public var vx(getVX, setVX) : Float;
  public var vy(getVY, setVY) : Float;
  public var angle(getAngle, setAngle) : Float;
  
  private var theta : Float;
  private var velocity : Point;
  private var position : Point;
  private var container : DisplayObjectContainer;
  private var size : Point;

  public function new(container : DisplayObjectContainer, width : Float, height : Float) {
    this.container = container;
    this.size = {x: width, y: height};
    this.velocity = {x: 0.0, y: 0.0};
    this.position = {x : 0.0, y: 0.0};
    this.mode = Mode.FREE;
    this.theta = 0;
  }
  
  public function tick(delta : Float) {
    if (target != null) {
      switch (mode) {
        case Mode.FREE:
          // do nothing
        case Mode.LAZY:
          // TODO
        case Mode.SNAP:
          setPosition(target.x, target.y);
      }
    }
  }

  /**
   *  @todo fix this transform
   **/
  public function stageToView(stageX, stageY) {
    return {x: stageX - container.x, y: stageY - container.y};
  }

  public function translate(x, y) {
    var matrix = container.transform.matrix;
    matrix.translate(x, y);
    position.x -= x;
    position.y -= y;
    container.transform.matrix = matrix;
  }

  public function setPosition(x : Float, y : Float) {
    var matrix = container.transform.matrix;
    matrix.identity();
    matrix.translate(-x, -y);
    matrix.rotate(theta);
    matrix.translate(size.x / 2, size.y / 2);
    position.x = x;
    position.y = y;
    container.transform.matrix = matrix;
  }

  private function setX(value : Float) {
    var matrix = container.transform.matrix;
    var diff = position.x - value;
    matrix.translate(diff, 0);
    container.transform.matrix = matrix;
    position.x = value;
    return value;
  }
  
  private function getX() : Float {
    return position.x;
  }

  private function setY(value : Float) { 
    var matrix = container.transform.matrix;
    var diff = position.y - value;
    matrix.translate(0, diff);
    container.transform.matrix = matrix;
    position.y = value;
    return value;
  }
  
  private function getY() : Float {
    return position.y;
  }
  
  private function getAngle() : Float {
    return theta;
  }
  
  private function setAngle(value : Float) : Float {
    var matrix = container.transform.matrix;
    matrix.identity();
    matrix.translate(-x, -y);
    matrix.rotate(value);
    matrix.translate(size.x / 2, size.y / 2);
    container.transform.matrix = matrix;
    theta = value;
    return value;
  }
  
  public function setVX(value : Float) {
    velocity.x = value;
    return value;
  }
  
  public function getVX() : Float {
    return velocity.x;
  }

  public function setVY(value : Float) {
    velocity.y = value;
    return value;
  }
  
  public function getVY() : Float {
    return velocity.y;
  }

  
  private function transform() {
    // TODO
  }
}