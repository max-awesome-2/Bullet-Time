
class Camera extends WorldObject {

  public float FOV;

  public boolean perspective;

  public Camera(PVector pos, Quaternion rot, PVector sc, float fov, boolean persp) {
    super(pos, rot, sc, false);
    FOV = fov;
    perspective = persp;
  }
}
