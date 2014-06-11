class DMXOutput
{
  String DMX_Port = null;
  
  private DmxP512 dmxOutput;
  
  DMXOutput(PApplet applet, int universeSize, String port, int baudrate)
  {
    dmxOutput = new DmxP512(applet, universeSize, false);
    //if (LANBOX) {
    //  dmxOutput.setupLanbox(LANBOX_IP);
    //}
    //if (DMXPRO) {
      try {
        //dmxOutput.setupDmxPro(DMXPRO_PORT, DMXPRO_BAUDRATE);
        dmxOutput.setupDmxPro(port, baudrate);
        //dmxProSerialPort = new Serial(applet, DMXPRO_PORT, DMXPRO_BAUDRATE);
      }
      catch (java.lang.RuntimeException e){
        dmxOutput = null;
      }
    //}
  }
  
  public void setChannel(int channel, int value) {
    if (dmxOutput != null)
      dmxOutput.set(channel, value);
    println("setting channel " + channel + " to " + value);
  }
}
