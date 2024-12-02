/**
 This class contains the main functions that are used to draw shapes - lines & faces - to the screen.
 */


/**
 Draws a line between point A and point B
 Build in the + 200 needed to center points in the screen,
 because by default they're centered at (0, 0), which is
 in the top left corner
 */
public void drawLine(PVector a, PVector b) {

  line((a.x * UNITS_TO_PIXELS) + HALF_WIDTH, (a.y * UNITS_TO_PIXELS) + HALF_WIDTH, (b.x * UNITS_TO_PIXELS) + HALF_WIDTH, (b.y * UNITS_TO_PIXELS) + HALF_WIDTH);
}

/**
 Draws a triangle between the given 3 points
 */
public void drawTri(PVector v1, PVector v2, PVector v3) {
  quad(
    v1.x * UNITS_TO_PIXELS + HALF_WIDTH, v1.y * UNITS_TO_PIXELS + HALF_WIDTH,
    v1.x * UNITS_TO_PIXELS + HALF_WIDTH, v1.y * UNITS_TO_PIXELS + HALF_WIDTH,
    v2.x * UNITS_TO_PIXELS + HALF_WIDTH, v2.y * UNITS_TO_PIXELS + HALF_WIDTH,
    v3.x * UNITS_TO_PIXELS + HALF_WIDTH, v3.y * UNITS_TO_PIXELS + HALF_WIDTH
    );
}
