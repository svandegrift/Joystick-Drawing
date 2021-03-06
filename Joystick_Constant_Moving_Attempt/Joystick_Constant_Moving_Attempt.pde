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
  f = createFont("Helvectica", 64, true);
  xmoving = width/2;
  ymoving = height/2;
  start = 0;
  textSize(64);
  textFont(f);
  fill(0);
  text("LOADING...", width/2-100, height/2);
}
void draw() {

  if (start == 0) {

    delay(2000);
    background(255);
    start++;
  }
  fill(255);
  ellipse(xmoving, ymoving, 10, 10);
  /// MOVING STRAIGHT ///
  if (xpos < 127) {
    xmoving-=5; //Left
  } else if (xpos > 127) {
    xmoving+=5; //Right
  } else if (ypos > 122) {
    ymoving+=5;  //Down
  } else if (ypos < 122) {
    ymoving-=5;   
  }
  //// MOVING ANGLES //////
  if (xpos < 127 && ypos < 122) {
    xmoving-=3;
    ymoving-=3;
  }else if (xpos > 127 && ypos > 122) {
    xmoving+=3;
    ymoving+=3;
  }else if (xpos < 127 && ypos > 122) {
    xmoving-=3;
    ymoving+=3;
  }else if (xpos > 127 && ypos < 122){
    xmoving+=3;
    ymoving-=3;
  }
  ///// GOES OFF SCREEN ////
  if(xmoving > width){
  xmoving = 0;
  }
  if(xmoving < 0){
  xmoving = width;
  }
  if(ymoving > height){
  ymoving = 0;
  }
  if(ymoving < 0){
  ymoving = height;
  }
  ////SAVE BUTTON ////
  if(refresh == 0){
    saveFrame("pic-####.png");
    delay(100);
    background(255);
  }
}

//// GET ARDUINO INPUT ///////
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
      refresh = serialInArray[2];
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
    saveFrame("pic-####.png");
    delay(300);
    background(255);
  }
}