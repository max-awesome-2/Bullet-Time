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
public float BULLET_SPEED = 2;
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
GatedArrayList<Updateable> updateables;

// list of bounding prisms - needs to be separate so that each prism can have a reference to all other prisms to check for collisions with during their update method
GatedArrayList<BoundingPrism> boundingPrisms;

boolean testView = true;

float P3D_ONE_UNIT_SCALE = 50;

RenderObject player;

// testing:
boolean qHeld, wHeld, eHeld, rHeld, aHeld, sHeld, dHeld, fHeld;

void setup() {
  size(860, 860, P3D);

  // initialize updateables list
  updateables = new GatedArrayList<Updateable>();

  // initialize bounding prisms list
  boundingPrisms = new GatedArrayList<BoundingPrism>();

  // initialize millis value
  lastMillis = millis();

  // initialize camera parent
  camParent = new WorldObject(zero, identity, one, true);

  // initialize the main camera
  mainCamera = new Camera(new PVector(0, 0, -10), identity, one, camFOV, true);
  mainCamera.setParent(camParent);

  overlayCamera = new Camera(zero, identity, one, camFOV, false);

  //setupController();

  // initialize player object & player hitboxes
  player = new RenderObject(zero, identity, vectorScale(one, 0.5), loadShape("guy.obj"), true);

  float guyThickness = 0.55;

  // body
  BoundingPrism b1 = new BoundingPrism(new PVector(0, -1, 0), identity, new PVector(guyThickness, 4.3, 2), true);

  // head
  BoundingPrism b2 = new BoundingPrism(new PVector(0, -4, 0), identity, new PVector(guyThickness, 1, 3), true);
  BoundingPrism b3 = new BoundingPrism(new PVector(0, -5, 0), identity, new PVector(guyThickness, 1, 2.25), true);

  // arms
  BoundingPrism b4 = new BoundingPrism(new PVector(0, -2.95, -2.2), new Quaternion(57, WORLD_RIGHT), new PVector(guyThickness, 3.5, 1.15), true);
  BoundingPrism b5 = new BoundingPrism(new PVector(0, -2.95, 2.2), new Quaternion(-57, WORLD_RIGHT), new PVector(guyThickness, 3.5, 1.15), true);
  
  // legs
  BoundingPrism b6 = new BoundingPrism(new PVector(0, 2.45, -1.8), new Quaternion(-53, WORLD_RIGHT), new PVector(guyThickness, 4.75, 1.4), true);
    BoundingPrism b7 = new BoundingPrism(new PVector(0, 2.45, 1.8), new Quaternion(53, WORLD_RIGHT), new PVector(guyThickness, 4.75, 1.4), true);

  
  //println("A intersects: " + lineIntersectsSphere(new PVector(-5, -0.75, 0), new PVector(5, 0.-75, 0), 0, 0, 0, 1));
  onRoundStart(3);
  
  //RenderObject c = new RenderObject(new PVector(0, 5, 0), identity, new PVector(1, 1, 3), cube, true);
  //RenderObject o = new RenderObject(zero, lookRotationArbitrary(new PVector(0, 1, 0)), vectorScale(one, 0.5), loadShape("bullet.obj"), true);
  //Bullet b = new Bullet(zero, WORLD_BACKWARD, one, true);
  //  b = new Bullet(zero, new PVector(0, 1, -1), one, true);
  //b = new Bullet(zero, WORLD_UP, one, true);
  //    b = new Bullet(zero, new PVector(0, 1, 1), one, true);

  //b = new Bullet(zero, WORLD_FORWARD, one, true);

  
  //println("identity: " + identity);
  //println("right up: " +  lookRotation(WORLD_RIGHT, WORLD_UP));
  b1.setParent(player);
  b2.setParent(player);
  b3.setParent(player);
  b4.setParent(player);
  b5.setParent(player);
  b6.setParent(player);
  b7.setParent(player);

  // initialize bullet object and hitboxes
  RenderObject bullet = new RenderObject(zero, identity, one, loadShape("bullet.obj"), true);
  BoundingPrism bb1 = new BoundingPrism(new PVector(0, -0.13094, 0), identity, new PVector(0.783,1.456, 0.783), false);
  BoundingPrism bb2 = new BoundingPrism(new PVector(0, 0.75415, 0), identity, new PVector(0.635, 0.310, 0.635), false);
  BoundingPrism bb3 = new BoundingPrism(new PVector(0, 1.0238, 0), identity, new PVector(0.429, 0.210, 0.429), false);
  
  bb1.setParent(bullet);
  bb2.setParent(bullet);
  bb3.setParent(bullet);




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
    camParent.rotateByLocal(WORLD_UP, 60 * deltaTime);
    //cX += deltaTime * 50;
  }
  if (wHeld) {
    camParent.rotateByLocal(WORLD_UP, -60 * deltaTime);
    //cX -= deltaTime * 50;
  }
  //}

  if (eHeld) {

    //camParent.rotateByLocal(WORLD_RIGHT, 30 * deltaTime);
    player.movePosition(new PVector(0, deltaTime * 5, 0));
    //cY += deltaTime * 50;
    //testCube1.movePosition(new PVector(deltaTime * 5, 0, 0));
  }
  if (rHeld) {

    //camParent.rotateByLocal(WORLD_RIGHT, -30 * deltaTime);
    player.movePosition(new PVector(0, deltaTime * -5, 0));
    //cY -= deltaTime * 50;
    //testCube1.movePosition(new PVector(deltaTime * -5, 0, 0));
  }

  if (aHeld) {
    //camParent.rotateBy(WORLD_FORWARD, 30 * deltaTime);
    //cZ += deltaTime * 50;
    //testCube1.rotateBy(WORLD_FORWARD, 30 * deltaTime);
  }
  if (sHeld) {
    //camParent.rotateBy(WORLD_FORWARD, -30 * deltaTime);
    //cZ -= deltaTime * 50;
    //testCube1.rotateBy(WORLD_FORWARD, -30 * deltaTime);
  }

  if (dHeld) {
    //testCube.rotateBy(WORLD_UP, 30 * deltaTime);
    //testCube1.movePosition(new PVector(0, deltaTime * 5, 0));
  }
  if (fHeld) {
    //testCube.rotateBy(WORLD_UP, -30 * deltaTime);
    onRoundStart(1);
    //testCube1.movePosition(new PVector(0, deltaTime * -5, 0));
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

  // update gated lists (do queued adds / removals)
  updateables.update();
  boundingPrisms.update();

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

/**
 Called when the player hits a bullet
 */
public void onBulletHitPlayer() {
  println("BULLET HIT PLAYER!");
}
