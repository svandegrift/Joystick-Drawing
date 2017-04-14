PGraphics pg;

import processing.serial.*; // Imports Processing
Serial myPort;  // Creates port for Processing


float[] serialInArray = new float[3]; // Where we'll put what we receive
int serialCount = 0;     // A count of how many bytes we receive
float xpos, ypos;     // Starting position of the sketch
float refresh;
boolean firstContact = false;  // Whether we've heard from processing


void setup() {
  fullScreen(); // Stage size 
  background(255);// No border on the next thing drawn
  println(Serial.list());
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  pg = createGraphics(255, 255);
}
void draw() {
  
  fill(0);
  ellipse((width/2)+xpos-127, (height/2)+ypos-121, 5, 5);
  /*if(refresh == 0){
    background(255);
  }
  */
  
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
    if (serialCount > 2 ) {
      xpos = serialInArray[0];
      ypos = serialInArray[1];
      xpos = map(serialInArray[0], 0, 1000, 0, 1000);
      ypos = map(serialInArray[1], 0, 1000, 0, 1000);
      refresh = serialInArray[2];
      // print the values (for debugging purposes only):
      println(xpos + " " + ypos + " " + refresh);
      // Send a capital A to request new sensor readings:
      myPort.write('A');
      // Reset serialCount:
      serialCount = 0;
    }
  }
}