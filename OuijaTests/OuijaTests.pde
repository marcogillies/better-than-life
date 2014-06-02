
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

