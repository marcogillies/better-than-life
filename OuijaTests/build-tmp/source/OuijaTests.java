import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import http.requests.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class OuijaTests extends PApplet {



RadioButtons vizSelector;
Slider numPointsSlider;

//ArrayList<Trail> trails;
ArrayList <MousePoint> points;
Trail currentRecording = null;
PointDrawer drawer;
int currentTime = 0;

PVector [] cornerPoints;
float a0 = 1.0f;
float a1 = 1.0f;

public void setup()
{
  size(400, 400);
  frameRate(5);
  drawer = new CircleDrawer();

  String [] radioNames = {
    "circles", "transparent", "fading", "mouse pointer", "triangle", "blob"
  };
  vizSelector = new RadioButtons(radioNames, 10, 5, 100, 15, HORIZONTAL);
  numPointsSlider = new Slider("number of points", 20, 0, 400, 10, 30, 200, 10, HORIZONTAL);

  //trails = new ArrayList<Trail>();
  points = new ArrayList<MousePoint>();

  cornerPoints = new PVector [4];
  cornerPoints[0] = new PVector(0, 0);
  cornerPoints[1] = new PVector(100, 0);
  cornerPoints[2] = new PVector(100, 100);
  cornerPoints[3] = new PVector(0, 100);
  
  //for(int i = 0; i < numPointsSlider.get(); i++)
  //{
  //  points.add(new MousePoint());
  //}

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

// transforms points according to the quadrilateral calibration
public PVector transformPoint(PVector v)
{
  //float denom = (a0 + a1 \u2212 1) + (1 \u2212 a1)*v.x + (1 \u2212 a0)*v.y;
  float denom = (a0 + a1 - 1) + (1 - a1)*v.x + (1 - a0)*v.y;
  PVector ret = new PVector();
  ret.x = a0*v.x/denom;
  ret.y = a1*v.y/denom;
  return ret;
}

public void draw()
{
  background(0);

  GetRequest get = new GetRequest("http://127.0.0.1:8000/show/allMouse/");
  get.send();
  String content = get.getContent();
  //println("Reponse Content: " + content);
  String [] lines = split(content, '\n');
  for (int i = 0; i < lines.length; i++)
  {
    String [] xy = split(lines[i], ":");
    if(xy.length >= 2)
    {
      float x = map(PApplet.parseFloat(xy[0]), 0, 100, 0, width);
      float y = map(PApplet.parseFloat(xy[1]), 0, 100, 0, width);
      PVector v = transformPoint(new PVector(x,y));
      println(v);
      //println(x,y);
      if(i < points.size()) {
        points.get(i).set(v.x, v.y);
      }
      else  {
        points.add(new MousePoint(v.x,v.y));
      }
    }
  }

  for (MousePoint point : points)
  {
    point.draw();
  }
  drawer.drawGUI();
  vizSelector.display();
  numPointsSlider.display();
  currentTime ++;
}

public void mousePressed()
{
  drawer.mousePressed();
  numPointsSlider.mousePressed();
}

public void mouseDragged()
{
  drawer.mouseDragged();
  numPointsSlider.mouseDragged();
}

public void mouseReleased()
{
  drawer.mouseReleased();
  if(numPointsSlider.mouseReleased())
  {
    int numPoints = PApplet.parseInt(numPointsSlider.get());
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

public void keyPressed(){

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
    //drawer = new CircleDrawer();
    cornerPoints[0].set(points.get(0).p);
  }
  if (key == '2')
  {
    //drawer = new AlphaDrawer();
    cornerPoints[1].set(points.get(0).p);
  }
  if (key == '3')
  {
    //drawer = new FadeDrawer();
    cornerPoints[2].set(points.get(0).p);
  }
  if (key == '4')
  {
    //drawer = new MousePointerDrawer();
    cornerPoints[3].set(points.get(0).p);
  //}
    println(cornerPoints);

    PVector q01 = PVector.sub(cornerPoints[3], cornerPoints[0]);
    PVector q11 = PVector.sub(cornerPoints[2], cornerPoints[0]);
    PVector q10 = PVector.sub(cornerPoints[1], cornerPoints[0]);
    // solution to the linear equations as per 
    // http://www.geometrictools.com/Documentation/PerspectiveMappings.pdf
    // q11 = a0*q01 + a1*q10
    // a1 = (q11.y - a0*q01.y)/q10.y
    // q11.x = a0*q01.x + q10.x*((q11.y - a0*q01.y)/q10.y)
    // q11.x = a0*q01.x + q10.x*q11.y/q10.y - a0*q10.x*q01.y/q10.y
    // a0 = (q11.x + q10.x*q11.y/q10.y)/(q01.x - q10.x*q01.y/q10.y)
    a0 = (q11.x - q10.x*q11.y/q10.y)/(q01.x - q10.x*q01.y/q10.y);
    a1 = (q11.y - a0*q01.y)/q10.y;
    println(a0 + " "  + a1);
    println(q01 + " " + q10 + " " + q11);
    println(PVector.add(PVector.mult(q01,a0), PVector.mult(q10,a1)));
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
  
   public void drawGUI()
   {
     sizeSlider.display();
     opacitySlider.display();
   }
  
   public void draw(MousePoint p)
   {
     pushStyle();
     fill(255, 255, 255, opacitySlider.get());
     noStroke();
     ellipse(p.p.x, p.p.y, sizeSlider.get(), sizeSlider.get());
     popStyle();
   } 
   
   public void mousePressed()
   {
     sizeSlider.mousePressed();
     opacitySlider.mousePressed();
   }
   
   public void mouseDragged()
   {
     sizeSlider.mouseDragged();
     opacitySlider.mouseDragged();
   }
   
   public void mouseReleased()
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
  
   public void drawGUI()
   {
     sizeSlider.display();
     opacitySlider.display();
   }
  
   public void draw(MousePoint p)
   {
     pushStyle();
     fill(255, 255, 255, opacitySlider.get());
     noStroke();
     for(PVector offset : p.offsets)
     {
       //int x = int(p.p.x+offset.x*sizeSlider.get());
       //int y = int(p.p.y+offset.y*sizeSlider.get());
       int x = PApplet.parseInt(p.p.x + (noise(p.p.x/100, offset.x, millis()/1000.0f)+0.5f)*4.0f*sizeSlider.get());
       int y = PApplet.parseInt(p.p.y + (noise(p.p.y/100, offset.y, millis()/1000.0f)+0.5f)*4.0f*sizeSlider.get());
       for(int i = 0; i < sizeSlider.get(); i++)
         ellipse(x, y, i, i);
       //PVector change = PVector.random2D();
       //change.mult(0.03);
       PVector change = new PVector(-0.03f, 0.03f);
       offset.add(change);
       offset.limit(1.0f);
     }
     popStyle();
   } 
   
   public void mousePressed()
   {
     sizeSlider.mousePressed();
     opacitySlider.mousePressed();
   }
   
   public void mouseDragged()
   {
     sizeSlider.mouseDragged();
     opacitySlider.mouseDragged();
   }
   
   public void mouseReleased()
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
  
   public void drawGUI()
   {
     sizeSlider.display();
   }
  
   public void draw(MousePoint p)
   {
     pushStyle();
     fill(255);
     noStroke();
     ellipse(p.p.x, p.p.y, sizeSlider.get(), sizeSlider.get());
     popStyle();
   } 
   
   public void mousePressed()
   {
     sizeSlider.mousePressed();
   }
   
   public void mouseDragged()
   {
     sizeSlider.mouseDragged();
   }
   
   public void mouseReleased()
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
  
   public void drawGUI()
   {
     sizeSlider.display();
     opacitySlider.display();
   }
  
   public void draw(MousePoint p)
   {
     pushStyle();
     fill(255, 255, 255, opacitySlider.get());
     noStroke();
     for(int i = 0; i < sizeSlider.get(); i++)
       ellipse(p.p.x, p.p.y, i, i);
     popStyle();
   } 
   
   public void mousePressed()
   {
     sizeSlider.mousePressed();
     opacitySlider.mousePressed();
   }
   
   public void mouseDragged()
   {
     sizeSlider.mouseDragged();
     opacitySlider.mouseDragged();
   }
   
   public void mouseReleased()
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

  int inactiveColour = color(60, 60, 100);
  int activeColour = color(100, 100, 160);
  int bgColour = inactiveColour;
  int lineColour = color(255);
  
  
  
  public void setInactiveColour(int c)
  {
    inactiveColour = c;
    bgColour = inactiveColour;
  }
  
  public int getInactiveColour()
  {
    return inactiveColour;
  }
  
  public void setActiveColour(int c)
  {
    activeColour = c;
  }
  
  public int getActiveColour()
  {
    return activeColour;
  }
  
  public void setLineColour(int c)
  {
    lineColour = c;
  }
  
  public int getLineColour()
  {
    return lineColour;
  }
  
  public String getName()
  {
    return name;
  }
  
  public void setName(String nm)
  {
    name = nm;
  }

  Widget(String t, int x, int y, int w, int h)
  {
    pos = new PVector(x, y);
    extents = new PVector (w, h);
    name = t;
  }

  public void display()
  {
  }

  public boolean isClicked()
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
  
  public boolean mousePressed()
  {
    return isClicked();
  }
  
  public boolean mouseDragged()
  {
    return isClicked();
  }
  
  
  public boolean mouseReleased()
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
  
  public void setInactiveImage(PImage img)
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
  
  public void setActiveImage(PImage img)
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

  public void display()
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
      text(name, pos.x + 0.5f*extents.x, pos.y + 0.5f* extents.y);
      popStyle();
    }
  }
  
  public boolean mousePressed()
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
  
  public boolean mouseReleased()
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


  public boolean get()
  {
    return on;
  }

  public void set(boolean val)
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

  public void toggle()
  {
    set(!on);
  }

  
  public boolean mousePressed()
  {
    return super.isClicked();
  }

  public boolean mouseReleased()
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
  
  
  
  public void setInactiveImage(PImage img)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].setInactiveImage(img);
    }
  }
  
  public void setInactiveImages(PImage [] imgs)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].setInactiveImage(imgs[i]);
    }
  }
  
  public void setActiveImage(PImage img)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].setActiveImage(img);
    }
  }
  
  public void setActiveImages(PImage [] imgs)
  {
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].setActiveImage(imgs[i]);
    }
  }

  public void set(String buttonName)
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
  
  public String get()
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

  public void display()
  {
    for (int i = 0; i < buttons.length; i++)
    {
      buttons[i].display();
    }
  }

  public boolean mousePressed()
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
  
  public boolean mouseDragged()
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

  public boolean mouseReleased()
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

  public float get()
  {
    return val;
  }

  public void set(float v)
  {
    val = v;
    val = constrain(val, minimum, maximum);
  }

  public void display()
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

  
  public boolean mouseDragged()
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

  public boolean mouseReleased()
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
  
  public void setNames(String [] names)
  {
    for (int i = 0; i < sliders.length; i++)
    {
      if(i >= names.length)
        break;
      sliders[i].setName(names[i]);
    }
  }

  public void set(int i, float v)
  {
    if(i >= 0 && i < sliders.length)
    {
      sliders[i].set(v);
    }
  }
  
  public float get(int i)
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

  public void display()
  {
    for (int i = 0; i < sliders.length; i++)
    {
      sliders[i].display();
    }
  }

  
  public boolean mouseDragged()
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

  public boolean mouseReleased()
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
  
   public void drawGUI()
   {
     sizeSlider.display();
   }
  
   public void draw(MousePoint p)
   {
     image(img, p.p.x, p.p.y, sizeSlider.get(),sizeSlider.get()*(10.0f/6));
   } 
   
   public void mousePressed()
   {
     sizeSlider.mousePressed();
   }
   
   public void mouseDragged()
   {
     sizeSlider.mouseDragged();
   }
   
   public void mouseReleased()
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
    this(PApplet.parseInt(random(0, width)), PApplet.parseInt(random(0, height)));
  }
  
    MousePoint (float x, float y)
    {
     //p = new PVector (int(random(0, width)), int(random(0, height)));
     p = new PVector (x,y);
    
    //vel = PVector.random2D();
    vel = new PVector (random(-1,1), random(-1, 1));
    //println(vel.x + " " + vel.y);
//    vel.mult(random(0, 4));
    angle = radians(random(0, 360));
    offsets = new PVector [6];
    for (int i = 0; i < offsets.length; i++)
    {
      offsets[i] = new PVector(random(-0.5f, 0.5f), random(-0.5f, 0.5f));
      //offsets[i] = PVector.random2D();
      //offsets[i].mult(random(0.2, 0.5));
    }
  }
  
  public void set(float x, float y)
  {
    p.x = x;
    p.y = y;
  }

  public void update()
  {
    PVector vChange = new PVector(random(-0.5f, 0.5f), random(-0.5f, 0.5f));
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
  
  public void draw()
  {
    
    drawer.draw(this);
  }

}

class PointDrawer
{
  public void drawGUI()
  {
  }

  public void draw(MousePoint p)
  {
  }

  public void mousePressed()
  {
  }

  public void mouseDragged()
  {
  }

  public void mouseReleased()
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
  
  public void add(int x, int y)
  {
    points.add(new MousePoint(x,y));
  }
  
  public void draw(int t)
  {
    MousePoint p = null;
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
  
   public void drawGUI()
   {
     sizeSlider.display();
   }
  
   public void draw(MousePoint p)
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
     scale(sizeSlider.get()/10.0f);
     triangle(0, -10, -7, 7, 7, 7);
     popMatrix();
     popStyle();
     p.angle += 0.1f;
   } 
   
   public void mousePressed()
   {
     sizeSlider.mousePressed();
   }
   
   public void mouseDragged()
   {
     sizeSlider.mouseDragged();
   }
   
   public void mouseReleased()
   {
     sizeSlider.mouseReleased();
   }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "OuijaTests" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
