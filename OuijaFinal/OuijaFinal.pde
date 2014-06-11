import http.requests.*;

//RadioButtons vizSelector;
//Slider numPointsSlider;

//ArrayList<Trail> trails;
ArrayList <MousePoint> points;
//Trail currentRecording = null;
PulseDrawer drawer;
int currentTime = 0;

// the corner points of the projection of
// the ouija onto the showcaster screen
PVector [] cornerPoints;
// this is an untransformed point that is used to
// set the corner point
PVector untransPoint0 = new PVector();
// intermediary values for calculating the 
// inverse projection
PVector a = new PVector(1, 1);
PVector q00 = new PVector();
PVector q01 = new PVector();
PVector q10 = new PVector();

boolean showCallibration = false;
//boolean showGUI = false;
int calibrationOffset = 200;


void setup()
{
  size(displayWidth, displayHeight);
  //size(640, 240);
  frameRate(5);
  drawer = new PulseDrawer();

  String [] radioNames = {
    "circles", "transparent", "fading", "mouse pointer", "triangle", "blob", "twinkle", "twinklefade", "pulse"
  };
  //vizSelector = new RadioButtons(radioNames, 10, 5, 100, 15, HORIZONTAL);
  //numPointsSlider = new Slider("number of points", 20, 0, 400, 10, 30, 200, 10, HORIZONTAL);

  //trails = new ArrayList<Trail>();
  points = new ArrayList<MousePoint>();

  cornerPoints = new PVector [4];
  reset();


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

void reset()
{
  cornerPoints[0] = new PVector(0, 0);
  cornerPoints[1] = new PVector(100, 0);
  cornerPoints[2] = new PVector(100, 100);
  cornerPoints[3] = new PVector(0, 100);
  calibrate();
}

void calibrate()
{
  normaliseCornerPoints();
  //PVector q11 = PVector.sub(cornerPoints[2], cornerPoints[0]);
  PVector q11 = new PVector(cornerPoints[2].x, cornerPoints[2].y);
  a = normalisedQuadVector(q11);

  println(cornerPoints);
  println(a.x + " "  + a.y);
  println(q01 + " " + q10 + " " + q11);
  println(PVector.add(PVector.mult(q01, a.x), PVector.mult(q10, a.y)));
  for (int i = 0; i < cornerPoints.length; i++)
  {
    PVector v1 = transformPoint(cornerPoints[i]);
    println(v1);
  }
}

/*
 * Two bits of linear algebra to calculate the mapping from
 * the projection of the ouija on the showcaseter screen to 
 * the Processing screen
 */

// get the corner points with the origin set to point 0
void normaliseCornerPoints()
{
  q00 = new PVector(cornerPoints[0].x, cornerPoints[0].y);
  q01 = PVector.sub(cornerPoints[3], q00);
  q10 = PVector.sub(cornerPoints[1], q00);
}

// gets a point on screen in terms of two sides of 
// the quad
PVector normalisedQuadVector(PVector v)
{
  //println(cornerPoints);

  //PVector q11 = PVector.sub(cornerPoints[2], cornerPoints[0]);
  // solution to the linear equations as per 
  // 1
  // q11 = a0*q10 + a1*q01
  // a1 = (q11.y - a0*q10.y)/q01.y
  // q11.x = a0*q10.x + q01.x*((q11.y - a0*q10.y)/q01.y)
  // q11.x = a0*q10.x + q01.x*q11.y/q01.y - a0*q01.x*q10.y/q01.y
  // a0 = (q11.x + q01.x*q11.y/q01.y)/(q10.x - q01.x*q10.y/q01.y)
  v = PVector.sub(v, q00);
  PVector retVec = new PVector();
  if (abs(q01.y) < 0.0000001)
  {
    if (abs(q10.y) < 0.0000001 || abs(q01.x) < 0.0000001 ) {
      retVec.set(0, 0);
    }
    else {
      retVec.x = v.y/q10.y;
      retVec.y = (v.x - retVec.y*q10.x)/q01.x;
    }
  } 
  else if (abs(q10.y) < 0.0000001) {
    if (abs(q01.y) < 0.0000001 || abs(q10.x) < 0.0000001 ) {
      retVec.set(0, 0);
    }
    else {
      retVec.y = v.y/q01.y;
      retVec.x = (v.x - retVec.y*q01.x)/q10.x;
    }
  } 
  else {
    retVec.x = (v.x - q01.x*v.y/q01.y)/(q10.x - q01.x*q10.y/q01.y);
    retVec.y = (v.y - retVec.x*q10.y)/q01.y;
  }
  //println(retVec.x + " "  + retVec.y);
  //println(q01 + " " + q10 + " " + v);
  //println(PVector.add(PVector.mult(q01,retVec.x), PVector.mult(q10,retVec.y)));
  return retVec;
}

// transforms points according to the quadrilateral calibration
PVector transformPoint(PVector v)
{
  //float denom = (a0 + a1 − 1) + (1 − a1)*v.x + (1 − a0)*v.y;
  //float denom = (a0 + a1 - 1) + (1 - a1)*v.x + (1 - a0)*v.y;
  v = normalisedQuadVector(v);
  float denom = a.x*a.y + a.y*(a.y - 1)*v.x + a.x*(a.x - 1)*v.y;
  //println(denom);
  PVector ret = new PVector();
  ret.x = a.y*(a.x + a.y - 1)*v.x/denom;
  ret.y = a.x*(a.x + a.y - 1)*v.y/denom;
  //println(ret);
  ret.x *= (width - 2*calibrationOffset);
  ret.y *= (height - 2*calibrationOffset);
  ret.x +=  calibrationOffset;
  ret.y +=  calibrationOffset;
  //println(ret);
  return ret;
}

void drawCross(float x, float y)
{
  line(x, y-10, x, y+10);
  line(x-10, y, x+10, y);
}

void draw()
{
  background(0);

  GetRequest get = new GetRequest("http://www.betterthanlife.org.uk/show/allMouse/");
  //GetRequest get = new GetRequest("http://127.0.0.1:8000/show/allMouse/");
  get.send();
  String content = get.getContent();
  //println("Reponse Content: " + content);
  String [] lines = split(content, '\n');
  if (lines != null)
  {
    for (int i = 0; i < lines.length; i++)
    {
      String [] xy = split(lines[i], ":");
      if (xy.length >= 2)
      {
        //float x = map(float(xy[0]), 0, 100, 0, width);
        //float y = map(float(xy[1]), 0, 100, 0, width);
        float x = float(xy[0]);
        float y = float(xy[1]);

        if (i == 0) {
          untransPoint0.set(x, y);
        }
        PVector v = transformPoint(new PVector(x, y));
        //println(v);
        //println(x,y);
        if (i < points.size()) {
          points.get(i).set(v.x, v.y);
        } 
        else {
          points.add(new MousePoint(v.x, v.y));
        }
      }
    }
  }



  for (MousePoint point : points)
  {
    point.draw();
  }

  currentTime ++;

  if (showCallibration)
  {
    //println("drawing cross");
    pushStyle();
    stroke(255);
    strokeWeight(10);
    drawCross(calibrationOffset, calibrationOffset);
    drawCross(calibrationOffset, height-calibrationOffset);
    drawCross(width-calibrationOffset, calibrationOffset);
    drawCross(width-calibrationOffset, height-calibrationOffset);
    popStyle();

    pushStyle();
    stroke(255);
    strokeWeight(10);
    noFill();
    PVector v = transformPoint(untransPoint0);
    ellipse(v.x, v.y, 40, 40);

    stroke(255, 160, 160);
    for (int i = 0; i < cornerPoints.length; i++)
    {
      PVector v1 = transformPoint(cornerPoints[i]);
      //println(v1);
      ellipse(v1.x, v1.y, 40, 40);
    }
    popStyle();
  }
}

//void mousePressed()
//{
//  if (showGUI)
//  {
//    drawer.mousePressed();
//    numPointsSlider.mousePressed();
//  }
//}
//
//void mouseDragged()
//{
//  if (showGUI)
//  {
//    drawer.mouseDragged();
//    numPointsSlider.mouseDragged();
//  }
//}
//
//void mouseReleased()
//{
//  if (showGUI)
//  {
//    drawer.mouseReleased();
//    if (numPointsSlider.mouseReleased())
//    {
//      int numPoints = int(numPointsSlider.get());
//      if ( numPoints > points.size())
//      {
//        //println(numPoints);
//        for (int i = points.size(); i < numPoints; i++)
//        {
//          points.add(new MousePoint());
//        }
//      }
//      if ( numPoints < points.size())
//      {
//        //  println(numPoints);
//        for (int i = points.size()-1; i >= numPoints; i--)
//        {
//          points.remove(i);
//        }
//      }
//    }
//    if (vizSelector.mouseReleased())
//    {
//      String name = vizSelector.get();
//      //println(name);
//      if (name == "circles")
//      {
//        drawer = new CircleDrawer();
//      }
//      if (name == "transparent")
//      {
//        drawer = new AlphaDrawer();
//      }
//      if (name == "fading")
//      {
//        drawer = new FadeDrawer();
//      }
//      if (name == "mouse pointer")
//      {
//        drawer = new MousePointerDrawer();
//      }
//      if (name == "triangle")
//      {
//        drawer = new TriangleDrawer();
//      }
//      if (name == "blob")
//      {
//        drawer = new BlobDrawer();
//      }
//      if (name == "twinkle")
//      {
//        drawer = new TwinkleDrawer();
//      }
//      if (name == "twinklefade")
//      {
//        drawer = new TwinkleFadeDrawer();
//      }
//      if (name == "pulse")
//      {
//        drawer = new PulseDrawer();
//      }
//    }
//  }
//}

void keyPressed() {

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

  if (key == 'c')
  {
    showCallibration = !showCallibration;
  }


  //  if (key == 'g')
  //  {
  //    showGUI = !showGUI;
  //  }

  if (key == '1')
  {
    //drawer = new CircleDrawer();
    cornerPoints[0].set(untransPoint0);
  }
  if (key == '2')
  {
    //drawer = new AlphaDrawer();
    cornerPoints[1].set(untransPoint0);
  }
  if (key == '3')
  {
    //drawer = new FadeDrawer();
    cornerPoints[2].set(untransPoint0);
  }
  if (key == '4')
  {
    //drawer = new MousePointerDrawer();
    cornerPoints[3].set(untransPoint0);

    //normaliseCornerPoints();
    //PVector q11 = PVector.sub(cornerPoints[2], cornerPoints[0]);
    //PVector q11 = new PVector(cornerPoints[2].x, cornerPoints[2].y);
    //a = normalisedQuadVector(q11);

    calibrate();

    //println(cornerPoints);
    //println(a.x + " "  + a.y);
    //println(q01 + " " + q10 + " " + q11);
    //println(PVector.add(PVector.mult(q01, a.x), PVector.mult(q10, a.y)));
  }
  if (key == 'r')
  {
    reset();
  }
}

