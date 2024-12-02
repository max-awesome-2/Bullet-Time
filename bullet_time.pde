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

// object to which the main camera is parented
public WorldObject camParent;

public Entity player;

// list of updateables that will be iterated over each iteration of the game loop
GatedArrayList<Updateable> updateables, p3dObjects;

RenderObject testCube;


PShape pCube;

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

  setupController();

  // shape test
  pCube = loadShape("test_cube.obj");
  pCube.scale(wire_to_real_units);
  testCube = new RenderObject(new PVector(0, 0, 0), identity, one, cube, true);
  //testCube.rotateBy(WORLD_FORWARD, 45);
  //mainCamera.rotateBy(WORLD_FORWARD, 45);

  println("pcube: " + pCube);
}

float scale_units = 50;
float wire_to_real_units = 50;

void draw() {

  background(50);
  lights();

  // calculate delta time & increment time
  updateTime();


  // poll controller
  checkControllerInput();


  // init P3D camera
  //camera(mainCamera.position.x, mainCamera.position.y, -mainCamera.position.z, width/2, height/2, 0, 0, 1, 0);

  // cube test
  pushMatrix();

  translate(width/2, height/2, 0);
  //translate(testCube.position.x * wire_to_real_units, -testCube.position.y * wire_to_real_units, testCube.position.z * wire_to_real_units);
  //translate(-mainCamera.position.x * wire_to_real_units, -mainCamera.position.y * wire_to_real_units, (mainCamera.position.z + 10) * wire_to_real_units);
  perspective(camFOV, float(width)/float(height), 0.1, 10000);

  Quaternion finalRot = testCube.rotation.getCopy().multiply(mainCamera.rotation);

  PVector finalTranslation = vectorAdd(testCube.position, vectorScale(mainCamera.position, -1));
  finalTranslation = rotatePointAround(finalTranslation, mainCamera.position, mainCamera.rotation);

  translate(finalTranslation.x * wire_to_real_units, -finalTranslation.y * wire_to_real_units, (-finalTranslation.z + 10) * wire_to_real_units);
   float[] m = new float[16];
  finalRot.toMatrix(m);
  applyMatrix(m[0], m[1], m[2], m[3],
    m[4], m[5], m[6], m[7],
    m[8], m[9], m[10], m[11],
    m[12], m[13], m[14], m[15]);


  //float[] m = new float[16];
  //mainCamera.rotation.toMatrix(m);
  //applyMatrix(m[0], m[1], m[2], m[3],
  //  m[4], m[5], m[6], m[7],
  //  m[8], m[9], m[10], m[11],
  //  m[12], m[13], m[14], m[15]);

  //translate(mainCamera.position.x * wire_to_real_units, mainCamera.position.y * wire_to_real_units, -(mainCamera.position.z + 10) * wire_to_real_units);

  shape(pCube);
  popMatrix();

  updateUpdateables();


  if (keyPressed) {
    //parent.rotateBy(WORLD_FORWARD, 30 * deltaTime);
    //testCube.rotateBy(WORLD_FORWARD, 30 * deltaTime);
        testCube.movePosition(vectorScale(WORLD_LEFT, 5 * deltaTime));

  }

  if (mousePressed) {
    //parent.movePosition(vectorScale(WORLD_FORWARD, 5 * deltaTime));
    //tZ += 1;
    //mainCamera.movePosition(vectorScale(WORLD_FORWARD, 5 * deltaTime));
    testCube.movePosition(vectorScale(WORLD_RIGHT, 5 * deltaTime));
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
