class MousePointerDrawer extends PointDrawer
{
   PImage img;
   Slider sizeSlider;
  
   MousePointerDrawer()
   {
     img = loadImage("mouse.png");
     sizeSlider = new Slider("size", 5, 0, 50, 10, 50, 200, 10, HORIZONTAL);
   }
  
   void drawGUI()
   {
     sizeSlider.display();
   }
  
   void draw(MousePoint p)
   {
     image(img, p.p.x, p.p.y, sizeSlider.get(),sizeSlider.get()*(10.0/6));
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
