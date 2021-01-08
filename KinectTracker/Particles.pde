//DLA
class Particles{
   PVector position,direction,velocity;
   float x,y,var,frame;
   int time, type;
   boolean stick;

   Particles(PVector pos_, PVector dir_, int type_){
      position=pos_;
      x=position.x;
      y=position.y;
      direction=dir_;
      type=type_;

      //different type correspond to different dir variable
      switch(type) {
         case 0:
         var=random(0.01,0.1);
         frame=round(random(0,60));
         break;
         case 1:
         var=random(0.1,1);
         frame=round(random(10,50));
         break;
         case 2:
         var=random(1,2);
         frame=round(random(20,40));
      }

      velocity=new PVector(random(-var,var),random(-var,var));
      //set seed point
      stick=true;
      time=0;
   }

   void checkHit(){
      if(red(get(round(position.x),round(position.y)))<255)
      stick=false;
   }

   void display(){
      color[]  userClr = new color[]{ color(45,133,166),
      color(101,38,155),
      color(101,249,253),
      color(68,74,150),
      color(83,183,225),
      color(104,127,220)
   };
   if(stick){
      stroke(userClr[(int)random(0,6)]);
      point(round(x),round(y));

   }

}

void move(){
   //if stick add random direction and givebirth to new point
   if(stick){
      x=position.x;
      y=position.y;
      direction.add(velocity);
      direction.normalize();
      position.add(direction);
      time++;
   }
}

void giveBirth(){
   //generate new point of the same type
   if(time%frame==1){
      if(type==0)particle.add(new Particles(new PVector(x+random(-2,2),y+random(-2,2)),new PVector(random(-2,2),random(-2,2)),0));
      if(type==1)particle.add(new Particles(new PVector(x+random(-2,2),y+random(-2,2)),new PVector(random(-2,2),random(-2,2)),1));
      if(type==2)particle.add(new Particles(new PVector(x+random(-2,2),y+random(-2,2)),new PVector(random(-2,2),random(-2,2)),2));
   }
}

}
