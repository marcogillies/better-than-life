
class MousePoint
{
  PVector p;
  PVector vel;
  float angle;
  PVector [] offsets;
  
  MousePoint()
  {
  //  this(int(random(0, width)), int(random(0, height)));
  //}
  
  //MousePoint (int x, int y)
  //{
    p = new PVector (int(random(0, width)), int(random(0, height)));
    //vel = PVector.random2D();
    vel = new PVector (random(-1,1), random(-1, 1));
    //println(vel.x + " " + vel.y);
//    vel.mult(random(0, 4));
    angle = radians(random(0, 360));
    offsets = new PVector [6];
    for (int i = 0; i < offsets.length; i++)
    {
      offsets[i] = new PVector(random(-0.5, 0.5), random(-0.5, 0.5));
      //offsets[i] = PVector.random2D();
      //offsets[i].mult(random(0.2, 0.5));
    }
  }
  
  void update()
  {
    PVector vChange = new PVector(random(-0.5, 0.5), random(-0.5, 0.5));
    //vChange.mult(random(0, 0.5));
    //println("change " + vChange.x + " " + vChange.y);
    vel.add(vChange);
    vel.limit(5);
    //println(vel.x + " " + vel.y);
    p.add(vel);
    if(p.x > width)
      p.x = 0;
    if(p.x < 0)
      p.x = width;
    if(p.y > height)
      p.y = 0;
    if(p.y < 0)
      p.y = height;
  }
  
  void draw()
  {
    
    drawer.draw(this);
  }

}
