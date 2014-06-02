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
