/**
 A Shape is an instance of a ShapeTemplate. It maps the local vertices of a ShapeTemplate to an Entity given that entity's position / rotation relative to the camera, etc.
 */
public class Shape {

  public PVector[] worldVertices;

  public PVector[] cameraVertices;

  public ShapeTemplate template;

  public Shape(ShapeTemplate t) {
    template = t;

    worldVertices = new PVector[t.vertices.length];

    cameraVertices = new PVector[t.vertices.length];
    for (int i = 0; i < t.vertices.length; i++) {
      worldVertices[i] = t.vertices[i];
      cameraVertices[i] = t.vertices[i];
    }
  }

  public void setWorldVertices(PVector worldPos, Quaternion rotation, PVector scale) {

    for (int i = 0; i < template.vertices.length; i++) {

      // apply scale
      PVector vModified = vectorScaleByVector(template.vertices[i], scale);

      // apply rotation
      vModified = rotatePointAround(vModified, zero, rotation);

      // apply position
      vModified = vectorAdd(vModified, worldPos);

      worldVertices[i] = vModified;
    }
  }

  /**
   Moves this shape's center to the given world position, then projects those vertices onto
   2D space with the given camera, saving the projected vertices to worldVertices
   */
  public void setCameraVertices(Camera c) {

    for (int i = 0; i < template.vertices.length; i++) {

      cameraVertices[i] = projectPoint(worldVertices[i], c);
    }
  }
}
