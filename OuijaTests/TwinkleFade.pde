class TwinkleFadeDrawer extends PointDrawer
{
   Slider sizeSlider;
   Slider opacitySlider;
  
   TwinkleFadeDrawer()
   {
     sizeSlider = new Slider("size", 20, 0, 50, 10, 50, 200, 10, HORIZONTAL);
     opacitySlider = new Slider("opacity", 10, 0, 255, 10, 70, 200, 10, HORIZONTAL);
   }
  
   void drawGUI()
   {
     sizeSlider.display();
     opacitySlider.display();
   }
  
   void draw(MousePoint p)
   {
     pushStyle();
     fill(255, 255, 255, random(0.4, 1.0)*opacitySlider.get());
     noStroke();
     for(int i = 0; i < sizeSlider.get(); i++)
       ellipse(p.p.x, p.p.y, i, i);
     popStyle();
   } 
   
   void mousePressed()
   {
     sizeSlider.mousePressed();
     opacitySlider.mousePressed();
   }
   
   void mouseDragged()
   {
     sizeSlider.mouseDragged();
     opacitySlider.mouseDragged();
   }
   
   void mouseReleased()
   {
     sizeSlider.mouseReleased();
     opacitySlider.mouseReleased();
   }
}
