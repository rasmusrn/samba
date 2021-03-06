part of samba;

abstract class Game {
  final Renderer renderer;
  Director director;
  final LensManager lensManager = new LensManager();
  final ComponentRegistry components = new ComponentRegistry();
  final Sequencer sequencer = new Sequencer();
  num _lastTickAt = 0;
  final MeshRegistry meshes = new MeshRegistry();
  
  Game(HTML.CanvasElement canvas) : renderer = new Renderer(canvas) {
    sequencer.components = components;
    director = createDirector();
    director.game = this;
  }
  
  Director createDirector();
  
  void initialize() {
    sequencer.initialize();
    lensManager.initialize(components.lenses);
    director.initialize();
    renderer.lensManager = lensManager;
    onInitialize();
  }
  
  void onInitialize();
  
  void run() {
    loop(0);
  }
  
  void tick(num timeDelta) {
    director.update();
    sequencer.grow();
    components.update(timeDelta);
    sequencer.trim();
    renderer.draw();
  }
  
  void loop(num time) {
    var timeDelta = time - _lastTickAt;
    tick(timeDelta);
    HTML.window.animationFrame.then(loop);
    _lastTickAt = time;
  }
}
