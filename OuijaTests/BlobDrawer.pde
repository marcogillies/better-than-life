class BlobDrawer extends PointDrawer
{
   Slider sizeSlider;
   Slider opacitySlider;
  
   BlobDrawer()
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
     fill(255, 255, 255, opacitySlider.get());
     noStroke();
     for(PVector offset : p.offsets)
     {
       //int x = int(p.p.x+offset.x*sizeSlider.get());
       //int y = int(p.p.y+offset.y*sizeSlider.get());
       int x = int(p.p.x + (noise(p.p.x/100, offset.x, millis()/1000.0)+0.5)*4.0*sizeSlider.get());
       int y = int(p.p.y + (noise(p.p.y/100, offset.y, millis()/1000.0)+0.5)*4.0*sizeSlider.get());
       for(int i = 0; i < sizeSlider.get(); i++)
         ellipse(x, y, i, i);
       //PVector change = PVector.random2D();
       //change.mult(0.03);
       PVector change = new PVector(-0.03, 0.03);
       offset.add(change);
       offset.limit(1.0);
     }
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
