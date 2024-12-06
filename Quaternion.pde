
/**
 I don't actually know how quaternions work.
 The code in this class is adapted from https://gist.github.com/halfninja/572585
 */
public class Quaternion {

  public float x, y, z, w;

  public Quaternion(float degs, PVector axis) {
    setAngleAxis(degs, axis);
  }

  public Quaternion(float wC, float xC, float yC, float zC) {
    setComponents(wC, xC, yC, zC);
  }

  public Quaternion setRandom() {
    setComponents(random(1), random(1), random(1), random(1));
    return getNormalized();
  }

  public Quaternion setComponents(float wC, float xC, float yC, float zC) {
    x = xC;
    y = yC;
    z = zC;
    w = wC;

    return this;
  }

  private void setAngleAxis(float degs, PVector axis) {
    float a = degs * DEG2RAD;
    float s = sin(a / 2);
    w = cos(a / 2);
    x = axis.x * s;
    y = axis.y * s;
    z = axis.z * s;
  }

  public Quaternion multiply(Quaternion q) {

    float nw = w * q.w - x * q.x - y * q.y - z * q.z;
    float nx = w * q.x + x * q.w + y * q.z - z * q.y;
    float ny = w * q.y + y * q.w + z * q.x - x * q.z;
    z = w * q.z + z * q.w + x * q.y - y * q.x;
    w = nw;
    x = nx;
    y = ny;

    return this;
  }

  public Quaternion getConjugate() {
    Quaternion q = new Quaternion(0, zero);
    return q.setComponents(w, -x, -y, -z);
  }

  public Quaternion getNormalized() {
    Quaternion q = new Quaternion(0, zero);
    return q.setComponents(w, x, y, z).qScale(1 / getMagnitude());
  }

  public float getMagnitude() {
    return  sqrt(w * w + x * x + y * y + z * z);
  }

  public Quaternion qScale(float s) {
    w *= s;
    x *= s;
    y *= s;
    z *= s;

    return this;
  }

  /**
   Returns a copy of this Quaternion.
   */
  public Quaternion getCopy() {

    Quaternion q = new Quaternion(0, zero);

    return q.setComponents(w, x, y, z);
  }

  /**
   Returns the dot product of this Quaternion with another given Quaternion q. Used in the lerp method defined below.
   */
  public float getDotProduct(Quaternion q) {
    return x * q.x + y * q.y + z * q.z + w * q.w;
  }

  /**
   Linearly interpolates this quaternion towards another given quaternion by the given value.
   */
  public void lerpTowards(Quaternion to, float by) {

    if (equalsOther(to)) return;

    float d = getDotProduct(to);
    float qx, qy, qz, qw;

    if (d < 0) {
      qx = -to.x;
      qy = -to.y;
      qz = -to.z;
      qw = -to.w;
      d = -d;
    } else {
      qx = to.x;
      qy = to.y;
      qz = to.z;
      qw = to.w;
    }

    float f0, f1;

    if ((1 - d) > 0.1) {
      float angle = acos(d);
      float s = sin(angle);
      float tAngle = by * angle;
      f0 = sin(angle - tAngle) / s;
      f1 = sin(tAngle) / s;
    } else {
      f0 = 1 - by;
      f1 = by;
    }


    setComponents(
      f0 * w + f1 * qw,
      f0 * x + f1 * qx,
      f0 * y + f1 * qy,
      f0 * z + f1 * qz
      );
  }

  public boolean equalsOther(Quaternion q) {
    return x == q.x && y == q.y && z == q.z && w == q.w;
  }

  public String toString() {
    return "Quaternion(" + w + ", " + x + ", " + y + ", " + z + ")";
  }

  /**
   Takes a length 16 float array as input; converts this Quaternion into a rotation matrix and stores it in the given array.
   This matrix can then be used with applyMatrix() to rotate the P3D camera.
   */
  public void toMatrix(float[] matrix) {
    matrix[3] = 0.0f;
    matrix[7] = 0.0f;
    matrix[11] = 0.0f;
    matrix[12] = 0.0f;
    matrix[13] = 0.0f;
    matrix[14] = 0.0f;
    matrix[15] = 1.0f;

    matrix[0] = (float) (1.0f - (2.0f * ((y * y) + (z * z))));
    matrix[1] = (float) (2.0f * ((x * y) - (z * w)));
    matrix[2] = (float) (2.0f * ((x * z) + (y * w)));

    matrix[4] = (float) (2.0f * ((x * y) + (z * w)));
    matrix[5] = (float) (1.0f - (2.0f * ((x * x) + (z * z))));
    matrix[6] = (float) (2.0f * ((y * z) - (x * w)));

    matrix[8] = (float) (2.0f * ((x * z) - (y * w)));
    matrix[9] = (float) (2.0f * ((y * z) + (x * w)));
    matrix[10] = (float) (1.0f - (2.0f * ((x * x) + (y * y))));
  }

  /**
   Returns a quaternion q such that this * q = b.
   */
  public Quaternion getMultiplicativeInverse(Quaternion b) {
    return b.getCopy().multiply(getConjugate());
  }
}
