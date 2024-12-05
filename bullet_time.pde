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
public float BULLET_SCALE = 0.3;


// bullets must target a position at least this far away from the center of the player
public float BULLET_TARGET_MIN_DISTANCE = 1;
// maximum targeting distance from player center
public float BULLET_TARGET_MAX_DISTANCE = 4;

// distance that a bullet must leave in order to be considered dodged
public float BULLET_DODGE_DISTANCE = 5;

// minimum time across which bullet spawns are staggered, plus the increase in stagger interval per bullet spawned
float minStaggerTime = 0.35f;
float staggerTimeIncreasePerBullet = 0.035f;

///////////////// time scaling variables
// minimum and maximum time scales
float maxTimeScale = 1, minTimeScale = 0.25;

// the min and max distance of the closest bullet between which timescale starts to scale
float timeScaleMinDistance = 4;
float timeScaleMaxDistance = 10;
/////////////////

///////////////// game state variables

// game state: 0 = title screen, 1 = main game, 2 = game over
int gameState = 0;
boolean startButtonPressed = false;

int currentRound = 1;
int bulletsAtFirstRound = 3;
int bulletsIncreasePerRound = 1;

boolean roundComplete = false;
float timeTillRoundCompleteAfterLastBullet = 5;

// counted to determine when a round is complete (round completes once all bullets are successfully dodged)
int bulletsDodged = 0;
/////////////////


///// camera variables
// the camera's field of view (90 degrees)
public float camFOV = 1.0 / tan(90 * DEG2RAD / 2.0);

// the camera itself
public Camera mainCamera, overlayCamera;

// object to which the main camera is parented
public WorldObject camParent;

// list of updateables that will be iterated over each iteration of the game loop
GatedArrayList<Updateable> updateables;

// list of all spawned bullets
GatedArrayList<Bullet> bullets;

// list of bounding prisms - needs to be separate so that each prism can have a reference to all other prisms to check for collisions with during their update method
GatedArrayList<BoundingPrism> boundingPrisms;

boolean testView = true;

float P3D_ONE_UNIT_SCALE = 50;

RenderObject player;

// testing:
boolean qHeld, wHeld, eHeld, rHeld, aHeld, sHeld, dHeld, fHeld;

boolean doController = true;

void setup() {
  size(860, 860, P3D);

  // initialize updateables list
  updateables = new GatedArrayList<Updateable>();

  // initialize bounding prisms list
  boundingPrisms = new GatedArrayList<BoundingPrism>();

  // initialize bullets list
  bullets = new GatedArrayList<Bullet>();

  // initialize millis value
  lastMillis = millis();

  // initialize camera parent
  camParent = new WorldObject(zero, identity, one, true);

  // initialize the main camera
  mainCamera = new Camera(new PVector(0, 0, -10), identity, one, camFOV, true);
  mainCamera.setParent(camParent);

  overlayCamera = new Camera(zero, identity, one, camFOV, false);

  // set up the controller
  if (doController) setupController();

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

  RenderObject c = new RenderObject(new PVector(0, 0, 0), identity, vectorScale(one, BULLET_TARGET_MIN_DISTANCE * 2), cube, true);
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


  //Bullet b = new Bullet(zero, WORLD_RIGHT, one, true);
}

float scale_units = 50;
float wire_to_real_units = 50;

void draw() {

  background(100);
  lights();

  // calculate delta time & increment time
  updateTime();

  // poll controller
  if (doController) checkControllerInput();


  // init P3D camera
  //camera(mainCamera.position.x, mainCamera.position.y, -mainCamera.position.z, width/2, height/2, 0, 0, 1, 0);

  //  println("cam eye positioN: " + new PVector(cX, cY, cZ));
  //camera(cX, cY, cZ, width/2, height/2, 0, 0, 1, 0);
  if (!testView) camera(mainCamera.position.x * wire_to_real_units, mainCamera.position.y * wire_to_real_units, mainCamera.position.z * wire_to_real_units, 0, 0, 0, 0, 1, 0);


  updateUpdateables();

  // do game logic
  
}

void keyPressed() {
  if (gameState == 0 && !startButtonPressed) {
    startButtonPressed = true;

    onStartGame();
  }

  if (gameState == 2 && !startButtonPressed) {
    startButtonPressed = true;

    backToTitle();
  }
}

void keyReleased() {
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
  bullets.update();

  // update all updateable objects
  for (Updateable u : updateables) {
    u.update();
  }
}

/**
 Called on the start of a round - spawns all the bullets.
 */
private void onRoundStart(int roundNum) {
  
  // reset round variables
  roundComplete = false;
  bulletsDodged = 0;

  int bulletCount = bulletsAtFirstRound + bulletsIncreasePerRound * (roundNum - 1);

  // stagger the bullet spawn times using a time list
  // bullets are spawned during a tween which continually checks times - whenever a set spawn time is passed, spawn a bullet
  GatedArrayList<Float> spawnTimes = new GatedArrayList<Float>();

  // calculate max stagger time
  float maxStaggerTime = minStaggerTime + staggerTimeIncreasePerBullet * bulletCount;

  // spawn bullets equal to the round number
  for (int i = 0; i < bulletCount; i++) {

    // create a random spawn time between current time and current time + maxStaggerTime
    spawnTimes.add(time + random(maxStaggerTime));
  }

  Tween t = new Tween(0, 1, maxStaggerTime).setOnUpdate((float val) -> {
    spawnTimes.update();

    for (float f : spawnTimes) {
      if (time > f) {
        spawnBullet();
        spawnTimes.remove(f);
      }
    }
  }
  );
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

  Bullet b = new Bullet(spawnPos, targetPos, vectorScale(one, BULLET_SCALE), true);
}

/**
 Called when the player hits a bullet
 */
public void onBulletHitPlayer() {
  
  if (gameState != 1) return;
  
  timeScale = 0;
  gameState = 2;

  startButtonPressed = false;
}

/**
 Go back to the title screen, resetting game variables so that it can be replayed
 */
private void backToTitle() {

  // destroy all existing bullets
  for (Bullet b : bullets) {
    b.despawn();
  }

  // reset variables
  timeScale = 1;
  currentRound = 1;

  gameState = 0;
  startButtonPressed = false;

  // TODO: reset camera position and rotation
}

/**
 Called on the start of the game
 */
private void onStartGame() {
  gameState = 1;

  // start first round
  onRoundStart(currentRound);
}

private void onRoundComplete() {
  // destroy all existing bullets
  for (Bullet b : bullets) {
    b.despawn();
  }

  // increment the round counter
  currentRound++;

  // start the next round
  onRoundStart(currentRound);
}

/**
  Called from the Bullet class once a bullet is 'dodged' (i.e. after it leaves a certain radius of the player).
*/
public void onBulletDodged() {
  bulletsDodged++; 
  
  if (bulletsDodged == bulletsAtFirstRound + (currentRound - 1) * bulletsIncreasePerRound && !roundComplete) {
   roundComplete = true; 
   
   // once the last bullet is dodged, complete the round after a few seconds and start the next one
   Tween t = new Tween(0, 1,timeTillRoundCompleteAfterLastBullet).setOnComplete(() -> {
     onRoundComplete();
   });
  }
}
