import processing.serial.*;

import dmxP512.*;

import http.requests.*;

boolean DMXPRO=true;
int UNIVERSESIZE = 128;
String DMXPRO_PORT="";  //case matters ! on windows port must be upper cased.
int DMXPRO_BAUDRATE=115000;

DMXOutput dmx;

void setup()
{
  size(400, 400);
  frameRate(5);
  dmx = new DMXOutput (this, UNIVERSESIZE, DMXPRO_PORT, DMXPRO_BAUDRATE);
}

void draw()
{
  //GetRequest get = new GetRequest("http://www.betterthanlife.org.uk/show/allMouse/");
  GetRequest get = new GetRequest("http://127.0.0.1:8000/show/averageMouse/");
  get.send();
  String content = get.getContent();
  //println("Reponse Content: " + content);
  String [] lines = split(content, '\n');
  if (lines != null)
  {
    String [] xy = split(lines[0], ":");
    if (xy.length >= 2)
    {
        //float x = map(float(xy[0]), 0, 100, 0, width);
        //float y = map(float(xy[1]), 0, 100, 0, width);
        float x = float(xy[0]);
        float y = float(xy[1]);
        background(0);
        fill(255);
        float boxHeight = map(y, 0, 100, 0, height);
        println(y + " " + boxHeight);
        rect(0, height - boxHeight, width, boxHeight);
        int dmxVal = int(map(y, 0, 100, 0, 255));
        dmx.setChannel(0, dmxVal);
    }
  }
}
