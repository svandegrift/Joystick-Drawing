/// ORIGINAL ///
PGraphics pg;
PFont f;

import processing.serial.*; // Imports Processing
Serial myPort;  // Creates port for Processing


float[] serialInArray = new float[3]; // Where we'll put what we receive
int serialCount = 0;     // A count of how many bytes we receive
float xpos, ypos;     // Starting position of the sketch
float refresh;
boolean firstContact = false;  // Whether we've heard from processing
float xmoving, ymoving, start;


void setup() {
  fullScreen(); // Stage size 
  background(255);// No border on the next thing drawn
  println(Serial.list());
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  pg = createGraphics(255, 255);
  
}
void draw() {
  noFill();
  polygon((width/2)+(xpos-127)*5.65, (height/2)+(ypos-121)*3.7, 20, 8);
}
void serialEvent(Serial myPort) {
  int inByte = myPort.read();
  if (firstContact == false) {
    if (inByte == 'A') {
      myPort.clear();   
      firstContact = true;  
      myPort.write('A');
    }
  } else {
    serialInArray[serialCount] = inByte;
    serialCount++;
    if (serialCount > 2 ) {
      xpos = serialInArray[0]; // 127 is Middle
      ypos = serialInArray[1]; // 121 is Middle
      //xpos = map(serialInArray[0], 0, 1000, 0, 1000);
      //ypos = map(serialInArray[1], 0, 1000, 0, 1000);
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
void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
void keyPressed() {
  if (key == 'r') {
    background(255);
  }
}