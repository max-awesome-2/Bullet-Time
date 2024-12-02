
import processing.serial.*;

/*
  Represents a serial port connection to a custom controller.
 */
class SerialController {

  String controllerName;

  String portName;

  Serial port;

  long lastMessageTime;

  public SerialController(String cName, String pName) {
    controllerName = cName;
    portName = pName;

    // initialize this controller
    initialize();

    // add to list of controllers
    controllers.add(this);
  }

  public void initialize() {

    // for now, just set COM port names in the code
    // later, add automatic polling of each COM port in order to auto-detect controllers

    boolean portFound = false;
    String[] allPorts = Serial.list();
    for (String s : allPorts) {
      if (s.equals(portName)) {
        portFound = true;
      }
    }

    if (portFound) {
      try {

        port = new Serial(mainApplet, portName, 115200);

        lastMessageTime = millis();

        initPort();
      }
      catch (Exception e) {
        println("Error in setting up port: " + e.getMessage());
        port = null;
      }
    } else {
      println("WARNING: port " + portName + " (designated for " + controllerName + ") not found.");
    }
    
    if (port != null)
      println(controllerName + ": port " + portName + " initialized successfully!");
  }

  private void initPort() {
    // write the single character to trigger DMP init / start (from MPU6050_DMP6 example sketch)
    port.write('r');
    // flush first port reading
    port.readStringUntil(10);
  }

  public void poll() {

    if (port == null) return;

    if (millis() - lastMessageTime > 1000) {
      // resend single character to trigger DMP init/start
      // in case the MPU is halted/reset while applet is running
      port.write('r');
      port.readStringUntil(10);
      lastMessageTime = millis();
    }

    // if port is available, read all messages from it
    while (port.available() > 0) {
      
      lastMessageTime = millis();

      // read until a newline
      String s = port.readStringUntil(10);
      if (s != null) {
        serialMessageReceived(s);
      }
    }
  }
}
