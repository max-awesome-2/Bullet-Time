/*
  Handles collection of input from the controller.
 */

GatedArrayList<SerialController> controllers;

// calibration variables
boolean gotFirstReading = false;
Quaternion multInverse;

public void setupController() {

  // for now, just set COM port names in the code
  // later, add automatic polling of each COM port in order to auto-detect controllers

  controllers = new GatedArrayList<SerialController>();
  
  SerialController bill = new SerialController("Bill Bullet", "COM7");
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
  //println("received serial message: " + msg);

  String[] split = msg.split("\t");
  try {

    // receive the quaternion message from the gyroscope, and break it into its component parts
    if (split.length == 5 && split[0].equals("quat")) {
      float comp1 = Float.parseFloat(split[1]),
        comp2 = Float.parseFloat(split[2]),
        comp3 = Float.parseFloat(split[3]),
        comp4 = Float.parseFloat(split[4]);

      Quaternion reading = new Quaternion(comp1, comp3, -comp2, comp4);

      if (!gotFirstReading) {
        gotFirstReading = true;

        // assumes that the player is holding Bill upright and forward at the time of the first reading
        // calculate and store the multiplicative inverse, which will be used as a 'calibration' value to relate all incoming readings to the neutral pose

        multInverse = reading.getMultiplicativeInverse(identity);
      }

      if (gameState != 2) player.setRotation(reading.multiply(multInverse));
    }
  }
  catch (Exception e) {
    // don't crash if there's an error with this parse attempt - just wait for the next one
  }
}
