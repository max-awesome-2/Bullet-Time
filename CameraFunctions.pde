/**
 This class contains functions having to do with the camera - e.g., projecting 3D points to 2D screen coordinates
 */

// the camera's near clipping plane
float nearClipping = 0.25;

/**
 Given a point in 3D space, project it into 2D space relative to the camera and return the projected point
 (also partially adapted from https://stackoverflow.com/questions/724219/how-to-convert-a-3d-point-into-2d-perspective-projection)
 */
public PVector projectPoint(PVector point, Camera c) {

  // first, transform the point by camera's position and rotation
  point = vectorSubtract(point, mainCamera.position);

  // rotate point by camera
  point = rotatePointAround(point, zero, mainCamera.rotation.getConjugate());

  // modify the point with camera FOV
  return new PVector(point.x * camFOV / point.z, point.y * camFOV / point.z);
}

/**
 Transforms a point relative to the camera's position and rotation.
 */
public PVector camTransformPoint(PVector point, Camera c) {
  return rotatePointAround(vectorSubtract(point, mainCamera.position), zero, mainCamera.rotation.getConjugate());
}

/**
 Returns the screen position of a point in 3D space relative to the camera's position and rotation.
 */
public PVector getScreenPosition(PVector point, Camera c) {
  PVector projected = projectPoint(point, c);
  return new PVector(projected.x * UNITS_TO_PIXELS + HALF_WIDTH, projected.y * UNITS_TO_PIXELS + HALF_WIDTH);
}
