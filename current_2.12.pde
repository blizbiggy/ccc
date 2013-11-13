/**********************************
     Version 2.12 Changelog
  -Fixed typo when after
   connecting to camera 2
   
     Version 2.11 Changelog
  -Removed processing.net
  -Added java.net as replacement
    *Has all error checking
    functions as the android
    version.

     Version 2.10 Changelog
  -Updated Graphics and positions
  -Removed Camera Checkbox
    *Now seperated buttons
  -Removed IP input
    *Now dropdown menu
  -Removed ON/OFF buttons
  -Removed Speed Adjust Bar
    *Now Buttons
    
***********************************/
import controlP5.*;
import javax.swing.ImageIcon;
import java.io.*;
import java.net.*;

DropdownList d1;

String serverIP = "131.123.129.19";
float valueOfDropdown = 1.0;
String dropdownGroupName;
int dropdownState = 0;

PrintWriter output;
Socket camConnect;
OutputStream out;
InputStream in;

ControlP5 cp5;
Textlabel camStatus;
Button disconnectButton;
Button connectButton;

Button defaultButton;
Button ipKentMain;
Button ipKentStark;
Button ipKentTusc;

int Speed = 100;
int prev = 1;
int camStat = 0;
int camSelected = 0;

int read=0;
int conStat = 0;
PImage bg;
PImage dropdown1;
PImage dropdown2;
PImage dropdown3;
PImage dropdown4;

void keyPressed(){
  if(key==ESC){
    key=0; //Fools!  You cannot destroy me!
  }
}

void setup(){
  frame.setTitle("KSU Camera Control Client");
  size(400,711);
  bg = loadImage("background.png");
  
  cp5 = new ControlP5(this);            
  
  camStatus = cp5.addTextlabel("serialStatus")
                    .setText("Waiting for user connection to camera...")
                    .setPosition(75,38)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("MS Serif",11, false))
                    ;   
  PImage connect = loadImage("connect.png");
  PImage disconnect = loadImage("disconnect.png");
  PImage[] up = {loadImage("up.png"),loadImage("up_on.png"),loadImage("up_on.png")};
  PImage[] down = {loadImage("down.png"),loadImage("down_on.png"),loadImage("down_on.png")};
  PImage[] left = {loadImage("left.png"),loadImage("left_on.png"),loadImage("left_on.png")};
  PImage[] right = {loadImage("right.png"),loadImage("right_on.png"),loadImage("right_on.png")};
  PImage[] home = {loadImage("home.png"),loadImage("home_on.png"),loadImage("home_on.png")};
  PImage[] zoomin = {loadImage("zoomin.png"),loadImage("zoomin_on.png"),loadImage("zoomin_on.png")};
  PImage[] zoomout = {loadImage("zoomout.png"),loadImage("zoomout_on.png"),loadImage("zoomout_on.png")};
  PImage[] focusAuto = {loadImage("autofocus.png"),loadImage("autofocus_on.png"),loadImage("autofocus_on.png")};
  PImage[] focusManual = {loadImage("manualfocus.png"),loadImage("manualfocus_on.png"),loadImage("manualfocus_on.png")};
  PImage[] focusNear = {loadImage("focusnear.png"),loadImage("focusnear_on.png"),loadImage("focusnear_on.png")};
  PImage[] focusFar = {loadImage("focusfar.png"),loadImage("focusfar_on.png"),loadImage("focusfar_on.png")};
  PImage[] set1 = {loadImage("set1.png"),loadImage("set1_on.png"),loadImage("set1_on.png")};
  PImage[] set2 = {loadImage("set2.png"),loadImage("set2_on.png"),loadImage("set2_on.png")};
  PImage[] set3 = {loadImage("set3.png"),loadImage("set3_on.png"),loadImage("set3_on.png")};
  PImage[] set4 = {loadImage("set4.png"),loadImage("set4_on.png"),loadImage("set4_on.png")};
  PImage[] set5 = {loadImage("set5.png"),loadImage("set5_on.png"),loadImage("set5_on.png")};
  PImage[] set6 = {loadImage("set6.png"),loadImage("set6_on.png"),loadImage("set6_on.png")};
  PImage[] set7 = {loadImage("set7.png"),loadImage("set7_on.png"),loadImage("set7_on.png")};
  PImage[] set8 = {loadImage("set8.png"),loadImage("set8_on.png"),loadImage("set8_on.png")};
  PImage[] set9 = {loadImage("set9.png"),loadImage("set9_on.png"),loadImage("set9_on.png")};
  PImage[] zone1 = {loadImage("zone1.png"),loadImage("zone1_on.png"),loadImage("zone1_on.png")};
  PImage[] zone2 = {loadImage("zone2.png"),loadImage("zone2_on.png"),loadImage("zone2_on.png")};
  PImage[] zone3 = {loadImage("zone3.png"),loadImage("zone3_on.png"),loadImage("zone3_on.png")};
  PImage[] zone4 = {loadImage("zone4.png"),loadImage("zone4_on.png"),loadImage("zone4_on.png")};
  PImage[] zone5 = {loadImage("zone5.png"),loadImage("zone5_on.png"),loadImage("zone5_on.png")};
  PImage[] zone6 = {loadImage("zone6.png"),loadImage("zone6_on.png"),loadImage("zone6_on.png")};
  PImage[] zone7 = {loadImage("zone7.png"),loadImage("zone7_on.png"),loadImage("zone7_on.png")};
  PImage[] zone8 = {loadImage("zone8.png"),loadImage("zone8_on.png"),loadImage("zone8_on.png")};
  PImage[] zone9 = {loadImage("zone9.png"),loadImage("zone9_on.png"),loadImage("zone9_on.png")};
  PImage[] url = {loadImage("info.png"),loadImage("info_on.png"),loadImage("info_on.png")};
  PImage[] speed1 = {loadImage("speed1.png"),loadImage("speed1_on.png"),loadImage("speed1_on.png")};
  PImage[] speed2 = {loadImage("speed2.png"),loadImage("speed2_on.png"),loadImage("speed2_on.png")};
  PImage[] speed3 = {loadImage("speed3.png"),loadImage("speed3_on.png"),loadImage("speed3_on.png")};
  PImage[] speed4 = {loadImage("speed4.png"),loadImage("speed4_on.png"),loadImage("speed4_on.png")};
  PImage[] speed5 = {loadImage("speed5.png"),loadImage("speed5_on.png"),loadImage("speed5_on.png")};
  PImage[] camera1 = {loadImage("camera1.png"),loadImage("camera1_on.png"),loadImage("camera1_on.png")};
  PImage[] camera2 = {loadImage("camera2.png"),loadImage("camera2_on.png"),loadImage("camera2_on.png")};
  dropdown1 = loadImage("dropdown1.png");
  dropdown2 = loadImage("dropdown2.png");
  dropdown4 = loadImage("dropdown4.png");
  dropdown3 = loadImage("dropdown3.png");
  
  ImageIcon titlebaricon = new ImageIcon(loadBytes("camera_icon.png"));
  frame.setIconImage(titlebaricon.getImage());
  
  connectButton = cp5.addButton("connect")
               .setPosition(334,5)
               .setImage(connect)     
               .updateSize()
               ;

  disconnectButton = cp5.addButton("disconnect")
                  .setPosition(334,5)
                  .setImage(disconnect)     
                  .updateSize()
                  .hide()
                  ;  

  cp5.addButton("up")
     .setPosition(163,146)
     .setImages(up)
     .updateSize()
     ;
     
  cp5.addButton("down")
     .setPosition(163,284)
     .setImages(down)     
     .updateSize()
     ;
     
  cp5.addButton("home")
     .setPosition(172,223)
     .setImages(home)     
     .updateSize()
     ;     

  cp5.addButton("left")
     .setPosition(97,214)
     .setImages(left)     
     .updateSize()
     ;
     
  cp5.addButton("right")
     .setPosition(235,214)
     .setImages(right)     
     .updateSize()
     ;
     
  cp5.addButton("zoomin")
     .setPosition(303,174)
     .setImages(zoomin)     
     .updateSize()
     ;
     
  cp5.addButton("zoomout")
     .setPosition(303,250)
     .setImages(zoomout)     
     .updateSize()
     ;
  cp5.addButton("focusAuto")
     .setPosition(47,174)
     .setImages(focusAuto)     
     .updateSize()
     ;
     
  cp5.addButton("focusManual")
     .setPosition(55,250)
     .setImages(focusManual)     
     .updateSize()
     ;
     
  cp5.addButton("focusNear")
     .setPosition(22,250)
     .setImages(focusNear)     
     .updateSize()
     ;
     
  cp5.addButton("focusFar")
     .setPosition(27,287)
     .setImages(focusFar)     
     .updateSize()
     ;     
     
  cp5.addButton("set1")
     .setPosition(40,670)
     .setImages(set1)     
     .updateSize()
     ;
     
  cp5.addButton("set2")
     .setPosition(75,670)
     .setImages(set2)     
     .updateSize()
     ;
     
  cp5.addButton("set3")
     .setPosition(111,670)
     .setImages(set3)     
     .updateSize()
     ;
     
  cp5.addButton("set4")
     .setPosition(147,670)
     .setImages(set4)     
     .updateSize()
     ;
     
  cp5.addButton("set5")
     .setPosition(183,670)
     .setImages(set5)     
     .updateSize()
     ;
     
  cp5.addButton("set6")
     .setPosition(219,670)
     .setImages(set6)     
     .updateSize()
     ;
     
  cp5.addButton("set7")
     .setPosition(255,669)
     .setImages(set7)     
     .updateSize()
     ;
     
  cp5.addButton("set8")
     .setPosition(290,670)
     .setImages(set8)     
     .updateSize()
     ;
     
  cp5.addButton("set9")
     .setPosition(326,670)
     .setImages(set9)
     .updateSize()
     ;
     
  cp5.addButton("zone1")
     .setPosition(39,474)
     .setImages(zone1)     
     .updateSize()
     ;
     
  cp5.addButton("zone2")
     .setPosition(147,474)
     .setImages(zone2)     
     .updateSize()
     ;
     
  cp5.addButton("zone3")
     .setPosition(255,474)
     .setImages(zone3)     
     .updateSize()
     ;
     
  cp5.addButton("zone4")
     .setPosition(39,529)
     .setImages(zone4)     
     .updateSize()
     ;
     
  cp5.addButton("zone5")
     .setPosition(147,529)
     .setImages(zone5)     
     .updateSize()
     ;
     
  cp5.addButton("zone6")
     .setPosition(255,529)
     .setImages(zone6)     
     .updateSize()
     ;
     
  cp5.addButton("zone7")
     .setPosition(39,583)
     .setImages(zone7)     
     .updateSize()
     ;
     
  cp5.addButton("zone8")
     .setPosition(147,583)
     .setImages(zone8)     
     .updateSize()
     ;
     
  cp5.addButton("zone9")
     .setPosition(255,583)
     .setImages(zone9)     
     .updateSize()
     ;
     
  cp5.addButton("url")
     .setPosition(10,5)
     .setImages(url)
     .updateSize()
     ;
     
  cp5.addButton("speed1")
     .setPosition(124,353)
     .setImages(speed1)
     .updateSize()
     ;
     
  cp5.addButton("speed2")
     .setPosition(155,353)
     .setImages(speed2)
     .updateSize()
     ;

  cp5.addButton("speed3")
     .setPosition(185,353)
     .setImages(speed3)
     .updateSize()
     ;

  cp5.addButton("speed4")
     .setPosition(215,353)
     .setImages(speed4)
     .updateSize()
     ;

  cp5.addButton("speed5")
     .setPosition(245,353)
     .setImages(speed5)
     .updateSize()
     ;

  cp5.addButton("camera1")
     .setPosition(124,97)
     .setImages(camera1)     
     .updateSize()
     ;
  cp5.addButton("camera2")
     .setPosition(201,97)
     .setImages(camera2)     
     .updateSize()
     ;
  defaultButton = cp5.addButton("defaultButton")
     .setPosition(73,6)
     .setImage(dropdown1)
     .updateSize()
     .bringToFront()
     ;
     
  ipKentMain = cp5.addButton("Kent_Main")
     .setPosition(73,33)
     .setImage(dropdown2)
     .updateSize()
     .bringToFront()
     .hide()
     ;
          
  ipKentStark = cp5.addButton("Kent_Stark")
     .setPosition(73,60)
     .setImage(dropdown4)
     .updateSize()
     .bringToFront()
     .hide()
     ;
     
  ipKentTusc = cp5.addButton("Kent_Tusc")
     .setPosition(73,87)
     .setImage(dropdown3)
     .updateSize()
     .bringToFront()
     .hide()
     ;

}
public void defaultButton(){
  if(conStat == 0){
    if(dropdownState == 0){
      ipKentMain.show();
      ipKentStark.show();
      ipKentTusc.show();
      //debug_Local.show();
      dropdownState = 1;
    }
    else{
      ipKentMain.hide();
      ipKentStark.hide();
      ipKentTusc.hide();
      //debug_Local.hide();
      
      dropdownState = 0;
    }
  }
  
}

//Dropdown Menu Buttons
public void Kent_Main(){
  if(conStat == 0){
    ipKentMain.hide();
    ipKentStark.hide();
    ipKentTusc.hide();
    //debug_Local.hide();
    dropdownState = 0;
    defaultButton.setImage(dropdown2);
    serverIP = "131.123.147.223";
  }
}

public void Kent_Stark(){
  if(conStat == 0){
    ipKentMain.hide();
    ipKentStark.hide();
    ipKentTusc.hide();
    //debug_Local.hide();
    dropdownState = 0;
    defaultButton.setImage(dropdown4);
    serverIP = "131.123.123.149";
  }
}

public void Kent_Tusc(){
  if(conStat == 0){
    ipKentMain.hide();
    ipKentStark.hide();
    ipKentTusc.hide();
    //debug_Local.hide();
    dropdownState = 0;
    defaultButton.setImage(dropdown3);
    serverIP = "131.123.129.19";
  }
}

//Speed Changes
public void speed1(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Speed 1 Command, Please Wait!");
    output.append("A");
    outCheckError();
    read=1;
  }  
}

public void speed2(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Speed 2 Command, Please Wait!");
    output.append("B");
    outCheckError();
    read=1;
  }  
}

public void speed3(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Speed 3 Command, Please Wait!");
    output.append("C");
    outCheckError();
    read=1;
  }  
}

public void speed4(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Speed 4 Command, Please Wait!");
    output.append("D");
    outCheckError();
    read=1;
  }  
}

public void speed5(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Speed 5 Command, Please Wait!");
    output.append("E");
    outCheckError();
    read=1;
  }  
}


//Camera Selection
public void camera1(){
  if(conStat == 1 && read == 0){
    camStatus.setText("Attempting Camera 1 Connection...");
      output.append("G");
      outCheckError();
      read=1;
      camStat = 1;
      camSelected = 1;
  }
}

public void camera2(){
  if(conStat == 1 && read == 0){
    camStatus.setText("Attempting Camera 2 Connection...");
      output.append("H");
      outCheckError();
      read=1;
      camStat = 1;
      camSelected = 2;
  }
}

public void url(){
  link("http://ksuengtech.com/camera.html");
}

//Directional Buttons
public void up(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Up Command, Please Wait!");
    output.append("3");
    outCheckError();
    read=1;
  }  
}

public void down(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Down Command, Please Wait!");
    output.append("4");
    outCheckError();
    read=1;
  }  
}

public void left(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Left Command, Please Wait!");
    output.append("5");
    outCheckError();
    read=1;
  }  
}

public void right(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Right Command, Please Wait!");
    output.append("6");
    outCheckError();
    read=1;
  }
}

public void home(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Home Command, Please Wait!");
    output.append("7");
    outCheckError();
    read=1;
  }
}

//Zoom Buttons
public void zoomin(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Zoom In Command, Please Wait!");
    output.append("8");
    outCheckError();
    read=1;
  }
}

public void zoomout(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Zoom Out Command, Please Wait!");
    output.append("9");
    outCheckError();
    read=1;
  }
}


//Zone Buttons
public void zone1(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Zone 1 Command, Please Wait!");
    output.append("k");
    outCheckError();
    read=1;
  }
}

public void zone2(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Zone 2 Command, Please Wait!");
    output.append("l");
    outCheckError();
    read=1;
  }
}

public void zone3(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Zone 3 Command, Please Wait!");
    output.append("m");
    outCheckError();
    read=1;
  }
}

public void zone4(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Zone 4 Command, Please Wait!");
    output.append("n");
    outCheckError();
    read=1;
  }
}

public void zone5(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Zone 5 Command, Please Wait!");
    output.append("o");
    outCheckError();
    read=1;
  }
}

public void zone6(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Zone 6 Command, Please Wait!");
    output.append("p");
    outCheckError();
    read=1;
  }
}

public void zone7(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Zone 7 Command, Please Wait!");
    output.append("q");
    outCheckError();
    read=1;
  }
}

public void zone8(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Zone 8 Command, Please Wait!");
    output.append("r");
    outCheckError();
    read=1;
  }
}

public void zone9(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Zone 9 Command, Please Wait!");
    output.append("s");
    outCheckError();
    read=1;
  }
}

//Focus Buttons
public void focusAuto(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Auto-Focus Command, Please Wait!");
    output.append("u");
    outCheckError();
    read=1;
  }
}

public void focusManual(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Manual-Focus Command, Please Wait!");
    output.append("v");
    outCheckError();
    read=1;
  }
}

public void focusNear(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Near-Focus Command, Please Wait!");
    output.append("w");
    outCheckError();
    read=1;
  }
}

public void focusFar(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Far-Focus Command, Please Wait!");
    output.append("x");
    outCheckError();
    read=1;
  }
}

public void set1(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Set 1 Command, Please Wait!");
    output.append("a");
    outCheckError();
    read=1;
  }
}

public void set2(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Set 2 Command, Please Wait!");
    output.append("b");
    outCheckError();
    read=1;
  }
}

public void set3(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Set 3 Command, Please Wait!");
    output.append("c");
    outCheckError();
    read=1;
  }
}

public void set4(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Set 4 Command, Please Wait!");
    output.append("d");
    outCheckError();
    read=1;
  }
}

public void set5(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Set 5 Command, Please Wait!");
    output.append("e");
    outCheckError();
    read=1;
  }
}

public void set6(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Set 6 Command, Please Wait!");
    output.append("f");
    outCheckError();
    read=1;
  }
}

public void set7(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Set 7 Command, Please Wait!");
    output.append("g");
    outCheckError();
    read=1;
  }
}

public void set8(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Set 8 Command, Please Wait!");
    output.append("h");
    outCheckError();
    read=1;
  }
}

public void set9(){
  if(read == 0 && camStat != 0){
    camStatus.setText("Sending Set 9 Command, Please Wait!");
    output.append("i");
    outCheckError();
    read=1;
  }
}

void draw(){
  background(bg);

  if(read == 1)
    camReading();
}

//Connection buttons
public void connect(){
  if(conStat == 0){
    camStatus.setText("Starting Connection, Please Wait!");
    try{
      camConnect = new Socket();
      camConnect.connect(new InetSocketAddress(serverIP,25559),5000);
      camConnect.setSoTimeout(10);  
      out = camConnect.getOutputStream();
      in = camConnect.getInputStream();
      output = new PrintWriter(out);
      connectButton.hide();
      disconnectButton.show();
      conStat = 1;
      read = 1;
    }
    catch(UnknownHostException e){
      e.printStackTrace();
      camStatus.setText("Failed to connect!  Check server and try again.");
      read = 0;
      conStat = 0;
    }
    catch(IOException e){
      e.printStackTrace();
      camStatus.setText("Failed to connect!  Check server and try again.");
      read = 0;
      conStat = 0;
    }
  }
}

public void disconnect(){
  if(conStat == 1){
    camStat=0;
    //r.deactivateAll();
    try{
    camConnect.close();
    }
    catch (UnknownHostException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
        println(e.getCause());
    } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
    camStatus.setText("Disconnected");
    conStat = 0;
    connectButton.show();
    disconnectButton.hide();
  }  
}

/****************************************
  Determines whther or not the actual
  commands were sent correctly.  If not,
  connection has been lost and
  reconnection will be required.
****************************************/
public void outCheckError(){
  if(output.checkError() == true){
    camStat=0;
    //r.deactivateAll();
    conStat = 0;
    connectButton.show();
    disconnectButton.hide();
    camStatus.setText("Lost Connection.");
    //println("LOST CONNECTION!");
    try{
      camConnect.close();
    }
    catch (UnknownHostException e) {
        return;
    } catch (IOException e) {
        return;
    }
      
  }
}

public void resetCamSelection(){
  camStat = 0;
}

public void camReading(){
  try{
  BufferedReader input = new BufferedReader(new InputStreamReader(camConnect.getInputStream()));
  if(input.ready() == true){
    int inputRead = input.read();
    
    switch(inputRead) {
      case 50:
        camStatus.setText("Connected!  Please Select A Camera.");
        conStat = 1;
        break;
      case 51:
        camStatus.setText("Camera Up, Command Complete.");
        break;        
      case 52:
        camStatus.setText("Camera Down, Command Complete.");
        break;        
      case 53:
        camStatus.setText("Camera Left, Command Complete.");
        break;        
      case 54:
        camStatus.setText("Camera Right, Command Complete.");
        break;        
      case 55:
        camStatus.setText("Camera Home, Command Complete.");
        break;
      case 56:
        camStatus.setText("Camera Zoom In, Command Complete.");
        break;
      case 57:
        camStatus.setText("Camera Zoom Out, Command Complete.");
        break;
      case 65:
        camStatus.setText("Speed Change 1 Complete.");
        break;
      case 66:
        camStatus.setText("Speed Change 2 Complete.");
        break;
      case 67:
        camStatus.setText("Speed Change 3 Complete.");
        break;
      case 68:
        camStatus.setText("Speed Change 4 Complete.");
        break;
      case 69:
        camStatus.setText("Speed Change 5 Complete.");
        break;
      case 71:
        camStatus.setText("Success. Camera 1 Active!");
        break;
      case 72:
        camStatus.setText("Success. Camera 2 Active!");
        break;
      case 90:
        camStatus.setText("Failed camera connection! Check Camera!");
        camStat = 0;
        camSelected = 0;
        break;
      case 97:
        camStatus.setText("Camera Set 1, Command Complete.");
        break;
      case 98:
        camStatus.setText("Camera Set 2, Command Complete.");
        break;
      case 99:
        camStatus.setText("Camera Set 3, Command Complete.");
        break;
      case 100:
        camStatus.setText("Camera Set 4, Command Complete.");
        break;
      case 101:
        camStatus.setText("Camera Set 5, Command Complete.");
        break;
      case 102:
        camStatus.setText("Camera Set 6, Command Complete.");
        break;
      case 103:
        camStatus.setText("Camera Set 7, Command Complete.");
        break;
      case 104:
        camStatus.setText("Camera et 8, Command Complete.");
        break;
      case 105:
        camStatus.setText("Camera Set 9, Command Complete.");
        break;
      case 107:
        camStatus.setText("Camera Zone 1, Command Complete.");
        break;
      case 108:
        camStatus.setText("Camera Zone 2, Command Complete.");
        break;
      case 109:
        camStatus.setText("Camera Zone 3, Command Complete.");
        break;
      case 110:
        camStatus.setText("Camera Zone 4, Command Complete.");
        break;
      case 111:
        camStatus.setText("Camera Zone 5, Command Complete.");
        break;
      case 112:
        camStatus.setText("Camera Zone 6, Command Complete.");
        break;
      case 113:
        camStatus.setText("Camera Zone 7, Command Complete.");
        break;
      case 114:
        camStatus.setText("Camera Zone 8, Command Complete.");
        break;
      case 115:
        camStatus.setText("Camera Zone 9, Command Complete.");
        break;     
      case 117:
        camStatus.setText("Camera Auto Focus, Command Complete.");
        break;
      case 118:
        camStatus.setText("Camera Manual Focus, Command Complete.");
        break;
      case 119:
        camStatus.setText("Camera Focus Near, Command Complete.");
        break;
      case 120:
        camStatus.setText("Camera Focus Far, Command Complete.");
        break;    
      default:
        break;
    }
    read=0;    
  }
  }
  catch (UnknownHostException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
  } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
  }
}
