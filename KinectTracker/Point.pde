class Point {
   float X;
   float Y;
   float w;
   float velocityX;
   float velocityY;
   float previousX;
   float previousY;

   Point() {
      X=mouseX;
      Y=mouseY;
      w = random(1 / thresholdPoint, thresholdPoint);
   }

   void render() {
      velocityX /= spifac;
      velocityY /= spifac;
      velocityX += (currentX - X) * w * drag;
      velocityY += (currentY - Y) * w * drag;
      point(X,Y);
      X += velocityX;
      Y += velocityY;
      stroke(0,0,0,150);
      point(X,Y);
      point(previousX, previousY);
      previousX = X;
      previousY = Y;
      //add point to particle system with random type
      particle.add(new Particles(new PVector(X,Y),new PVector(random(-2,2),random(-2,2)),(int)random(0,2)));
   }
}
