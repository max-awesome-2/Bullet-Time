
/**
 Adds two vectors together
 */
public PVector vectorAdd(PVector a, PVector b) {

  return new PVector(a.x + b.x, a.y + b.y, a.z + b.z);
}

/**
 Subtracts a vector from another
 */
public PVector vectorSubtract(PVector a, PVector b) {
  return new PVector(a.x - b.x, a.y - b.y, a.z - b.z);
}

/**
 Scales a vector by a specified float value
 */
public PVector vectorScale(PVector a, float by) {
  return new PVector(a.x * by, a.y * by, a.z * by);
}

/**
 Scales a vector by the values of another vector
 */
public PVector vectorScaleByVector(PVector a, PVector by) {
  return new PVector(a.x * by.x, a.y * by.y, a.z * by.z);
}

// saved rotation variables - so these don't have to be recalculated every iteration during rotation
Quaternion unitRotation, rotationConjugate;

/**
 Given a point, pivot point, and rotation (in eulers), performs the rotation with quaternions
 */
public PVector rotatePointAround(PVector point, PVector pivot, Quaternion rotation) {

  // subtract the pivot and rotate the resulting point around (0, 0)
  PVector pointAroundOrigin = vectorSubtract(point, pivot);

  // do sandwich multiplication - q * p * q'
  PVector rotatedPoint = rotateVector(pointAroundOrigin, rotation);

  // add the pivot back to the rotated point and return
  return  vectorAdd(
    rotatedPoint,
    pivot);
}

/**
 Rotates a given point or direction vector around (0, 0, 0).
 Rotation is performed by multiplying the given rotation with the point, then with the rotation's inverse / conjugate
 (adapted from this stackexchange response: https://gamedev.stackexchange.com/questions/188762/understanding-how-to-use-quaternion-to-rotate-object)
 */
public PVector rotateVector(PVector v, Quaternion rotation) {
  Quaternion p = new Quaternion(0, zero);
  p.setComponents(0, v.x, v.y, v.z);
  Quaternion q = rotation.getNormalized(),
    qPrime = rotation.getConjugate(),
    pPrime = q.multiply(p.multiply(qPrime));

  return new PVector(pPrime.x, pPrime.y, pPrime.z);
}

/**
 Converts a given set of Euler angles from degrees to radians
 */
public PVector deg2rad(PVector eulers) {
  return vectorScale(eulers, DEG2RAD);
}

/**
 This function takes a given angle, in degrees, and returns a normalized vector on the XY plane pointing in that direction.
 */
public PVector angleToDirection(float zAngle) {
  float rads = zAngle * DEG2RAD;
  return new PVector(sin(rads), cos(rads));
}

/**
 Uses the lerp function on each component to linearly interpolate between two vectors.
 */
public PVector vectorLerp(PVector a, PVector b, float by) {
  return new PVector(
    lerp(a.x, b.x, by),
    lerp(a.y, b.y, by),
    lerp(a.z, b.z, by)
    );
}

/**
 Moves the given float A towards another float B by a given value, ensuring that the result does not pass over B.
 */
public float moveTowards(float a, float b, float by) {

  if (a > b) {
    a -= by;
    return max(a, b);
  } else {
    a += by;
    return min(a, b);
  }
}

public PVector moveTowardsVector(PVector a, PVector b, float by) {
  return new PVector(
    moveTowards(a.x, b.x, by),
    moveTowards(a.y, b.y, by),
    moveTowards(a.z, b.z, by)
    );
}
