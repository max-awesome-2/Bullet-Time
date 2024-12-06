
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
 and
 https://discussions.unity.com/t/what-is-the-source-code-of-quaternion-lookrotation/72474/3
 */
public Quaternion lookRotation(PVector forward, PVector up) {

  PVector vector = forward.normalize().copy();

  PVector vector2 = up.cross(vector);
  PVector vector3 = vector.cross(vector2);
  float m00 = vector2.x;
  float m01 = vector2.y;
  float m02 = vector2.z;
  float m10 = vector3.x;
  float m11 = vector3.y;
  float m12 = vector3.z;
  float m20 = vector.x;
  float m21 = vector.y;
  float m22 = vector.z;


  float num8 = (m00 + m11) + m22;
  Quaternion quaternion = identity.getCopy();
  if (num8 > 0f)
  {
    float num = sqrt(num8 + 1f);
    quaternion.w = num * 0.5f;
    num = 0.5f / num;
    quaternion.x = (m12 - m21) * num;
    quaternion.y = (m20 - m02) * num;
    quaternion.z = (m01 - m10) * num;
    return quaternion;
  }
  if ((m00 >= m11) && (m00 >= m22))
  {
    float num7 = sqrt(((1f + m00) - m11) - m22);
    float num4 = 0.5f / num7;
    quaternion.x = 0.5f * num7;
    quaternion.y = (m01 + m10) * num4;
    quaternion.z = (m02 + m20) * num4;
    quaternion.w = (m12 - m21) * num4;
    return quaternion;
  }
  if (m11 > m22)
  {
    float num6 = sqrt(((1f + m11) - m00) - m22);
    float num3 = 0.5f / num6;
    quaternion.x = (m10+ m01) * num3;
    quaternion.y = 0.5f * num6;
    quaternion.z = (m21 + m12) * num3;
    quaternion.w = (m20 - m02) * num3;
    return quaternion;
  }

  float num5 = sqrt(((1f + m22) - m00) - m11);
  float num2 = 0.5f / num5;
  quaternion.x = (m20 + m02) * num2;
  quaternion.y = (m21 + m12) * num2;
  quaternion.z = 0.5f * num5;
  quaternion.w = (m01 - m10) * num2;

  return quaternion;
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
    pz * pz - 2 * pz * cz + cz * cz - radius * radius;

  // discriminant
  float D = B * B - 4 * A * C;

  // if discriminant is below 0, there is no intersection
  return (!(D < 0));
}

/**
 Returns an arbitrary vector perpendicular for the given vector.
 Referenced https://stackoverflow.com/questions/41275311/a-good-way-to-find-a-vector-perpendicular-to-another-vector
 */
public PVector getArbitraryPerpendicular(PVector a) {

  PVector b;

  // make b a vector that is guaranteed to not be colinear
  if (a.x != 0 && a.y == 0 && a.z == 0) {
    b = new PVector(0, 1, 0);
  } else {
    b = new PVector(1, 0, 0);
  }

  return b.cross(a);
}

public Quaternion lookRotationArbitrary(PVector forward) {
  return lookRotation(forward, getArbitraryPerpendicular(forward));
}
// referenced https://www.gamedev.net/forums/topic/628444-collision-detection-between-non-axis-aligned-rectangular-prisms/
// for these two function
///////////////////////////////////////////////////////////////
/**
 Scalar project of a point on a normal.
 */
public float scalarProjection(PVector point, PVector normal) {
  return point.dot(normal) / normal.dot(normal);
}

/**
 Returns a 2-dimensional PVector representing a range (of form min, max).
 */
public PVector projectPrism(BoundingPrism p, PVector normal) {

  PVector result = new PVector(0, 0);

  PVector[] vertices = p.shapes.get(0).worldVertices;
  PVector vertex;
  for (int i = 0; i < vertices.length; i++) {

    vertex = vertices[i];

    float scalar = scalarProjection(vertex, normal);

    if (i == 0) {
      result.x = scalar;
      result.y = scalar;
    } else if (scalar > result.y) {
      result.y = scalar;
    } else if (scalar < result.x) {
      result.x = scalar;
    }
  }

  return result;
}
///////////////////////////////////////////////////////////////

/**
 Returns true if the two given ranges intersect, false if not.
 */
public boolean rangeIntersects(PVector rangeA, PVector rangeB) {
  return (max(rangeA.x, rangeB.x) <= min(rangeA.y, rangeB.y));
}
