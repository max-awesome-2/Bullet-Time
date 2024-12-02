
/**
 This class is just to group ease functions and ease curves together.
 (I referenced https://easings.net/# for these)
 */

public CubicBezier easeInSin = new CubicBezier(0.12, 0, 0.39, 0),
  easeOutSin = new CubicBezier(0.61, 1, 0.88, 1),
  easeInOutSin = new CubicBezier(0.37, 0, 0.63, 1);

public void InitEaseCurves() {
}

/**
 Taken from https://easings.net/#easeInElastic
 */
public float easeInElastic(float t) {

  return t == 0 ?
    0
    : (t == 1
    ? 1
    : -pow(2, 10 * t - 10) * sin((t * 10 - 10.75) * ((2 * PI) / 3)));
}

/**
 Taken from https://easings.net/#easeOutElastic
 */
public float easeOutElastic(float t) {

  return t == 0 ?
    0
    : (t == 1
    ? 1
    : pow(2, -10 * t) * sin((t * 10 - 0.75) * ((2 * PI) / 3)) + 1);
}
