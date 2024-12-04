
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

/**
 Implemented based on
 https://math.stackexchange.com/questions/3140136/how-to-create-a-quaternion-rotation-from-a-forward-and-up-vector
 and
 https://stackoverflow.com/questions/52413464/look-at-quaternion-using-up-vector
 */
public Quaternion lookRotation(PVector forward, PVector up) {
  PVector left = forward.cross(up);

  float[][] m = new float[3][];
  for (int i = 0; i < 3; i++) {
    m[i] = new float[3];
  }

  m[0][0] = forward.x;
  m[1][0] = forward.y;
  m[2][0] = forward.z;
  m[0][1] = left.x;
  m[1][1] = left.y;
  m[2][1] = left.z;
  m[0][2] = up.x;
  m[1][2] = up.y;
  m[2][2] = up.z;

  // return quaternion
  Quaternion q = identity.getCopy();
  
  float trace = m[0][0] + m[1][1] + m[2][2];

  if ( trace > 0 ) {
    float s = 0.5f / sqrt(trace + 1.0f);
    q.w = 0.25f / s;
    q.x = ( m[2][1] - m[1][2] ) * s;
    q.y = ( m[0][2] - m[2][0] ) * s;
    q.z = ( m[1][0] - m[0][1] ) * s;
  } else {
    if ( m[0][0] > m[1][1] && m[0][0] > m[2][2] ) {
      float s = 2.0f * sqrt( 1.0f + m[0][0] - m[1][1] - m[2][2]);
      q.w = (m[2][1] - m[1][2] ) / s;
      q.x = 0.25f * s;
      q.y = (m[0][1] + m[1][0] ) / s;
      q.z = (m[0][2] + m[2][0] ) / s;
    } else if (m[1][1] > m[2][2]) {
      float s = 2.0f * sqrt( 1.0f + m[1][1] - m[0][0] - m[2][2]);
      q.w = (m[0][2] - m[2][0] ) / s;
      q.x = (m[0][1] + m[1][0] ) / s;
      q.y = 0.25f * s;
      q.z = (m[1][2] + m[2][1] ) / s;
    } else {
      float s = 2.0f * sqrt( 1.0f + m[2][2] - m[0][0] - m[1][1] );
      q.w = (m[1][0] - m[0][1] ) / s;
      q.x = (m[0][2] + m[2][0] ) / s;
      q.y = (m[1][2] + m[2][1] ) / s;
      q.z = 0.25f * s;
    }
  }
  
  return q;
}

/**
  Returns true if the given line segment intersects a sphere with the given position and radius, false otherwise.
  I referenced https://stackoverflow.com/questions/5883169/intersection-between-a-line-and-a-sphere   for this algorithm.
*/
public boolean lineIntersectsSphere(PVector lineStart, PVector lineEnd, float cx, float cy, float cz, float radius) {
  

    float px = lineStart.x,
      py = lineStart.y,
      pz = lineStart.z;

    float vx = lineEnd.x - px,
      vy = lineEnd.y - py,
      vz = lineEnd.z - pz;

    float A = vx * vx + vy * vy + vz * vz;
    float B = 2.0 * (px * vx + py * vy + pz * vz - vx * cx - vy * cy - vz * cz);
    float C = px * px - 2 * px * cx + cx * cx + py * py - 2 * py * cy + cy * cy +
      pz * pz - 2 * pz * cz + cz * cz - BULLET_TARGET_MIN_DISTANCE * BULLET_TARGET_MIN_DISTANCE;

    // discriminant
    float D = B * B - 4 * A * C;

    // if discriminant is below 0, there is no intersection
    return (!(D < 0));
}
