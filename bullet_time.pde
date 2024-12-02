/**
 Bullet Time
 Made for Assignment 4 - Object Oriented Game
 Max Gelinas
 991772519
 */

PApplet mainApplet = this;

// time variables ///////////////////////
// time since game start
float time;

// time since last frame
float deltaTime;

// last frame millis
long lastMillis = millis();
////////////////////////////////////////

// constants
float DEG2RAD = 0.017453292, RAD2DEG = 57.29578;

public float UNITS_TO_PIXELS = 500;
public int WIDTH = 860, HALF_WIDTH = 430;

boolean DRAW_DEBUG_AXES = false,
  DRAW_HITSPHERES = false;


// useful vectors, such as (0, 0, 0), (1, 1, 1), and all the cardinal world directions
public PVector zero = new PVector(0, 0, 0),
  one = new PVector(1, 1, 1),
  WORLD_RIGHT = new PVector(1, 0, 0),
  WORLD_UP = new PVector(0, 1, 0),
  WORLD_FORWARD = new PVector(0, 0, 1),
  WORLD_LEFT = new PVector(-1, 0, 0),
  WORLD_DOWN = new PVector(0, -1, 0),
  WORLD_BACKWARD = new PVector(0, 0, -1);

// the base quaternion, equivalent to an Euler rotation of (0, 0, 0)
Quaternion identity = new Quaternion(0, zero);

///// camera variables
// the camera's field of view (90 degrees)
public float camFOV = 1.0 / tan(90 * DEG2RAD / 2.0);

// the camera itself
public Camera mainCamera, overlayCamera;

public Entity player;

// list of updateables that will be iterated over each iteration of the game loop
GatedArrayList<Updateable> updateables, p3dObjects;

// test
RenderObject parent;

// test
RenderObject hand;

void setup() {
  size(860, 860);

  // initialize millis value
  lastMillis = millis();

  // initialize the main camera
  mainCamera = new Camera(new PVector(0, 0, -20), identity, one, camFOV, true);
  overlayCamera = new Camera(zero, identity, one, camFOV, false);
  // TODO: initialize player, parent camera to player


  // initialize updateables list
  updateables = new GatedArrayList<Updateable>();

  // parenting test
  parent = new RenderObject(zero, identity, one, cube, true);
  RenderObject child1 = new RenderObject(new PVector(8, 0, 0), identity, one, cube, true);
  RenderObject child2 = new RenderObject(new PVector(8, 0, 0), identity, one, cube, true);
  child1.setParent(parent);
  child2.setParent(child1);
  
  parent.rotateBy(WORLD_FORWARD, 45);
  
  // initialize hand
  WorldObject handParent = new WorldObject(new PVector(1, 0, 1), identity, one, true);
  hand = new RenderObject(new PVector(0, 0, 0), identity, vectorScale(one, 0.15), cube, true);
  
  hand.setParent(handParent);
  handParent.setParent(mainCamera);

  
  setupControllers();

}

void draw() {

  background(0);

  // calculate delta time & increment time
  updateTime();

  updateUpdateables();
  
  checkControllerInput();

  // do camera shake
  
  //if (time < lastExplosionTime + cameraShakeTime) {
  //  float shakeIntensityRatio = 1 - ((time - lastExplosionTime) / cameraShakeTime);
  //  float shakeIntensity = cameraShakeMaxIntensity * shakeIntensityRatio;
  //  PVector randomShakeOffset = vectorScale(new PVector(random(-1, 1), random(-1, 1), random(-1, 1)).normalize(), shakeIntensity);
  //  mainCamera.setPosition(randomShakeOffset);
  //} else {
  //  mainCamera.setPosition(zero);
  //}
  
  if (keyPressed) {
    parent.rotateBy(WORLD_FORWARD, 30 * deltaTime);
  }
  
  if (mousePressed) {
     parent.movePosition(vectorScale(WORLD_FORWARD, 5 * deltaTime));
  }
}

void updateTime() {
  long currentMillis = millis();

  deltaTime = (currentMillis - lastMillis) / 1000.0;
  time += deltaTime;

  lastMillis = currentMillis;
}

void updateUpdateables() {

  // update gated list (do queued adds / removals)
  updateables.update();

  // update all updateable objects
  for (Updateable u : updateables) {
    u.update();
  }
  
  // poll controllers
  checkControllerInput();
}
