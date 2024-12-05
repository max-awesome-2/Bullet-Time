/*
  Handles collection of input from the controller.
 */

GatedArrayList<SerialController> controllers;

public void setupController() {

  // for now, just set COM port names in the code
  // later, add automatic polling of each COM port in order to auto-detect controllers

  controllers = new GatedArrayList<SerialController>();

  SerialController hand = new SerialController("Bill Bullet", "COM6");
}

public void checkControllerInput() {

  // update gated list
  controllers.update();

  // poll all controllers
  for (SerialController sc : controllers) {
    sc.poll();
  }
}

public void serialMessageReceived(String msg) {
  println("received serial message: " + msg);

  String[] split = msg.split("\t");
  try {
    
    // receive the quaternion message from the gyroscope, and break it into its component parts
    if (split.length == 5 && split[0].equals("quat")) {
      float comp1 = Float.parseFloat(split[1]),
        comp2 = Float.parseFloat(split[2]),
        comp3 = Float.parseFloat(split[3]),
        comp4 = Float.parseFloat(split[4]);

      // set the player's rotation to the incoming quaternion
      player.setRotation(new Quaternion(comp1, -comp2, -comp4, -comp3));
    }
    catch (Exception e) {
      // don't crash if there's an error with this parse attempt - just wait for the next one
    }
  }
}
