
// later, replace this wherever this is used w/ a cam-transformed size for hitspheres
float BULLET_ONE_RADIUS = 20;

// these variables are used to make drawn bullets and lines flicker slightly - it adds a lot to the 1980s vector aesthetic
float BULLET_RANDOM_BRIGHTNESS_MAGNITUDE = 50;

// enemies flicker more severely the more damaged they are
float MIN_LINE_RANDOM_ALPHA_MAGNITUDE = 80;

// flicker magnitude for lines
float LETTER_LINE_RANDOM_ALPHA_MAGNITUDE = 100;

// variables for face flashing - enemy's shape faces flash red for a moment upon taking damage
// the time for which the face will flash upon taking damage
float DAMAGE_FLASH_TIME = 0.2;
// the maximum opacity of a face when damage flashing
float MIN_DAMAGE_FLASH_FULL_OPACITY = 100, MAX_DAMAGE_FLASH_FULL_OPACITY = 235;

// defines the 'boundaries' of the game world - if an entity passes over this threshold on any side of the XY plane, it despawns
float DESPAWN_BOUNDARY = 16;

// consistent opacity used to draw UI elements
float UI_OPACITY = 100;


/**
 Base class.
 */
public class WorldObject implements Updateable {
  // Transform info: position, scale, rotation, velocity
  public PVector position = zero.copy();
  public Quaternion rotation = identity.getCopy();

  // parent object, local position, local rotation
  public WorldObject parent;
  public ArrayList<WorldObject> children = new ArrayList<WorldObject>();
  public PVector localPosition = zero.copy();
  public Quaternion localRotation = identity.getCopy();

  public PVector scale = one;
  public PVector localScale = one.copy();

  // local direction vectors (for rotation)
  public PVector forward = WORLD_FORWARD.copy(), right = WORLD_RIGHT.copy(), up = WORLD_UP.copy();


  public WorldObject(PVector p, Quaternion rot, PVector sc, boolean addToEntityList) {
    localPosition = p.copy();
    localRotation = rot.getCopy();
    localScale = sc.copy();

    if (addToEntityList) updateables.add(this);

    onTransformUpdate();
  }

  @Override
    public void update() {
  }

  public void movePosition(PVector by) {
    localPosition = vectorAdd(localPosition, by);

    onTransformUpdate();
  }

  public void setPosition(PVector newPos) {
    localPosition = newPos.copy();

    onTransformUpdate();
  }

  public void setRotation(Quaternion q) {
    localRotation = q.getCopy();

    onTransformUpdate();
  }

  public void setScale(PVector newScale) {
    localScale = newScale.copy();
    onTransformUpdate();
  }

  public void rotateByEulers(PVector by) {

    if (by.x != 0) {
      localRotation.multiply(new Quaternion(by.x, WORLD_RIGHT));
    }
    if (by.y != 0) {
      localRotation.multiply(new Quaternion(by.y, WORLD_UP));
    }
    if (by.z != 0) {
      localRotation.multiply(new Quaternion(by.z, WORLD_FORWARD));
    }

    onTransformUpdate();
  }

  /**
   Sets this Entity's rotation based on a set of Euler angles.
   */
  public void setRotationEulers(PVector eulers) {
    localRotation = new Quaternion(eulers.x, WORLD_RIGHT).multiply(new Quaternion(eulers.y, WORLD_UP).multiply(new Quaternion(eulers.z, WORLD_FORWARD)));

    onTransformUpdate();
  }

  /**
   Sets this Entity's rotation based on an axis and a number of degrees to rotate around that axis
   */
  public void setRotationDegsAxis(float degrees, PVector axis, boolean modelOnly) {

    rotation = new Quaternion(degrees, axis);

    onTransformUpdate();
  }

  /**
   Transforms the given axis of rotation into local space before rotation
   */
  public void rotateByLocal(PVector axis, float degs) {

    Quaternion r = localRotation;

    axis = rotateVector(axis, r);

    rotateBy(axis, degs);

    onTransformUpdate();
  }

  /**
   Rotates this Entity given an axis and a number of degrees to rotate around that axis.
   */
  public void rotateBy(PVector axis, float degs) {

    localRotation = localRotation.multiply(new Quaternion(degs, axis));

    onTransformUpdate();
  }

  protected void onTransformUpdate() {

    if (parent != null) {
      // set our world transforms based off of the immediate parent's world transforms
      // 1. world rotation = local rotation * parent world rotation
      // 2. world position = local position + parent world position
      // 3. world position = world position rotated by parent world rotation around parent world position
      // 4. world scale = local scale * parent world scale
      // 5. world position = world position * parent world scale
      rotation = parent.rotation.getCopy().multiply(localRotation);
      position = vectorAdd(vectorScaleByVector(localPosition, parent.scale), parent.position);
      position = rotatePointAround(position, parent.position, parent.rotation);
      scale = vectorScaleByVector(parent.scale, localScale);
    } else {
      position = localPosition.copy();
      rotation = localRotation.getCopy();
      scale = localScale.copy();
    }

    // precipitate update to children
    for (WorldObject c : children) {
      c.onTransformUpdate();
    }

    // recalculate forward, right, and up
    forward = rotateVector(WORLD_FORWARD, rotation);
    right = rotateVector(WORLD_RIGHT, rotation);
    up = rotateVector(WORLD_UP, rotation);
  }


  public void setParent(WorldObject p) {
    parent = p;
    parent.addChild(this);

    onTransformUpdate();
  }

  public void clearParent() {
    // keep world position
    onTransformUpdate();
    parent.removeChild(this);

    // set local transforms to world transforms
    localPosition = position.copy();
    localRotation = rotation.getCopy();
    localScale = scale.copy();
  }

  public void addChild(WorldObject c) {
    children.add(c);
  }

  public void removeChild(WorldObject c) {
    children.remove(c);
  }

  /**
   Removes this object and its children from the main updateables list, effectively despawning it.
   */
  public void despawn() {
    updateables.remove(this);

    for (WorldObject w : children) {
      w.despawn();
    }
  }
}
/*
public class Camera extends WorldObject {
 }
 */

public class RenderObject extends WorldObject {

  // defines what type of Entity this is
  // 0 = player, 1 = shot, 2 = enemy, 3 = camera, 4 = letter, 5 = explosion graphic, 6 = player shot, 7 = UI elements (such as the life counter), 8 = enemy spawner
  // 9 = pickup vector
  public int entityType = 0;


  // list of shapes defined by vertices
  protected ArrayList<Shape> shapes = new ArrayList<Shape>();

  // shape template - kept only because it's necessary to make a copy of this entity
  public ShapeTemplate shapeTemplate;

  // for enemies, shots, and the player, their hitbox is spherical, and its radius is defined here
  public float hitSphereRadius = 0.5;

  public PShape pShape;

  // if true, this is a wireframe rendered shape and will be rendered with the wireframe renderer ONLY when testView is true
  // if false, this is a P3D rendered shape
  boolean wire = true;

  public RenderObject(PVector p, Quaternion rot, PVector sc, ShapeTemplate t, boolean addToEntityList) {

    super(p, rot, sc, addToEntityList);

    shapeTemplate = t;

    if (t != null)
      shapes.add(new Shape(t));

    onTransformUpdate();
  }

  public RenderObject(PVector p, Quaternion rot, PVector sc, PShape sh, boolean addToEntityList) {

    super(p, rot, sc, addToEntityList);

    pShape = sh;
    pShape.scale(P3D_ONE_UNIT_SCALE * localScale.x);
    wire = false;

    onTransformUpdate();
  }

  @Override
    public void update() {
    render(mainCamera);
  }

  public void render(Camera c) {

    // draw stored shape with P3D renderer
    if (pShape != null) {
      pushMatrix();

      if (testView) translate(width/2, height/2);


      //translate(testCube.position.x * wire_to_real_units, -testCube.position.y * wire_to_real_units, testCube.position.z * wire_to_real_units);
      //translate(-mainCamera.position.x * wire_to_real_units, -mainCamera.position.y * wire_to_real_units, (mainCamera.position.z + 10) * wire_to_real_units);
      perspective(camFOV, float(width)/float(height), 0.1, 10000);

      // get rotation and translation
      Quaternion finalRot;
      if (testView) {
        finalRot = mainCamera.rotation.getCopy().multiply(rotation);
      } else  finalRot = rotation;

      PVector finalTranslation = position;

      float[] m = new float[16];

      if (testView) {
        // perform camera rotation
        mainCamera.rotation.toMatrix(m);
        applyMatrix(m[0], m[1], m[2], m[3],
          m[4], m[5], m[6], m[7],
          m[8], m[9], m[10], m[11],
          m[12], m[13], m[14], m[15]);
      }


      // perform final translation
      translate(finalTranslation.x * wire_to_real_units, finalTranslation.y * wire_to_real_units, (-finalTranslation.z) * wire_to_real_units);

      Quaternion qAltered = new Quaternion(-rotation.w, rotation.x, rotation.y, -rotation.z);
      // apply object rotation
      qAltered.toMatrix(m);
      applyMatrix(m[0], m[1], m[2], m[3],
        m[4], m[5], m[6], m[7],
        m[8], m[9], m[10], m[11],
        m[12], m[13], m[14], m[15]);



      // render the shape
      shape(pShape);
      popMatrix();
    }

    // draw shapes with wire renderer
    if (shapes.size() > 0) {

      if (!testView) return;

      // loop through all the shapes that make up this object and draw each one
      for (Shape s : shapes) {

        s.setCameraVertices(c);

        stroke(255);
        for (int i = 0; i <= s.template.lines.length - 2; i += 2) {

          // line alpha flicker magnitude
          float minAlphaMagOffset = 0;

          // anti-seed our random with frameCount, so that even at the title screen, where we're re-seeding the random every frame to make sure the stars
          // stay in the same spot, our letters will still flicker
          randomSeed(frameCount * 10000 + i * 10000);

          minAlphaMagOffset = LETTER_LINE_RANDOM_ALPHA_MAGNITUDE;

          float randomAlpha = random(255 - minAlphaMagOffset, 255);
          stroke(255, 255, 255, randomAlpha);


          drawLine(s.cameraVertices[s.template.lines[i]], s.cameraVertices[s.template.lines[i + 1]]);
        }


        if (DRAW_DEBUG_AXES) {
          stroke(0, 0, 255);
          drawLine(projectPoint(position, c), projectPoint(vectorAdd(position, forward), c));
          stroke(0, 255, 0);
          drawLine(projectPoint(position, c), projectPoint(vectorAdd(position, up), c));
          stroke(255, 0, 0);
          drawLine(projectPoint(position, c), projectPoint(vectorAdd(position, right), c));
        }
      }
    }
  }

  protected void updateShapes() {

    if (shapes == null) return;

    for (Shape s : shapes) {
      s.setWorldVertices(position, rotation, scale);
    }
  }

  @Override
    protected void onTransformUpdate() {

    super.onTransformUpdate();


    updateShapes();
  }
}

public class Bullet extends WorldObject {

  // direction in which this bullet travels
  private PVector travelDirection;
  
  // variable to determine whether the player has successfully 'dodged' this bullet yet
  // passedIntoRadius is called when we pass within BULLET_TARGET_MAX_DISTANCE of the center
  // dodged is called once we leave BULLET_DODGE_RADIUS
  boolean passedIntoRadius = false;
  boolean dodged = false;

  public Bullet(PVector p, PVector target, PVector sc, boolean addToEntityList) {

    super(p, identity, sc, addToEntityList);

    travelDirection = (vectorSubtract(target, p)).normalize();
    setRotation(lookRotation(travelDirection, getArbitraryPerpendicular(travelDirection)));

    onTransformUpdate();

    // apply partial scaling here because P3D models are a pain in the rear and you can only APPLY a scale factor, not set the scale of the model
    PShape m = loadShape("bullet.obj");
    m.scale(sc.x);

    // child model
    RenderObject model = new RenderObject(zero, lookRotationArbitrary(WORLD_UP), new PVector(1, 1, 1), m, true);
    model.setParent(this);

    // instantiate hitboxes here
    BoundingPrism bb1 = new BoundingPrism(new PVector(0, -0.13094, 0), identity, new PVector(0.783, 1.456, 0.783), false);
    BoundingPrism bb2 = new BoundingPrism(new PVector(0, 0.75415, 0), identity, new PVector(0.635, 0.310, 0.635), false);
    BoundingPrism bb3 = new BoundingPrism(new PVector(0, 1.0238, 0), identity, new PVector(0.429, 0.210, 0.429), false);

    bb1.setParent(model);
    bb2.setParent(model);
    bb3.setParent(model);
    
    bullets.add(this);
  }

  @Override
    public void update() {

    movePosition(vectorScale(travelDirection, timeScale * deltaTime * BULLET_SPEED));
    
    // get distance from center
    float d = position.mag();
    
    if (!passedIntoRadius && d < BULLET_TARGET_MAX_DISTANCE) {
     passedIntoRadius = true; 
    } else if (passedIntoRadius && !dodged && d > BULLET_DODGE_DISTANCE) {
     dodged = true;
     onBulletDodged();
    }
  }

  @Override
    public void despawn() {
    super.despawn();
    
    // remove from the list of bullets
    bullets.remove(this);
  }
}

/**
 A BoundingPrism represents a rectangular hitbox.
 It contains a method for determining whether it is colliding with another bounding prism.
 */
public class BoundingPrism extends RenderObject {

  // since our game only has two types of hitboxes - player and bullet hitboxes - we can just have a boolean instead of any kind of tag system
  // we can trigger a method in the main file when a collision between the two types is detected here
  public boolean isPlayer;

  public BoundingPrism(PVector p, Quaternion rot, PVector sc, boolean isPl) {
    super(p, rot, sc, cube, true);

    boundingPrisms.add(this);

    isPlayer = isPl;
  }

  public BoundingPrism(PVector p, Quaternion rot, PVector sc, PShape shape, boolean isPl) {
    super(p, rot, sc, cube, true);
    pShape = shape;

    boundingPrisms.add(this);

    isPlayer = isPl;
  }

  @Override
    public void update() {
    // only check collisions with prisms of the opposite type
    // also avoids checking self-collisions
    for (BoundingPrism prism : boundingPrisms) {
      if (prism.isPlayer != isPlayer) {
        if (intersects(prism)) {
          onBulletHitPlayer();
        }
      }
    }

    render(mainCamera);
  }

  @Override
    public void despawn() {
    super.despawn();
    boundingPrisms.remove(this);
  }

  public boolean intersects(BoundingPrism other) {
    // in order to determine that two shapes are not colliding, we need to find one plane that separates them
    // for rectangular prisms, that plane is guaranteed to be one of the planes that the prism's faces is on

    // referenced pseudocode at https://www.gamedev.net/forums/topic/628444-collision-detection-between-non-axis-aligned-rectangular-prisms/

    // list to store all axes that we'll be testing
    PVector[] axes = new PVector[15];

    // add the 3 axis of each box
    axes[0] = forward;
    axes[1] = up;
    axes[2] = right;
    axes[3] = other.forward;
    axes[4] = other.up;
    axes[5] = other.right;

    // add the cross products of each set of axes
    for (int i = 0; i < 3; i ++) {
      for (int j = 0; j < 3; j++) {
        axes[6 + i * 3 + j] = axes[i].cross(axes[3 + j]);
      }
    }

    // check overlap on each axis
    for (PVector axis : axes) {
      // skip over (0, 0, 0) axes that result from crossing the same axis
      // we will get NaNs and things will go crazy
      if (axis.x == 0 && axis.y == 0 && axis.z == 0) continue;

      PVector prismARange = projectPrism(this, axis);
      PVector prismBRange = projectPrism(other, axis);

      if (!rangeIntersects(prismARange, prismBRange)) {
        // we have found a plane that separates the two prisms!
        return false;
      }
    }

    // no plane separating the two prisms was found, meaning the prisms are colliding
    return true;
  }
}
