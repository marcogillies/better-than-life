class PulseDrawer extends PointDrawer
{
   Slider sizeSlider;
   Slider opacitySlider;
   Slider frequencySlider;
   Slider opacityAmplitudeSlider;
   Slider sizeAmplitudeSlider;
  
   PulseDrawer()
   {
     sizeSlider = new Slider("size", 20, 0, 50, 10, 50, 200, 10, HORIZONTAL);
     opacitySlider = new Slider("opacity", 10, 0, 255, 10, 70, 200, 10, HORIZONTAL);
     frequencySlider = new Slider("speed", 0.5, 0, 5, 10, 90, 200, 10, HORIZONTAL);
     opacityAmplitudeSlider = new Slider("speed", 0.5, 0, 5, 10, 110, 200, 10, HORIZONTAL);
     sizeAmplitudeSlider = new Slider("speed", 0.5, 0, 5, 10, 130, 200, 10, HORIZONTAL);
   }
  
   void drawGUI()
   {
     sizeSlider.display();
     opacitySlider.display();
     frequencySlider.display();
     opacityAmplitudeSlider.display();
     sizeAmplitudeSlider.display();
   }
  
   void draw(MousePoint p)
   {
     float s = sin(frequencySlider.get()*radians(360)*millis()/1000.0f);
     pushStyle();
     fill(255, 255, 255, (1.0+opacityAmplitudeSlider.get()*s)*opacitySlider.get());
     noStroke();
     for(int i = 0; i < (1.0+sizeAmplitudeSlider.get()*s)*sizeSlider.get(); i++)
       ellipse(p.p.x, p.p.y, i, i);
     popStyle();
   } 
   
   void mousePressed()
   {
     sizeSlider.mousePressed();
     opacitySlider.mousePressed();
     frequencySlider.mousePressed();
     opacityAmplitudeSlider.mousePressed();
     sizeAmplitudeSlider.mousePressed();
   }
   
   void mouseDragged()
   {
     sizeSlider.mouseDragged();
     opacitySlider.mouseDragged();
     frequencySlider.mouseDragged();
     opacityAmplitudeSlider.mouseDragged();
     sizeAmplitudeSlider.mouseDragged();
   }
   
   void mouseReleased()
   {
     sizeSlider.mouseReleased();
     opacitySlider.mouseReleased();
     frequencySlider.mouseReleased();
     opacityAmplitudeSlider.mouseReleased();
     sizeAmplitudeSlider.mouseReleased();
   }
}
