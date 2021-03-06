class CircleDrawer extends PointDrawer
{
   Slider sizeSlider;
  
   CircleDrawer()
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
     fill(255);
     noStroke();
     ellipse(p.p.x, p.p.y, sizeSlider.get(), sizeSlider.get());
     popStyle();
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
