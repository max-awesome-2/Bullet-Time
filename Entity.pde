
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
    localPosition = newPos;

    onTransformUpdate();
  }



  public void setScale(PVector newScale) {
    localScale = newScale;
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
      rotation = parent.rotation.getCopy().multiply(localRotation);
      position = vectorAdd(localPosition, parent.position);
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

  // local direction vectors (for rotation)
  public PVector forward = WORLD_FORWARD.copy(), right = WORLD_RIGHT.copy(), up = WORLD_UP.copy();


  // for enemies, shots, and the player, their hitbox is spherical, and its radius is defined here
  public float hitSphereRadius = 0.5;

  public RenderObject(PVector p, Quaternion rot, PVector sc, ShapeTemplate t, boolean addToEntityList) {

    super(p, rot, sc, addToEntityList);

    shapeTemplate = t;

    if (t != null)
      shapes.add(new Shape(t));

    onTransformUpdate();
  }

  @Override
    public void update() {
    render(mainCamera);
  }

  public void render(Camera c) {

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

  protected void updateShapes() {

    if (shapes == null) return;

    for (Shape s : shapes) {
      s.setWorldVertices(position, rotation, scale);
    }
  }

  @Override
    protected void onTransformUpdate() {

    super.onTransformUpdate();

    // recalculate forward, right, and up
    forward = rotateVector(WORLD_FORWARD, rotation);
    right = rotateVector(WORLD_RIGHT, rotation);
    up = rotateVector(WORLD_UP, rotation);


    updateShapes();
  }

  /**
   Removes this Entity from the main Entity list, effectively despawning it.
   */
  public void despawn() {
    updateables.remove(this);
  }

  public void checkCollision(RenderObject other) {
  }
}


/**
 A StateEntity is any RenderObject that has state-defined behaviour.
 */
public class Entity extends RenderObject {

  // used by enemies to determine the alpha with which to draw faces - faces of the shape flash red when an enemy takes damage
  private float lastHurtTime;

  // set randomly whenever an enemy takes damage
  private float damageFlashFullOpacity;

  /**
   Constructor for the Entity class - takes and assigns position, rotation, scale, shape, entity type, and a boolean indicating whether to add this Entity to the main Entity list
   */
  public Entity(PVector worldPos, Quaternion worldRot, PVector worldScale, ShapeTemplate t, int eType, boolean addToEntityList) {

    super(worldPos, worldRot, worldScale, t, addToEntityList);

    position = worldPos.copy();
    rotation = worldRot.getCopy();
    scale = worldScale.copy();

    entityType = eType;

    // set bullet hitbox size to scale x / 2
    if (entityType == 1) {
      hitSphereRadius = scale.x / 2;
    }

    onTransformUpdate();
  }

  // draws this object to the screen using the given camera
  @Override
    public void render(Camera c) {

    // transform the center into camera space and see if it's within FOV
    //https://stackoverflow.com/questions/24153230/how-to-work-out-if-a-point-is-behind-the-field-of-view
    PVector centerTransformed = camTransformPoint(position, c);
    if (centerTransformed.z < nearClipping) return;
    //if (!(center.z < center.x * center.x + center.y * center.y && center.z > 0)) return;
    // end of  referenced code

    // loop through all the shapes that make up this object and draw each one
    for (Shape s : shapes) {

      s.setCameraVertices(c);

      // draw triangles before drawing lines
      // get the alpha to draw faces with depending on when the last time we took damage was
      float flashAlphaRatio = min(1, (time - lastHurtTime) / DAMAGE_FLASH_TIME);
      if (flashAlphaRatio > 0) {
        PVector v1, v2, v3;

        // make faces flash when taking damage
        noStroke();
        fill(255, 0, 0, (1 - flashAlphaRatio) * damageFlashFullOpacity);

        for (int i = 0; i < s.template.tris.length - 3; i += 3) {
          v1 = s.cameraVertices[s.template.tris[i]];
          v2 = s.cameraVertices[s.template.tris[i + 1]];
          v3 = s.cameraVertices[s.template.tris[i + 2]];

          drawTri(v1, v2, v3);
        }
        stroke(255);
      }

      stroke(255);
      for (int i = 0; i <= s.template.lines.length - 2; i += 2) {

        // line alpha flicker magnitude
        float minAlphaMagOffset = 0;

        // anti-seed our random with frameCount, so that even at the title screen, where we're re-seeding the random every frame to make sure the stars
        // stay in the same spot, our letters will still flicker
        randomSeed(frameCount * 10000 + i * 10000);

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

    // draw this entity's hitsphere
    if (DRAW_HITSPHERES) {
      noStroke();
      fill(0, 255, 0, 100);

      PVector projectedPos = projectPoint(position, c);
      float drawX = projectedPos.x * UNITS_TO_PIXELS + HALF_WIDTH;
      float drawY = projectedPos.y * UNITS_TO_PIXELS + HALF_WIDTH;
      ellipse(drawX, drawY, hitSphereRadius * BULLET_ONE_RADIUS * scale.x, hitSphereRadius * BULLET_ONE_RADIUS * scale.x);

      stroke(255);
    }
  }

  @Override
  public void update() {

    // perform entity behaviour
    entityBehaviour();
    
    // render this object each frame using the main camera
    render(mainCamera);
  }
  
  /**
    Performs this entity's unique behaviour.
    Will be overridden in subclasses.
  */
  public void entityBehaviour() {
    
  }

  /**
   Makes a copy of this entity with the given position, rotation, scale
   Will be overridden in subclasses if necessary
   */
  public Entity copyOf(PVector pos, Quaternion rot, PVector sc) {

    Entity e = new Entity(pos, rot, sc, shapeTemplate, entityType, true);

    return e;
  }
  
  /**
   Checks & handles collisions between this entity and other entities.
   The only important checks that will occur are:
   1. player checking enemies
   2. player checking enemy shots
   3. enemy checking player shots
   */
  @Override
    public void checkCollision(RenderObject other) {

    // if we're the player, only check collisions with enemies and enemy shots
    if (entityType == 0) {
    //  if (other.entityType == 2 || other.entityType == 1) {

    //    // since we're only checking spherical hitboxes, a hit is registered when the distance between the two entities is smaller
    //    // than or equal to the sum of their hitsphere radii
    //    float d = dist(position.x, position.y, position.z, other.position.x, other.position.y, other.position.z);
    //    float hsModified = hitSphereRadius * scale.x;
    //    float otherHSModified = other.hitSphereRadius * other.scale.x;

    //    if (d < hsModified + otherHSModified) {
    //      takeDamage(1);
    //    }
    //  }
    }
    else if (entityType == 2) {

      // TODO: check collision w/ magic missiles and such things
    }
  }
}
