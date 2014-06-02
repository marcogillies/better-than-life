
RadioButtons vizSelector;
Slider numPointsSlider;

//ArrayList<Trail> trails;
ArrayList points;
Trail currentRecording = null;
PointDrawer drawer;
int currentTime = 0;

void setup()
{
  size(1024, 720);
  frameRate(10);
  drawer = new CircleDrawer();

  String [] radioNames = {
    "circles", "transparent", "fading", "mouse pointer", "triangle", "blob"
  };
  vizSelector = new RadioButtons(radioNames, 10, 5, 100, 15, HORIZONTAL);
  numPointsSlider = new Slider("number of points", 20, 0, 400, 10, 30, 200, 10, HORIZONTAL);

  //trails = new ArrayList<Trail>();
  points = new ArrayList();
  
  for(int i = 0; i < numPointsSlider.get(); i++)
  {
    points.add(new MousePoint());
  }

  /*
  BufferedReader reader = createReader("positions.txt");
  try {
    while (true)
    {
      String line = reader.readLine();
      Trail newTrail = new Trail();
      trails.add(newTrail);
      String[] pieces = split(line, ',');
      if (pieces == null)
        break;
      for (String piece : pieces)
      {
        String [] coords = split(piece, ':');
        if (coords.length >= 2)
        {
          println(coords);
          newTrail.add(int(coords[0]), int(coords[1]));
        }
      }
    }
  } 
  catch (IOException e) {
  }
  */
}

void draw()
{
  background(0);
  
  for (Point point : points)
  {
    point.draw();
  }
  drawer.drawGUI();
  vizSelector.display();
  numPointsSlider.display();
  currentTime ++;
}

void mousePressed()
{
  drawer.mousePressed();
  numPointsSlider.mousePressed();
}

void mouseDragged()
{
  drawer.mouseDragged();
  numPointsSlider.mouseDragged();
}

void mouseReleased()
{
  drawer.mouseReleased();
  if(numPointsSlider.mouseReleased())
  {
    int numPoints = int(numPointsSlider.get());
   if( numPoints > points.size())
   {
     //println(numPoints);
      for(int i = points.size(); i < numPoints; i++)
      {
        points.add(new MousePoint());
      }
    }
    if( numPoints < points.size())
    {
      //  println(numPoints);
      for(int i = points.size()-1; i >= numPoints; i--)
      {
        points.remove(i);
      }
    }
  }
  if (vizSelector.mouseReleased())
  {
    String name = vizSelector.get();
    //println(name);
    if (name == "circles")
    {
      drawer = new CircleDrawer();
    }
    if (name == "transparent")
    {
      drawer = new AlphaDrawer();
    }
    if (name == "fading")
    {
      drawer = new FadeDrawer();
    }
    if (name == "mouse pointer")
    {
      drawer = new MousePointerDrawer();
    }
    if (name == "triangle")
    {
      drawer = new TriangleDrawer();
    }
    if (name == "blob")
    {
      drawer = new BlobDrawer();
    }
  }
}

void keyPressed()
{
//  if ( key == 'r')
//  {
//    if (currentRecording == null)
//    {
//      currentRecording = new Trail();
//      trails.add(currentRecording);
//      currentTime = 0;
//    }
//    else
//    {
//      currentRecording = null;
//      currentTime = 0;
//    }
//  }
//  if (key == 'p')
//  {
//    currentTime = 0;
//  }
//  if (key == 's')
//  {
//    PrintWriter output = createWriter("positions.txt"); 
//    for (Trail trail : trails)
//    {
//      for (Point point : trail.points)
//      {
//        output.print(str(point.p.x)+":"+str(point.p.y)+",");
//      }
//      output.println("");
//    }
//    output.close();
//  }
//  if (key == 'c')
//  {
//    trails = new ArrayList<Trail>();
//  }
  if (key == '1')
  {
    drawer = new CircleDrawer();
  }
  if (key == '2')
  {
    drawer = new AlphaDrawer();
  }
  if (key == '3')
  {
    drawer = new FadeDrawer();
  }
  if (key == '4')
  {
    drawer = new MousePointerDrawer();
  }
}

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
class FadeDrawer extends PointDrawer
{
   Slider sizeSlider;
   Slider opacitySlider;
  
   FadeDrawer()
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

int HORIZONTAL = 0;
int VERTICAL   = 1;
int UPWARDS    = 2;
int DOWNWARDS  = 3;

class Widget
{

  
  PVector pos;
  PVector extents;
  String name;

  color inactiveColour = color(60, 60, 100);
  color activeColour = color(100, 100, 160);
  color bgColour = inactiveColour;
  color lineColour = color(255);
  
  
  
  void setInactiveColour(color c)
  {
    inactiveColour = c;
    bgColour = inactiveColour;
  }
  
  color getInactiveColour()
  {
    return inactiveColour;
  }
  
  void setActiveColour(color c)
  {
    activeColour = c;
  }
  
  color getActiveColour()
  {
    return activeColour;
  }
  
  void setLineColour(color c)
  {
    lineColour = c;
  }
  
  color getLineColour()
  {
    return lineColour;
  }
  
  String getName()
  {
    return name;
  }
  
  void setName(String nm)
  {
    name = nm;
  }

  Widget(String t, int x, int y, int w, int h)
  {
    pos = new PVector(x, y);
    extents = new PVector (w, h);
    name = t;
  }

  void display()
  {
  }

  boolean isClicked()
  {
    
    if (mouseX > pos.x && mouseX < pos.x+extents.x 
      && mouseY > pos.y && mouseY < pos.y+extents.y)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  
  boolean mousePressed()
  {
    return isClicked();
  }
  
  boolean mouseDragged()
  {
    return isClicked();
  }
  
  
  boolean mouseReleased()
  {
    return isClicked();
  }
}

class Button extends Widget
{
  PImage activeImage = null;
  PImage inactiveImage = null;
  PImage currentImage = null;
  
  Button(String nm, int x, int y, int w, int h)
  {
    super(nm, x, y, w, h);
  }
  
  void setInactiveImage(PImage img)
  {
    if(currentImage == inactiveImage || currentImage == null)
    {
      inactiveImage = img;
      currentImage = inactiveImage;
    }
    else
    {
      inactiveImage = img;
    }
  }
  
  void setActiveImage(PImage img)
  {
    if(currentImage == activeImage || currentImage == null)
    {
      activeImage = img;
      currentImage = activeImage;
    }
    else
    {
      activeImage = img;
    }
  }

  void display()
  {
    if(currentImage != null)
    {
      float imgHeight = (extents.x*currentImage.height)/currentImage.width;
      image(currentImage, pos.x, pos.y, extents.x, imgHeight);
    }
    else
    {
      pushStyle();
      stroke(lineColour);
      fill(bgColour);
      rect(pos.x, pos.y, extents.x, extents.y);
  
      fill(lineColour);
      textAlign(CENTER, CENTER);
      text(name, pos.x + 0.5*extents.x, pos.y + 0.5* extents.y);
      popStyle();
    }
  }
  
  boolean mousePressed()
  {
    if (super.mousePressed())
    {
      bgColour = activeColour;
      if(activeImage != null)
        currentImage = activeImage;
      return true;
    }
    return false;
  }
  
  boolean mouseReleased()
  {
    if (super.mouseReleased())
    {
      bgColour = inactiveColour;
      if(inactiveImage != null)
        currentImage = inactiveImage;
      return true;
    }
    return false;
  }
}

class Toggle extends Button
{
  boolean on = false;

  Toggle(String nm, int x, int y, int w, int h)
  {
    super(nm, x, y, w, h);
  }


  boolean get()
  {
    return on;
  }

  void set(boolean val)
  {
    on = val;
    if (on)
    {
      bgColour = activeColour;
      if(activeImage != null)
        currentImage = activeImage;
    }
    else
    {
      bgColour = inactiveColour;
      if(inactiveImage != null)
        currentImage = inactiveImage;
    }
  }

  void toggle()
  {
    set(!on);
  }

  
  boolean mousePressed()
  {
    return super.isClicked();
  }

  boolean mouseReleased()
  {
    if (super.mouseReleased())
    {
      toggle();
      return true;
    }
    return false;
  }
}

class RadioButtons extends Widget
{
  Toggle [] buttons;
  
  RadioButtons (String [] nm, int x, int y, int w, int h, int orientation)
  {
    super(nm[0], x, y, w*nm.length, h);
    buttons = new Toggle[nm.length];
    for (int i = 0; i < buttons.length; i++)
    {
      int bx, by;
      if(orientation == HORIZONTAL)
      {
        bx = x+i*w;
        by = y;
      }
      else
      {
        bx = x;
        by = y+i*h;
      }
      buttons[i] = new Toggle(nm[i], bx, by, w, h);
    }
  }
  
  
  
  void setInactiveImage(PImage img)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].setInactiveImage(img);
    }
  }
  
  void setInactiveImages(PImage [] imgs)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].setInactiveImage(imgs[i]);
    }
  }
  
  void setActiveImage(PImage img)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].setActiveImage(img);
    }
  }
  
  void setActiveImages(PImage [] imgs)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].setActiveImage(imgs[i]);
    }
  }

  void set(String buttonName)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(buttons[i].getName().equals(buttonName))
      {
        buttons[i].set(true);
      }
      else
      {
        buttons[i].set(false);
      }
    }
  }
  
  String get()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(buttons[i].get())
      {
        return buttons[i].getName();
      }
    }
    return "";
  }

  void display()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].display();
    }
  }

  boolean mousePressed()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(buttons[i].mousePressed())
      {
        return true;
      }
    }
    return false;
  }
  
  boolean mouseDragged()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(buttons[i].mouseDragged())
      {
        return true;
      }
    }
    return false;
  }

  boolean mouseReleased()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      if(buttons[i].mouseReleased())
      {
        for(int j = 0; j < buttons.length; j++)
        {
          if(i != j)
            buttons[j].set(false);
        }
        buttons[i].set(true);
        return true;
      }
    }
    return false;
  }
}

class Slider extends Widget
{
  float minimum;
  float maximum;
  float val;
  int textWidth = 60;
  int orientation = HORIZONTAL;

  Slider(String nm, float v, float min, float max, int x, int y, int w, int h, int ori)
  {
    super(nm, x, y, w, h);
    val = v;
    minimum = min;
    maximum = max;
    orientation = ori;
    if(orientation == HORIZONTAL)
      textWidth = 60;
    else
      textWidth = 20;
    
  }

  float get()
  {
    return val;
  }

  void set(float v)
  {
    val = v;
    val = constrain(val, minimum, maximum);
  }

  void display()
  {
    pushStyle();
    textAlign(LEFT, TOP);
    fill(lineColour);
    text(name, pos.x, pos.y);
    stroke(lineColour);
    noFill();
    if(orientation ==  HORIZONTAL){
      if(name == "")
        rect(pos.x, pos.y, extents.x, extents.y);
      else
        rect(pos.x+textWidth, pos.y, extents.x-textWidth, extents.y);
    } else {
      if(name == "")
        rect(pos.x, pos.y, extents.x, extents.y);
      else
        rect(pos.x, pos.y+textWidth, extents.x, extents.y-textWidth);
    }
    noStroke();
    fill(bgColour);
    float sliderPos; 
    if(orientation ==  HORIZONTAL){
        sliderPos = map(val, minimum, maximum, 0, extents.x-textWidth-4); 
        rect(pos.x+textWidth+2, pos.y+2, sliderPos, extents.y-4);
    } else if(orientation ==  VERTICAL || orientation == DOWNWARDS){
        sliderPos = map(val, minimum, maximum, 0, extents.y-textWidth-4); 
        rect(pos.x+2, pos.y+textWidth+2, extents.x-4, sliderPos);
    } else if(orientation == UPWARDS){
        sliderPos = map(val, minimum, maximum, 0, extents.y-textWidth-4); 
        rect(pos.x+2, pos.y+textWidth+2 + (extents.y-textWidth-4-sliderPos), extents.x-4, sliderPos);
    };
    popStyle();
  }

  
  boolean mouseDragged()
  {
    if (super.mouseDragged())
    {
      if(orientation ==  HORIZONTAL){
        set(map(mouseX, pos.x+textWidth, pos.x+extents.x-4, minimum, maximum));
      } else if(orientation ==  VERTICAL || orientation == DOWNWARDS){
        set(map(mouseY, pos.y+textWidth, pos.y+extents.y-4, minimum, maximum));
      } else if(orientation == UPWARDS){
        set(map(mouseY, pos.y+textWidth, pos.y+extents.y-4, maximum, minimum));
      };
      return true;
    }
    return false;
  }

  boolean mouseReleased()
  {
    if (super.mouseReleased())
    {
      if(orientation ==  HORIZONTAL){
        set(map(mouseX, pos.x+textWidth, pos.x+extents.x-10, minimum, maximum));
      } else if(orientation ==  VERTICAL || orientation == DOWNWARDS){
        set(map(mouseY, pos.y+textWidth, pos.y+extents.y-10, minimum, maximum));
      } else if(orientation == UPWARDS){
        set(map(mouseY, pos.y+textWidth, pos.y+extents.y-10, maximum, minimum));
      };
      return true;
    }
    return false;
  }
}

class MultiSlider extends Widget
{
  Slider [] sliders;
  /*
  MultiSlider(String [] nm, float min, float max, int x, int y, int w, int h, int orientation)
  {
    super(nm[0], x, y, w, h*nm.length);
    sliders = new Slider[nm.length];
    for (int i = 0; i < sliders.length; i++)
    {
      int bx, by;
      if(orientation == HORIZONTAL)
      {
        bx = x;
        by = y+i*h;
      }
      else
      {
        bx = x+i*w;
        by = y;
      }
      sliders[i] = new Slider(nm[i], 0, min, max, bx, by, w, h, orientation);
    }
  }
  */
  MultiSlider(int numSliders, float min, float max, int x, int y, int w, int h, int orientation)
  {
    super("", x, y, w, h*numSliders);
    sliders = new Slider[numSliders];
    for (int i = 0; i < sliders.length; i++)
    {
      int bx, by;
      if(orientation == HORIZONTAL)
      {
        bx = x;
        by = y+i*h;
      }
      else
      {
        bx = x+i*w;
        by = y;
      }
      sliders[i] = new Slider("", 0, min, max, bx, by, w, h, orientation);
    }
  }
  
  void setNames(String [] names)
  {
    for (int i = 0; i < sliders.length; i++)
    {
      if(i >= names.length)
        break;
      sliders[i].setName(names[i]);
    }
  }

  void set(int i, float v)
  {
    if(i >= 0 && i < sliders.length)
    {
      sliders[i].set(v);
    }
  }
  
  float get(int i)
  {
    if(i >= 0 && i < sliders.length)
    {
      return sliders[i].get();
    }
    else
    {
      return -1;
    }
    
  }

  void display()
  {
    for (int i = 0; i < sliders.length; i++)
    {
      sliders[i].display();
    }
  }

  
  boolean mouseDragged()
  {
    for (int i = 0; i < sliders.length; i++)
    {
      if(sliders[i].mouseDragged())
      {
        return true;
      }
    }
    return false;
  }

  boolean mouseReleased()
  {
    for (int i = 0; i < sliders.length; i++)
    {
      if(sliders[i].mouseReleased())
      {
        return true;
      }
    }
    return false;
  }
}

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
  
  void draw()
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
    drawer.draw(this);
  }

}

class PointDrawer
{
  void drawGUI()
  {
  }

  void draw(MousePoint p)
  {
  }

  void mousePressed()
  {
  }

  void mouseDragged()
  {
  }

  void mouseReleased()
  {
  }
}

class Trail
{
  ArrayList <MousePoint> points;
  
  Trail()
  {
    points = new ArrayList<MousePoint>();
  }
  
  void add(int x, int y)
  {
    points.add(new Point(x,y));
  }
  
  void draw(int t)
  {
    Point p = null;
    if(t >= points.size())
    { 
      if(points.size() != 0)
        p = points.get(points.size()-1);
    }
    else
    {
      p = points.get(t);
    }
    if (p != null)
    { 
      p.draw();
    }
  }
}
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

