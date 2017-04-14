PGraphics pg;
// This example code is in the public domain.
import processing.serial.*;
int bgcolor;   // Background color
int fgcolor;   // Fill color
Serial myPort;      // The serial port
float[] serialInArray = new float[3]; // Where we'll put what we receive
int serialCount = 0;     // A count of how many bytes we receive
float xpos, ypos;     // Starting position of the ball
boolean firstContact = false;  // Whether we've heard from the
// microcontroller
void setup() {
  fullScreen(); // Stage size 
  background(255);// No border on the next thing drawn
  // Set the starting position of the ball (middle of the stage)
  pg = createGraphics(1920, 1080);

  // Print a list of the serial ports, for debugging purposes:
  println(Serial.list());
  
  // I know that the first port in the serial list on my mac
  // is always my FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
}
void draw() {
  fill(0);
  ellipse(xpos, ypos, 5, 5);
  delay(10);
}
void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller.
  // Otherwise, add the incoming byte to the array:
  if (firstContact == false) {
    if (inByte == 'A') {
      myPort.clear();   // clear the serial port buffer
      firstContact = true;  // you've had first contact from the microcontroller
      myPort.write('A');  // ask for more
    }
  } else {
    // Add the latest byte from the serial port to array:
    serialInArray[serialCount] = inByte;
    serialCount++;
    // If we have 3 bytes:
    if (serialCount >= 2 ) {
      xpos = serialInArray[0];
      ypos = serialInArray[1];
      xpos = map(serialInArray[0], 0, 255, 0, width);
      ypos = map(serialInArray[1], 0, 255, 0, height);
      //fgcolor = serialInArray[2];
      // print the values (for debugging purposes only):
      println(xpos + " " + ypos + " " + fgcolor);
      // Send a capital A to request new sensor readings:
      myPort.write('A');
      // Reset serialCount:
      serialCount = 0;
    }
  }
}