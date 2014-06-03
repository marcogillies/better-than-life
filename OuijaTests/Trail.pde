class Trail
{
  ArrayList <MousePoint> points;
  
  Trail()
  {
    points = new ArrayList<MousePoint>();
  }
  
  void add(int x, int y)
  {
    points.add(new MousePoint(x,y));
  }
  
  void draw(int t)
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
