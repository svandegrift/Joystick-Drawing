import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Joystick_Constant_Moving_Attempt extends PApplet {

PGraphics pg;
PFont f;

 // Imports Processing
Serial myPort;  // Creates port for Processing


float[] serialInArray = new float[3]; // Where we'll put what we receive
int serialCount = 0;     // A count of how many bytes we receive
float xpos, ypos;     // Starting position of the sketch
float refresh;
boolean firstContact = false;  // Whether we've heard from processing
float xmoving, ymoving, start;


public void setup() {
   // Stage size
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
  textAlign(CENTER);
  fill(0);
  text("LOADING...", width/2, height/2);
}
public void draw() {

  if (start == 0) {

    delay(2000);
    background(255);
    start++;
  }
  fill(255);
  ellipse(xmoving, ymoving, 10, 10);
  if (xpos < 127) {
    xmoving-=5;
  } else if (xpos > 127) {
    xmoving+=5; // x Going Down
  } else if (ypos > 122) {
    ymoving+=5; // Y going down
  } else if (ypos < 121) {
    ymoving-=5;
  }
  if (xpos < 127 && ypos < 121) {
    xmoving-=3;
    ymoving-=3;
  }else if (xpos > 127 && ypos > 122) {
    xmoving+=3;
    ymoving+=3;
  }else if (xpos < 127 && ypos > 122) {
    xmoving-=3;
    ymoving+=3;
  }
  else if (xpos > 127 && ypos < 121) {
    xmoving+=3;
    ymoving-=3;
  }
}
public void serialEvent(Serial myPort) {
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
    if (serialCount >= 2 ) {
      xpos = serialInArray[0]; // 127 is Middle
      ypos = serialInArray[1]; // 121 is Middle
      //xpos = map(serialInArray[0], 0, 1000, 0, 1000);
      //ypos = map(serialInArray[1], 0, 1000, 0, 1000);
      // print the values (for debugging purposes only):
      println(xpos + " " + ypos + " ");
      // Send a capital A to request new sensor readings:
      myPort.write('A');
      // Reset serialCount:
      serialCount = 0;
    }
  }
}
public void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
public void keyPressed() {
  if (key == 'r') {
    saveFrame("pic-####.png");
    delay(300);
    background(255);
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Joystick_Constant_Moving_Attempt" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
