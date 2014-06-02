class TriangleDrawer extends PointDrawer
{
   Slider sizeSlider;
  
   TriangleDrawer()
   {
     sizeSlider = new Slider("size", 5, 0, 50, 10, 50, 200, 10, HORIZONTAL);
   }
  
   void drawGUI()
   {
     sizeSlider.display();
   }
  
   void draw(MousePoint p)
   {
     pushStyle();
     stroke(255);
     strokeWeight(2);
     //noStroke();
     //fill(255, 0, 0);
     noFill();
     pushMatrix();
     translate(p.p.x, p.p.y);
     rotate(p.angle);
     scale(sizeSlider.get()/10.0);
     triangle(0, -10, -7, 7, 7, 7);
     popMatrix();
     popStyle();
     p.angle += 0.1;
   } 
   
   void mousePressed()
   {
     sizeSlider.mousePressed();
   }
   
   void mouseDragged()
   {
     sizeSlider.mouseDragged();
   }
   
   void mouseReleased()
   {
     sizeSlider.mouseReleased();
   }
}
