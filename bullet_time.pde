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

float timeScale = 1;
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

// game logic constants
public float BULLET_SPEED = 1;
public float BULLET_SPAWN_DISTANCE = 15;

// bullets must target a position at least this far away from the center of the player
public float BULLET_TARGET_MIN_DISTANCE = 0.5;
// maximum targeting distance from player center
public float BULLET_TARGET_MAX_DISTANCE = 1;

///// camera variables
// the camera's field of view (90 degrees)
public float camFOV = 1.0 / tan(90 * DEG2RAD / 2.0);

// the camera itself
public Camera mainCamera, overlayCamera;

// object to which the main camera is parented
public WorldObject camParent;

// list of updateables that will be iterated over each iteration of the game loop
GatedArrayList<Updateable> updateables, p3dObjects;

boolean testView = true;

float P3D_ONE_UNIT_SCALE = 50;

// testing:
boolean qHeld, wHeld, eHeld, rHeld, aHeld, sHeld, dHeld, fHeld;

void setup() {
  size(860, 860, P3D);

  // initialize updateables list
  updateables = new GatedArrayList<Updateable>();

  // initialize millis value
  lastMillis = millis();

  // initialize camera parent
  camParent = new WorldObject(zero, identity, one, true);

  // initialize the main camera
  mainCamera = new Camera(new PVector(0, 0, -10), identity, one, camFOV, true);
  mainCamera.setParent(camParent);

  overlayCamera = new Camera(zero, identity, one, camFOV, false);

  //setupController();

  // shape test
  //RenderObject testCube2 = new RenderObject(new PVector(0, 0, 0), identity, one, loadShape("test_cube.obj"), true);
  
  //println("A intersects: " + lineIntersectsSphere(new PVector(-5, -0.75, 0), new PVector(5, 0.-75, 0), 0, 0, 0, 1));
  onRoundStart(10);
  
  //RenderObject c = new RenderObject(new PVector(0, 5, 0), identity, new PVector(1, 1, 3), cube, true);
  RenderObject o = new RenderObject(zero, lookRotationArbitrary(new PVector(0, 1, 0)), vectorScale(one, 0.5), loadShape("bullet.obj"), true);
  //Bullet b = new Bullet(zero, WORLD_BACKWARD, one, true);
  //  b = new Bullet(zero, new PVector(0, 1, -1), one, true);
  //b = new Bullet(zero, WORLD_UP, one, true);
  //    b = new Bullet(zero, new PVector(0, 1, 1), one, true);

  //b = new Bullet(zero, WORLD_FORWARD, one, true);

  
  //println("identity: " + identity);
  //println("right up: " +  lookRotation(WORLD_RIGHT, WORLD_UP));

  //testCube.rotateBy(WORLD_FORWARD, 45);
  //mainCamera.rotateBy(WORLD_FORWARD, 45);
}

float scale_units = 50;
float wire_to_real_units = 50;

void draw() {

  background(100);
  lights();

  // calculate delta time & increment time
  updateTime();


  // poll controller
  //checkControllerInput();


  // init P3D camera
  //camera(mainCamera.position.x, mainCamera.position.y, -mainCamera.position.z, width/2, height/2, 0, 0, 1, 0);

  //  println("cam eye positioN: " + new PVector(cX, cY, cZ));
  //camera(cX, cY, cZ, width/2, height/2, 0, 0, 1, 0);
  if (!testView) camera(mainCamera.position.x * wire_to_real_units, mainCamera.position.y * wire_to_real_units, mainCamera.position.z * wire_to_real_units, 0, 0, 0, 0, 1, 0);


  updateUpdateables();

  //if (testView) {
  if (qHeld) {
    camParent.rotateByLocal(WORLD_UP, 30 * deltaTime);
    //cX += deltaTime * 50;
  }
  if (wHeld) {
    camParent.rotateByLocal(WORLD_UP, -30 * deltaTime);
    //cX -= deltaTime * 50;
  }
  //}

  if (eHeld) {
    //camParent.rotateByLocal(WORLD_RIGHT, 30 * deltaTime);
    //mainCamera.movePosition(new PVector(0, 0, deltaTime * 5));
    //cY += deltaTime * 50;
  }
  if (rHeld) {
    //camParent.rotateByLocal(WORLD_RIGHT, -30 * deltaTime);
    //mainCamera.movePosition(new PVector(0, 0, deltaTime * -5));
    //cY -= deltaTime * 50;
  }

  if (aHeld) {
    //camParent.rotateBy(WORLD_FORWARD, 30 * deltaTime);
    //cZ += deltaTime * 50;
  }
  if (sHeld) {
    //camParent.rotateBy(WORLD_FORWARD, -30 * deltaTime);
    //cZ -= deltaTime * 50;
  }

  if (dHeld) {
    //testCube.rotateBy(WORLD_UP, 30 * deltaTime);
  }
  if (fHeld) {
    //testCube.rotateBy(WORLD_UP, -30 * deltaTime);
    onRoundStart(1);
  }
}

void keyPressed() {
  if (key == 'q') {
    qHeld = true;
  }
  if (key == 'w') {
    wHeld = true;
  }
  if (key == 'e') {
    eHeld = true;
  }
  if (key == 'r') {
    rHeld = true;
  }
  if (key == 'a') {
    aHeld = true;
  }
  if (key == 's') {
    sHeld = true;
  }
  if (key == 'd') {
    dHeld = true;
  }
  if (key == 'f') {
    fHeld = true;
  }
}

void keyReleased() {
  if (key == 'q') {
    qHeld = false;
  }
  if (key == 'w') {
    wHeld = false;
  }
  if (key == 'e') {
    eHeld = false;
  }
  if (key == 'r') {
    rHeld = false;
  }
  if (key == 'a') {
    aHeld = false;
  }
  if (key == 's') {
    sHeld = false;
  }
  if (key == 'd') {
    dHeld = false;
  }
  if (key == 'f') {
    fHeld = false;
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
}

private void onRoundStart(int roundNum) {

  // spawn bullets equal to the round number
  for (int i = 0; i < roundNum; i++) {
    spawnBullet();
  }
}

private void spawnBullet() {
  // get a random point on the edge of the sphere
  PVector randDirection = new PVector(random(1), random(1), random(1)).normalize();

  PVector spawnPos = vectorScale(randDirection, BULLET_SPAWN_DISTANCE);

  PVector targetPos = zero.copy();

  // now pick a target, ensuring that the selected target doesn't make the bullet travel through
  boolean validTarget = false;
  while (!validTarget) {
    randDirection = new PVector(random(1), random(1), random(1)).normalize();
    targetPos = vectorScale(randDirection, random(BULLET_TARGET_MIN_DISTANCE, BULLET_TARGET_MAX_DISTANCE));

    PVector direction = vectorSubtract(targetPos, spawnPos).normalize();
   
    // generate a line start and end point we can use the algorithm with
    PVector lineStart = vectorAdd(targetPos, vectorScale(direction, -BULLET_SPAWN_DISTANCE)), lineEnd = vectorAdd(targetPos, vectorScale(direction, BULLET_SPAWN_DISTANCE));

    validTarget = !lineIntersectsSphere(lineStart, lineEnd, 0, 0, 0, BULLET_TARGET_MIN_DISTANCE);
  }
  
  Bullet b = new Bullet(spawnPos, targetPos, one, true);
}
