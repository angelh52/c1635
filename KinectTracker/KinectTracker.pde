//Author: WenChi Huang
//Project Description: Hand/waist detection with Kinect Sensor and draw particle system with DLA
import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import fingertracker.*;

Kinect kinect;
FingerTracker fingers;

//set thresholds for finger tracker and body
int threshold = 625;
int thresholdBody = 745;

ArrayList particle;
int num = 20;
Point bodies[] = new Point[num];

float currentX;
float currentY;
float theta;
float thresholdBall = 5;
float spifac = 1.05;
float drag = 0.01;


void setup() {
   size(displayWidth, displayHeight);
   background(255);
   strokeWeight(1);
   smooth();

   //initialize kinect sensor
   kinect = new Kinect(this);
   kinect.initDepth();
   kinect.enableMirror(true);

   //initialize particle
   particle=new ArrayList();
   //initialize ball
   for(int i = 0; i < num; i++) {
      bodies[i] = new Point();
   }

   //initialize finger tracker
   fingers = new FingerTracker(this, 640, 480);
   fingers.setMeltFactor(100);
}

void draw() {
   // get and show depthImage
   PImage depthImage = kinect.getDepthImage();
   //image(depthImage, 0, 0);

   // update the depth threshold for finger tracker
   fingers.setThreshold(threshold);
   int[] depthMap = kinect.getRawDepth();
   fingers.update(depthMap);

   //get average point of body
   PVector avg= new PVector(0,0);
   float sumX = 0;
   float sumY = 0;
   float count = 0;

   for (int x = 0; x < kinect.width; x++) {
      for (int y = 0; y < kinect.height; y++) {
         int offset =  x + y*kinect.width;
         int rawDepth = depthMap[offset];
         if (rawDepth < thresholdBody) {
            sumX += x;
            sumY += y;
            count++;
         }
      }
   }

   //if found
   if (count != 0) {
      avg = new PVector(sumX/count, sumY/count);
   }

   //map points to fullscreen
   float avgposX=map(avg.x,0,640,0,width);
   float avgposY=map(avg.y,0,480,0,height);
   
   //get one finger and map points to fullscreen
   PVector position = fingers.getFinger(0);
   float posX=map(position.x,0,640,0,width);
   float posY=map(position.y,0,480,0,height);

   //calculate angle between finger and average point
   theta = PVector.angleBetween(new PVector(posX-avgposX,posY-avgposY,0.0),new PVector(0,avgposY-height,0.0));


   //println(degrees(theta));
   //check angle and correspond to different particle type
   if (degrees(theta)<degrees(120)) particle.add(new Particles(new PVector(posX,posY),new PVector(random(-1,1),random(-1,1)),0));
   if (degrees(theta)>=degrees(120) && degrees(theta)<degrees(240)) particle.add(new Particles(new PVector(posX,posY),new PVector(random(-1,1),random(-1,1)),1));
   if (degrees(theta)>degrees(240)) particle.add(new Particles(new PVector(posX,posY),new PVector(random(-1,1),random(-1,1)),2));

   //draw DLA
   branch(posX,posY);

   //restart if motion out of detection bound
   if (avgposX<200 || avgposX >1200)
   {
      background(255);
      for(int i=0;i<particle.size();i++){
         particle.remove(i);
      }
   }
}

void branch(float x,float y){
   //render point system
   currentX += 0.3 * (x - currentX);
   currentY += 0.3 * (y - currentY);
   for(int i = 0; i < num; i++) {
      bodies[i].render();
   }

   //render DLA 
   for(int i=0;i<particle.size();i++){
      Particles c=(Particles) particle.get(i);
      c.checkHit();
      if(c.stick==false){
         particle.remove(i);
      }
   else{
      c.display();
      c.move();
      c.giveBirth();
   }
}
}
