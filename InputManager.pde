/*
  This class handles the collection of input from the two controllers,
 the Mage Hand and the Orb of Foreversight.
 This code could all technically just be in mage_hand, but keeping it
 sequestered like this makes things neater.
 */

GatedArrayList<SerialController> controllers;

public void setupControllers() {

  // for now, just set COM port names in the code
  // later, add automatic polling of each COM port in order to auto-detect controllers
  
  controllers = new GatedArrayList<SerialController>();

  SerialController orb = new SerialController("ORB OF FOREVERSIGHT", "COM6");
  SerialController hand = new SerialController("MAGE HAND", "COM8");
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
}
