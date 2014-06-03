import http.requests.*;

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

void setup()
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
PVector transformPoint(PVector v)
{
  //float denom = (a0 + a1 − 1) + (1 − a1)*v.x + (1 − a0)*v.y;
  float denom = (a0 + a1 - 1) + (1 - a1)*v.x + (1 - a0)*v.y;
  PVector ret = new PVector();
  ret.x = a0*v.x/denom;
  ret.y = a1*v.y/denom;
  return ret;
}

void draw()
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
      float x = map(float(xy[0]), 0, 100, 0, width);
      float y = map(float(xy[1]), 0, 100, 0, width);
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

void keyPressed(){

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

