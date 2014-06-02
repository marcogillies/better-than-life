class AlphaDrawer extends PointDrawer
{
   Slider sizeSlider;
   Slider opacitySlider;
  
   AlphaDrawer()
   {
     sizeSlider = new Slider("size", 10, 0, 50, 10, 50, 200, 10, HORIZONTAL);
     opacitySlider = new Slider("opacity", 100, 0, 255, 10, 70, 200, 10, HORIZONTAL);
   }
  
   void drawGUI()
   {
     sizeSlider.display();
     opacitySlider.display();
   }
  
   void draw(MousePoint p)
   {
     pushStyle();
     fill(255, 255, 255, opacitySlider.get());
     noStroke();
     ellipse(p.p.x, p.p.y, sizeSlider.get(), sizeSlider.get());
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
