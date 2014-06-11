class PulseDrawer 
{

  
   PulseDrawer()
   {
   }
  

  
   void draw(MousePoint p)
   {
     float s = sin(0.5*radians(360)*millis()/1000.0f);
     pushStyle();
     fill(255, 255, 255, (1.0+0.5*s)*10);
     noStroke();
     for(int i = 0; i < (1.0+0.5*s)*20; i++)
       ellipse(p.p.x, p.p.y, i, i);
     popStyle();
   } 
   

}
