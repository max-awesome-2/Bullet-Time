/**
 Represents a object made of vertices, lines and triangles
 */
public class ShapeTemplate {

  // this array stores vertex positions
  public PVector[] vertices;

  // this array stores pairs of vertex indices between which lines should be drawn
  public int[] lines;

  // stores vertex indices - every 3 indicates one triangle
  public int[] tris;

  // TO ADD: two more lists, one of color indices for each line, another list of colors that those indices would reference
  // (this would let you choose which color to make each line)

  public ShapeTemplate(PVector[] vs, int[] lns, int[] trs) {
    vertices = vs;
    lines = lns;
    tris = trs;
  }
}
