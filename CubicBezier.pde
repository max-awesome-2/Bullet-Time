
/**
 Defines a  cubic Bezier curve with two control points.
 Referenced https://morethandev.hashnode.dev/demystifying-the-cubic-bezier-function-ft-javascript
 */

class CubicBezier {

  // the coordinates of each of the two control points
  private PVector c1, c2;

  public CubicBezier(float x1, float y1, float x2, float y2) {

    c1 = new PVector(x1, y1);
    c2 = new PVector(x2, y2);
  }

  /**
   Returns the y value given an x value between 0 and 1
   */
  public float getY(float t) {
    return
      vectorAdd(
      vectorAdd
      (
      vectorScale( c1, (3 * (1 - t) * (1 -  t) * t)),
      vectorScale( c2, (3 * (1 - t) * t * t))
      ),
      vectorScale(one, t * t * t)
      ).y;
  }
}
