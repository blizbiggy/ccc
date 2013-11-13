import controlP5.*;
import java.io.*;
import java.net.*;
import java.lang.ClassNotFoundException;
import android.view.inputmethod.InputMethodManager;
import android.content.Context;
import android.app.Activity;
import android.content.res.Configuration;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.content.pm.ActivityInfo;

ControlP5 cp5;

DropdownList d1;

String serverIP = "";
float valueOfDropdown = 1.0;
String dropdownGroupName;

PrintWriter output;
Socket camConnect;
OutputStream out;
InputStream in;

Textlabel camStatus;
Button disconnectButton;
Button connectButton;
Button upButton;
Button downButton;
Button homeButton;
Button leftButton;
Button rightButton;
Button zoominButton;
Button zoomoutButton;
Button focusautoButton;
Button focusmanualButton;
Button focusnearButton;
Button focusfarButton;
Button urlButton;
Button speed1Button;
Button speed2Button;
Button speed3Button;
Button speed4Button;
Button speed5Button;
Button zone1Button;
Button zone2Button;
Button zone3Button;
Button zone4Button;
Button zone5Button;
Button zone6Button;
Button zone7Button;
Button zone8Button;
Button zone9Button;
Button camera1;
Button camera2;

PImage[][] images = new PImage[34][3];  //Initializes the images

//Default locations of the 2160x3840 image (4K Resolution in 9:16 aspect)
int[][] layoutInitPosition = {  {1806,32},    //Connect
                                {1806,32},    //Disconnect
                                {898,777},    //Up
                                {898,1528},   //Down
                                {508,1169},   //Left
                                {1259,1169},  //Right
                                {898,1169},   //Home
                                {1649,946},   //Zoom-In
                                {1649,1355},  //Zoom-Out
                                {294,946},    //Focus Auto
                                {294,1355},   //Focus Manual
                                {124,1560},   //Focus Near
                                {124,1355},   //Focus Far
                                {214,2566},   //Zone 1
                                {797,2566},   //Zone 2
                                {1379,2566},  //Zone 3
                                {214,2859},   //Zone 4
                                {797,2859},   //Zone 5
                                {1379,2859},  //Zone 6
                                {214,3152},   //Zone 7
                                {797,3152},   //Zone 8
                                {1379,3152},  //Zone 9
                                {58,32},      //URL and/or Info
                                {675,1920},   //Speed 1
                                {844,1920},   //Speed 2
                                {1004,1920},  //Speed 3
                                {1164,1920},  //Speed 4
                                {1324,1920},  //Speed 5
                                {392,32},     //Dropdown Init
                                {392,179},    //Dropdown Kent Main
                                {392,326},    //Dropdown Kent Stark
                                {392,473},    //Dropdown Kent Tusc
                                {675,526},    //Camera 1
                                {1084,526},   //Camera 2
                                {392,188}  }; //Status
                                
int[][] layoutNewPosition =  {  {0,0},     //1 Connect
                                {0,0},     //2 Disconnect
                                {0,0},     //3 Up
                                {0,0},     //4 Down
                                {0,0},     //5 Left
                                {0,0},     //6 Right
                                {0,0},     //7 Home
                                {0,0},     //8 Zoom-In
                                {0,0},     //9 Zoom-Out
                                {0,0},     //10 Focus Auto
                                {0,0},     //11 Focus Manual
                                {0,0},     //12 Focus Near
                                {0,0},     //13 Focus Far
                                {0,0},     //14 Zone 1
                                {0,0},     //15 Zone 2
                                {0,0},     //16 Zone 3
                                {0,0},     //17 Zone 4
                                {0,0},     //18 Zone 5
                                {0,0},     //19 Zone 6
                                {0,0},     //20 Zone 7
                                {0,0},     //21 Zone 8
                                {0,0},     //22 Zone 9
                                {0,0},     //23 URL and/or Info
                                {0,0},     //24 Speed 1
                                {0,0},     //25 Speed 2
                                {0,0},     //26 Speed 3
                                {0,0},     //27 Speed 4
                                {0,0},     //28 Speed 5
                                {0,0},     //29 Dropdown Init
                                {0,0},     //30 Dropdown Kent Main
                                {0,0},     //31 Dropdown Kent Stark
                                {0,0},     //32 Dropdown Kent Tusc
                                {0,0},     //33 Camera 1
                                {0,0},     //34 Camera 2
                                {0,0}  };  //35 Status                               

Group ipDropdownList;
Button ipKentMain;
Button ipKentStark;
Button ipKentTusc;
Button debug_Local;

Button defaultButton;

int realWidth;
int realHeight;
int firstCheck;
int Speed = 100;
int prev = 1;
int camStat = 0;
int camSelected = 0;
long checkTimeout = 0;

int read=0;
int conStat = 0;
PImage bg;

int dropdownState = 0;

void setup(){
  orientation(PORTRAIT); //Force Screen to portrait
  size(displayWidth, displayHeight); //Set Screen Size

  //Initialize CP5
  cp5 = new ControlP5(this, new ControlFont(createFont("Arial",35, false)));

  /*************************************
    Load images in the 2D Array.
    First array is the selector for the
    appropriate button.  The second
    array  is for the images to use.
    The first image [0] is the default
    state image.  The image [1] is the
    selected image.  The image [2] is 
    the active image.
  **************************************/
  bg = loadImage("bg-1200_1824.png");
  images[0][0] = loadImage("connect.png");
  images[0][1] = loadImage("connect.png");
  images[0][2] = loadImage("connect.png");
  images[1][0] = loadImage("connect.png");//disconnect
  images[1][1] = loadImage("connect.png");//disconnect
  images[1][2] = loadImage("connect.png");//disconnect
  images[2][0] = loadImage("up.png");
  images[2][1] = loadImage("up.png");
  images[2][2] = loadImage("up.png");
  images[3][0] = loadImage("down.png");
  images[3][1] = loadImage("down.png");
  images[3][2] = loadImage("down.png");
  images[4][0] = loadImage("left.png");
  images[4][1] = loadImage("left.png");
  images[4][2] = loadImage("left.png");
  images[5][0] = loadImage("right.png");
  images[5][1] = loadImage("right.png");
  images[5][2] = loadImage("right.png");
  images[6][0] = loadImage("home.png");
  images[6][1] = loadImage("home.png");
  images[6][2] = loadImage("home.png");
  images[7][0] = loadImage("zoomin.png");
  images[7][1] = loadImage("zoomin.png");
  images[7][2] = loadImage("zoomin.png");
  images[8][0] = loadImage("zoomout.png");
  images[8][1] = loadImage("zoomout.png");
  images[8][2] = loadImage("zoomout.png");
  images[9][0] = loadImage("focusauto.png");
  images[9][1] = loadImage("focusauto.png");
  images[9][2] = loadImage("focusauto.png");
  images[10][0] = loadImage("focusmanual.png");
  images[10][1] = loadImage("focusmanual.png");
  images[10][2] = loadImage("focusmanual.png");
  images[11][0] = loadImage("focusnear.png");
  images[11][1] = loadImage("focusnear.png");
  images[11][2] = loadImage("focusnear.png");
  images[12][0] = loadImage("focusfar.png");
  images[12][1] = loadImage("focusfar.png");
  images[12][2] = loadImage("focusfar.png");
  images[13][0] = loadImage("zone1.png");
  images[13][1] = loadImage("zone1.png");
  images[13][2] = loadImage("zone1.png");
  images[14][0] = loadImage("zone2.png");
  images[14][1] = loadImage("zone2.png");
  images[14][2] = loadImage("zone2.png");
  images[15][0] = loadImage("zone3.png");
  images[15][1] = loadImage("zone3.png");
  images[15][2] = loadImage("zone3.png");
  images[16][0] = loadImage("zone4.png");
  images[16][1] = loadImage("zone4.png");
  images[16][2] = loadImage("zone4.png");
  images[17][0] = loadImage("zone5.png");
  images[17][1] = loadImage("zone5.png");
  images[17][2] = loadImage("zone5.png");
  images[18][0] = loadImage("zone6.png");
  images[18][1] = loadImage("zone6.png");
  images[18][2] = loadImage("zone6.png");
  images[19][0] = loadImage("zone7.png");
  images[19][1] = loadImage("zone7.png");
  images[19][2] = loadImage("zone7.png");
  images[20][0] = loadImage("zone8.png");
  images[20][1] = loadImage("zone8.png");
  images[20][2] = loadImage("zone8.png");
  images[21][0] = loadImage("zone9.png");
  images[21][1] = loadImage("zone9.png");
  images[21][2] = loadImage("zone9.png");
  images[22][0] = loadImage("info.png");
  images[22][1] = loadImage("info.png");
  images[22][2] = loadImage("info.png");
  images[23][0] = loadImage("speed1.png");
  images[23][1] = loadImage("speed1.png");
  images[23][2] = loadImage("speed1.png");
  images[24][0] = loadImage("speed2.png");
  images[24][1] = loadImage("speed2.png");
  images[24][2] = loadImage("speed2.png");
  images[25][0] = loadImage("speed3.png");
  images[25][1] = loadImage("speed3.png");
  images[25][2] = loadImage("speed3.png");
  images[26][0] = loadImage("speed4.png");
  images[26][1] = loadImage("speed4.png");
  images[26][2] = loadImage("speed4.png");
  images[27][0] = loadImage("speed5.png");
  images[27][1] = loadImage("speed5.png");
  images[27][2] = loadImage("speed5.png");
  images[28][0] = loadImage("dropdown1.png");//default
  images[28][1] = loadImage("dropdown1.png");//default
  images[28][2] = loadImage("dropdown1.png");//default
  images[29][0] = loadImage("dropdown2.png");//main
  images[29][1] = loadImage("dropdown2.png");//main
  images[29][2] = loadImage("dropdown2.png");//main
  images[30][0] = loadImage("dropdown4.png");//stark
  images[30][1] = loadImage("dropdown4.png");//stark
  images[30][2] = loadImage("dropdown4.png");//stark
  images[31][0] = loadImage("dropdown3.png");//tusc
  images[31][1] = loadImage("dropdown3.png");//tusc
  images[31][2] = loadImage("dropdown3.png");//tusc
  images[32][0] = loadImage("camera1.png");
  images[32][1] = loadImage("camera1.png");
  images[32][2] = loadImage("camera1.png");
  images[33][0] = loadImage("camera2.png");
  images[33][1] = loadImage("camera2.png");
  images[33][2] = loadImage("camera2.png");

  //Call Change Size of Images and their positioning.
  changeSize();
  
  //Display Buttons and other Elements
  camStatus = cp5.addTextlabel("serialStatus")
                 .setText("Waiting for user connection to camera...")
                 .setPosition(layoutNewPosition[34][0],layoutNewPosition[34][1])
                 .setColorValue(0xffffffff)
                    ;  
  
  connectButton = cp5.addButton("connect")
               .setPosition(layoutNewPosition[0][0],layoutNewPosition[0][1])
               .setImages(images[0])     
               .updateSize()
               ;

  disconnectButton = cp5.addButton("disconnect")
                  .setPosition(layoutNewPosition[1][0],layoutNewPosition[1][1])
                  .setImages(images[1])     
                  .updateSize()
                  .hide()
                  ;
  camera1 = cp5.addButton("camera1")
               .setPosition(layoutNewPosition[32][0],layoutNewPosition[32][1])
               .setImages(images[32])     
               .updateSize()
               ;
  camera2 = cp5.addButton("camera2")
               .setPosition(layoutNewPosition[33][0],layoutNewPosition[33][1])
               .setImages(images[33])     
               .updateSize()
               ;

  upButton = cp5.addButton("up")
     .setPosition(layoutNewPosition[2][0],layoutNewPosition[2][1])
     .setImages(images[2])
     .updateSize()
     //.hide()
     ;
     
  downButton = cp5.addButton("down")
     .setPosition(layoutNewPosition[3][0],layoutNewPosition[3][1])
     .setImages(images[3])     
     .updateSize()
     //.hide()
     ;
     
  homeButton = cp5.addButton("home")
     .setPosition(layoutNewPosition[6][0],layoutNewPosition[6][1])
     .setImages(images[6])     
     .updateSize()
     //.hide()
     ;     

  leftButton = cp5.addButton("left")
     .setPosition(layoutNewPosition[4][0],layoutNewPosition[4][1])
     .setImages(images[4])     
     .updateSize()
     //.hide()
     ;
     
  rightButton = cp5.addButton("right")
     .setPosition(layoutNewPosition[5][0],layoutNewPosition[5][1])
     .setImages(images[5])     
     .updateSize()
     //.hide()
     ;
  zoominButton = cp5.addButton("zoomin")
     .setPosition(layoutNewPosition[7][0],layoutNewPosition[7][1])
     .setImages(images[7])     
     .updateSize()
     //.hide()
     ;
     
  zoomoutButton = cp5.addButton("zoomout")
     .setPosition(layoutNewPosition[8][0],layoutNewPosition[8][1])
     .setImages(images[8])     
     .updateSize()
     //.hide()
     ;
  focusautoButton = cp5.addButton("focusAuto")
     .setPosition(layoutNewPosition[9][0],layoutNewPosition[9][1])
     .setImages(images[9])     
     .updateSize()
     //.hide()
     ;
     
  focusmanualButton = cp5.addButton("focusManual")
     .setPosition(layoutNewPosition[10][0],layoutNewPosition[10][1])
     .setImages(images[10])     
     .updateSize()
     //.hide()
     ;
     
  focusnearButton = cp5.addButton("focusNear")
     .setPosition(layoutNewPosition[11][0],layoutNewPosition[11][1])
     .setImages(images[11])     
     .updateSize()
     //.hide()
     ;
     
  focusfarButton = cp5.addButton("focusFar")
     .setPosition(layoutNewPosition[12][0],layoutNewPosition[12][1])
     .setImages(images[12])     
     .updateSize()
     //.hide()
     ;     
     
  zone1Button = cp5.addButton("zone1")
     .setPosition(layoutNewPosition[13][0],layoutNewPosition[13][1])
     .setImages(images[13])     
     .updateSize()
     //.hide()
     ;
     
  zone2Button = cp5.addButton("zone2")
     .setPosition(layoutNewPosition[14][0],layoutNewPosition[14][1])
     .setImages(images[14])     
     .updateSize()
     //.hide()
     ;
     
  zone3Button = cp5.addButton("zone3")
     .setPosition(layoutNewPosition[15][0],layoutNewPosition[15][1])
     .setImages(images[15])     
     .updateSize()
     //.hide()
     ;
     
  zone4Button = cp5.addButton("zone4")
     .setPosition(layoutNewPosition[16][0],layoutNewPosition[16][1])
     .setImages(images[16])     
     .updateSize()
     //.hide()
     ;
     
  zone5Button = cp5.addButton("zone5")
     .setPosition(layoutNewPosition[17][0],layoutNewPosition[17][1])
     .setImages(images[17])     
     .updateSize()
     //.hide()
     ;
     
  zone6Button = cp5.addButton("zone6")
     .setPosition(layoutNewPosition[18][0],layoutNewPosition[18][1])
     .setImages(images[18])     
     .updateSize()
     //.hide()
     ;
     
  zone7Button = cp5.addButton("zone7")
     .setPosition(layoutNewPosition[19][0],layoutNewPosition[19][1])
     .setImages(images[19])     
     .updateSize()
     //.hide()
     ;
     
  zone8Button = cp5.addButton("zone8")
     .setPosition(layoutNewPosition[20][0],layoutNewPosition[20][1])
     .setImages(images[20])   
     .updateSize()
     //.hide()
     ;
     
  zone9Button = cp5.addButton("zone9")
     .setPosition(layoutNewPosition[21][0],layoutNewPosition[21][1])
     .setImages(images[21])     
     .updateSize()
     //.hide()
     ;
     
  urlButton = cp5.addButton("url")
     .setPosition(layoutNewPosition[22][0],layoutNewPosition[22][1])
     .setImages(images[22])
     .updateSize()
     ;
     
  speed1Button = cp5.addButton("speed1")
     .setPosition(layoutNewPosition[23][0],layoutNewPosition[23][1])
     .setImages(images[23])
     .updateSize()
     //.hide()
     ;
     
  speed2Button = cp5.addButton("speed2")
     .setPosition(layoutNewPosition[24][0],layoutNewPosition[24][1])
     .setImages(images[24])
     .updateSize()
     //.hide()
     ;

  speed3Button = cp5.addButton("speed3")
     .setPosition(layoutNewPosition[25][0],layoutNewPosition[25][1])
     .setImages(images[25])
     .updateSize()
     //.hide()
     ;

  speed4Button = cp5.addButton("speed4")
     .setPosition(layoutNewPosition[26][0],layoutNewPosition[26][1])
     .setImages(images[26])
     .updateSize()
     //.hide()
     ;

  speed5Button = cp5.addButton("speed5")
     .setPosition(layoutNewPosition[27][0],layoutNewPosition[27][1])
     .setImages(images[27])
     .updateSize()
     //.hide()
     ;

  cp5.addButton("connection")
     .setPosition(80,420)
     .setImages(images[0])
     .updateSize()
     .hide()
     ;

  cp5.addButton("controls")
     .setPosition(165,420)
     .setImages(images[0])
     .updateSize()
     .hide()
     ;

  cp5.addButton("zones")
     .setPosition(250,420)
     .setImages(images[0])
     .updateSize()
     .hide()
     ;

  defaultButton = cp5.addButton("defaultButton")
     .setPosition(layoutNewPosition[28][0],layoutNewPosition[28][1])
     .setImages(images[28])
     .updateSize()
     .bringToFront()
     ;
     
  ipKentMain = cp5.addButton("Kent_Main")
     .setPosition(layoutNewPosition[29][0],layoutNewPosition[29][1])
     .setImages(images[29])
     .updateSize()
     .bringToFront()
     .hide()
     ;
          
  ipKentStark = cp5.addButton("Kent_Stark")
     .setPosition(layoutNewPosition[30][0],layoutNewPosition[30][1])
     .setImages(images[30])
     .updateSize()
     .bringToFront()
     .hide()
     ;
     
  ipKentTusc = cp5.addButton("Kent_Tusc")
     .setPosition(layoutNewPosition[31][0],layoutNewPosition[31][1])
     .setImages(images[31])
     .updateSize()
     .bringToFront()
     .hide()
     ;

  debug_Local = cp5.addButton("debug_Local")
     .setPosition(392,620)
     .setImages(images[28])
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

public void changeSize(){
  float scaleWidth = 2160.00000/float(displayWidth);
  float scaleHeight = 3840.00000/float(displayHeight);
  float imgNewWidth, imgNewHeight, imgNewX, imgNewY;  
  int intNewWidth, intNewHeight, intNewX, intNewY;
  
  for(int i = 0; i < 34; i++){
    
    imgNewWidth = float(images[i][0].width)/scaleWidth;
    imgNewHeight = float(images[i][0].height)/scaleHeight;
    imgNewX = float(layoutInitPosition[i][0])/scaleWidth;
    imgNewY = float(layoutInitPosition[i][1])/scaleHeight;
    
    intNewWidth = int(imgNewWidth);
    intNewHeight = int(imgNewHeight);
    intNewX = int(imgNewX);
    intNewY = int(imgNewY);
    
    for(int j = 0; j < 3; j++){
      images[i][j].resize(intNewWidth,intNewHeight);
      images[i][j].loadPixels();
      images[i][j].updatePixels();
    }
    
    layoutNewPosition[i][0] = intNewX;
    layoutNewPosition[i][1] = intNewY;
  }
  
  imgNewX = float(layoutInitPosition[34][0])/scaleWidth;
  imgNewY = float(layoutInitPosition[34][1])/scaleHeight;
  intNewX = int(imgNewX);
  intNewY = int(imgNewY);
  
  layoutNewPosition[34][0] = intNewX;
  layoutNewPosition[34][1] = intNewY;
}

//Connection 
public void connection(){
  if(read == 0){
    urlButton.show();
    
    if(conStat == 1){
      connectButton.hide();
      disconnectButton.show();
    }
    else{
      connectButton.show();
      disconnectButton.hide();
    }
    d1.show();
    
    upButton.hide();
    downButton.hide();
    homeButton.hide();
    leftButton.hide();
    rightButton.hide();
    
    zoominButton.hide();
    zoomoutButton.hide();
    
    focusautoButton.hide();
    focusmanualButton.hide();
    focusnearButton.hide();
    focusfarButton.hide();
    
    speed1Button.hide();
    speed2Button.hide();
    speed3Button.hide();
    speed4Button.hide();
    speed5Button.hide();
    
    zone1Button.hide();
    zone2Button.hide();
    zone3Button.hide();
    zone4Button.hide();
    zone5Button.hide();
    zone6Button.hide();
    zone7Button.hide();
    zone8Button.hide();
    zone9Button.hide();
    
  }  
}

public void controls(){
  if(read == 0 && conStat == 1){
    urlButton.hide();
    connectButton.hide();
    disconnectButton.hide();
    d1.hide();
    
    upButton.show();
    downButton.show();
    homeButton.show();
    leftButton.show();
    rightButton.show();
    
    zoominButton.show();
    zoomoutButton.show();
    
    focusautoButton.show();
    focusmanualButton.show();
    focusnearButton.show();
    focusfarButton.show();
    
    speed1Button.show();
    speed2Button.show();
    speed3Button.show();
    speed4Button.show();
    speed5Button.show();
    
    zone1Button.hide();
    zone2Button.hide();
    zone3Button.hide();
    zone4Button.hide();
    zone5Button.hide();
    zone6Button.hide();
    zone7Button.hide();
    zone8Button.hide();
    zone9Button.hide();
  }  
}

public void zones(){
  if(read == 0 && conStat == 1){
    
    urlButton.hide();
    connectButton.hide();
    disconnectButton.hide();
    d1.hide();
    
    upButton.hide();
    downButton.hide();
    homeButton.hide();
    leftButton.hide();
    rightButton.hide();
    
    zoominButton.hide();
    zoomoutButton.hide();
    
    focusautoButton.hide();
    focusmanualButton.hide();
    focusnearButton.hide();
    focusfarButton.hide();
    
    speed1Button.hide();
    speed2Button.hide();
    speed3Button.hide();
    speed4Button.hide();
    speed5Button.hide();
    
    zone1Button.show();
    zone2Button.show();
    zone3Button.show();
    zone4Button.show();
    zone5Button.show();
    zone6Button.show();
    zone7Button.show();
    zone8Button.show();
    zone9Button.show();
  }  
}

//Dropdown Menu Buttons
public void Kent_Main(){
  if(conStat == 0){
    ipKentMain.hide();
    ipKentStark.hide();
    ipKentTusc.hide();
    debug_Local.hide();
    dropdownState = 0;
    defaultButton.setImages(images[29]);
    serverIP = "";
  }
}

public void Kent_Stark(){
  if(conStat == 0){
    ipKentMain.hide();
    ipKentStark.hide();
    ipKentTusc.hide();
    debug_Local.hide();
    dropdownState = 0;
    defaultButton.setImages(images[30]);
    serverIP = "";
  }
}

public void Kent_Tusc(){
  if(conStat == 0){
    ipKentMain.hide();
    ipKentStark.hide();
    ipKentTusc.hide();
    debug_Local.hide();
    dropdownState = 0;
    defaultButton.setImages(images[31]);
    serverIP = "";
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
    camStatus.setText("Attempting Camera 1 Connection...");
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


void draw(){
  image(bg, 0, 0, displayWidth, displayHeight);  //Sets the background
  
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

/****************************************
  Reads the imput to determine whether
  or not the commands sent completed
  successfully, server side, or not 
  and to set the state of the commands
  in progress to completed.
****************************************/
public void camReading(){
  try{
  BufferedReader input = new BufferedReader(new InputStreamReader(camConnect.getInputStream()));
  if(input.ready() == true){
    int inputRead = input.read();
    switch(inputRead) {
      // 48-49 no longer used in V1.3X and beyond
      case 48:
        camStatus.setText("Camera Off, Command Complete.");
        break;
      case 49:
        camStatus.setText("Camera On, Command Complete.");
        break;
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
