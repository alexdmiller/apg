package apg.view;

import flash.events.Event;
import flash.display.Sprite;

class ParticleEffects extends Sprite {
  private var particles : List<Particle>;
  public var gravity : Float;
  
  public function new() {
    super();
    particles = new List<Particle>();
    gravity = 0;
    addEventListener(Event.ENTER_FRAME, onEnterFrame);
  }
  
  public function burst(x : Float, y : Float, ?size : Float = 2, 
      ?color : UInt = 0x000000, intensity : Int = 10) : Void {
    for (i in 0...intensity) {
      var p : Particle = create(x, y, color);
      p.vx = Math.random() * size - size / 2;
      p.vy = Math.random() * size - size / 2;
    }
  }

  public function particleFill(x : Float, y : Float, width : Float,
      height : Float, ?color : UInt = 0x000000, ?intensity : Float = 0.01) {
    var area : Float = width * height;
    for (i in 0...cast(area * intensity, Int)) {
      var p : Particle = create(x + Math.random() * width,
          y + Math.random() * height, color);
      p.vx = Math.random() * 4 - 2;
      p.vy = Math.random() * 4 - 2;
    }
  }
  
  public function create(x, y, color) : Particle {
    var p : Particle = new Particle(x, y, color);
    addParticle(p);
    return p;
  }
  
  private function addParticle(p : Particle) : Void {
    particles.push(p);
    addChild(p);
  }
  
  private function removeParticle(p : Particle) : Void {
    removeChild(p);
    particles.remove(p);
  }
  
  private function onEnterFrame(event : Event) : Void {
    for (p in particles) {
      if (p.life == p.maxLife) {
        removeParticle(p);
      } else {
        p.vy += gravity;
        p.alpha = Math.min(p.speed(), 1);
        p.alpha = Math.min((p.maxLife - p.life) / 25.0, p.alpha);
        p.update();
      }
    }
  }
}

class Particle extends Sprite {
  public var vx : Float;
  public var vy : Float;
  public var life : Int;
  public var maxLife : Int;
  public var color : UInt;
  
  public function new(x : Float = 0, y : Float = 0, color, ?maxLife = 50) {
    super();
    this.x = x;
    this.y = y;
    this.vx = 0;
    this.vy = 0;
    this.maxLife = maxLife;
    this.color = color;
    draw();
  }

  public function speed() {
    return Math.sqrt(vx * vx + vy * vy);
  }
  
  public function update() {
    x += vx;
    y += vy;
    life++;
  }
  
  private function draw() {
    graphics.clear();
    graphics.beginFill(color);
    graphics.drawRect(0, 0, 2, 2);
    graphics.endFill();
  }
}