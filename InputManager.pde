/*
  Handles collection of input from the controller.
 */

GatedArrayList<SerialController> controllers;

public void setupController() {

  // for now, just set COM port names in the code
  // later, add automatic polling of each COM port in order to auto-detect controllers

  controllers = new GatedArrayList<SerialController>();

  SerialController hand = new SerialController("Stick Guy", "COM6");
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

  if (split.length > 3 && split[0].equals("quat")) {
    float comp1 = Float.parseFloat(split[1]),
      comp2 = Float.parseFloat(split[2]),
      comp3 = Float.parseFloat(split[3]),
      comp4 = Float.parseFloat(split[4]);


    testCube.setRotation(new Quaternion(comp1, comp2, comp4, -comp3));
  }
}
