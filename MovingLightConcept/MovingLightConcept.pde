

import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import java.io.BufferedReader;
import java.io.InputStreamReader;

String urlBase = "http://127.0.0.1:8000/show/averageMouse/";
URL url;
HttpURLConnection connection = null;

void setup()
{
  size(500, 500);
  ellipseMode(CENTER);
  try {
    url = new URL(urlBase);
  } 
  catch (MalformedURLException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}

void draw()
{
  background(0);
  fill(255);
  
  try{
    connection = (HttpURLConnection)url.openConnection();
    connection.setRequestMethod("POST");
    BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
    String text = in.readLine();
    println(text);
    String [] coords = split(text, ":"); 
    println(coords[0] + " " + coords[1]);
    
    float x = float(coords[0])*width;
    float y = float(coords[1])*width;
    ellipse(x, y, 50, 50);
  } 
  catch(IOException e)
  {
    e.printStackTrace();
  }
}

