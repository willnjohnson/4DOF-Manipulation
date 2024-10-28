import java.util.ArrayList;
import java.util.Collections;

// Primarily used to help better nudge the control buttons or center back to the control buttons if the panel moves
import java.awt.Robot;
import java.awt.AWTException;
import java.awt.MouseInfo;
import java.awt.Point;

// Pointer
Robot robot;
int pointerState = -1;
float offsetX, offsetY;

// =================PANEL VARIABLES=================
int panelX = 0;
int panelY = 0;
int panelWidth = 317;
int panelHeight = 102;
float panelYOffset = 0; // panel will by default appear at bottom, but may need to appear at top if the square is too close to the bottom

// =================PANEL CONTROL MODES=================  
enum Mode {
  REST, TRANSLATE, ROTATE, SCALE
}
Mode currentMode = Mode.REST;

// =================FLAGS=================  
boolean onSubmit = false;
boolean isSubmitHover = false;
boolean isPanelHover = false;
boolean isPanelDragged = false;
boolean isPanelBottom = true;
boolean isLogoHover = false;
boolean isLogoDragged = false;
boolean isDisabledBtnTranslateVertical = false;
boolean isDisabledBtnTranslateHorizontal = false;
boolean isOnTranslate = false;
boolean isOnRotate = false;
boolean isOnScale = false;

// =================INDICATOR STATUS (0=RED, 1=YELLOW, 2=GREEN)=================
// [IDEA 20] User square turns lime green when all indicators are correct
int indicatorTranslate = 0;
int indicatorRotate = 0;
int indicatorScale = 0;

//these are variables you should probably leave alone
int index = 0; //starts at zero-ith trial
float border = 0; //some padding from the sides of window, set later
int trialCount = 12; //this will be set higher for the bakeoff
int trialIndex = 0; //what trial are we on
int errorCount = 0;  //used to keep track of errors
float errorPenalty = 0.5f; //for every error, add this value to mean time
int startTime = 0; // time starts when the first click is captured
int finishTime = 0; //records the time of the final click
boolean userDone = false; //is the user done

final int screenPPI = 72; //what is the DPI of the screen you are using
//you can test this by drawing a 72x72 pixel rectangle in code, and then confirming with a ruler it is 1x1 inch. 

//These variables are for my example design. Your input code should modify/replace these!
float logoX = 500;
float logoY = 500;
float logoZ = 50f;
float logoRotation = 0;

private class Destination
{
  float x = 0;
  float y = 0;
  float rotation = 0;
  float z = 0;
}

ArrayList<Destination> destinations = new ArrayList<Destination>();

void setup() {
  size(1000, 800);  
  rectMode(CENTER);
  textFont(createFont("Arial", inchToPix(.3f))); //sets the font to Arial that is 0.3" tall
  textAlign(CENTER);
  rectMode(CENTER); //draw rectangles not from upper left, but from the center outwards
  cursor(CROSS);
  
  try {
    robot = new Robot();
  } catch (AWTException e) {
    e.printStackTrace();
  }
  
  //don't change this! 
  border = inchToPix(2f); //padding of 1.0 inches

  for (int i=0; i<trialCount; i++) //don't change this! 
  {
    Destination d = new Destination();
    d.x = random(border, width-border); //set a random x with some padding
    d.y = random(border, height-border); //set a random y with some padding
    d.rotation = random(0, 360); //random rotation between 0 and 360
    int j = (int)random(20);
    d.z = ((j%12)+1)*inchToPix(.25f); //increasing size from .25 up to 3.0" 
    destinations.add(d);
    println("created target with " + d.x + "," + d.y + "," + d.rotation + "," + d.z);
  }

  Collections.shuffle(destinations); // randomize the order of the button; don't change this.
}

void draw() {

  background(40); //background is dark grey
  fill(200);
  noStroke();

  //shouldn't really modify this printout code unless there is a really good reason to
  if (userDone)
  {
    cursor(ARROW);
    text("User completed " + trialCount + " trials", width/2, inchToPix(.4f));
    text("User had " + errorCount + " error(s)", width/2, inchToPix(.4f)*2);
    text("User took " + (finishTime-startTime)/1000f/trialCount + " sec per destination", width/2, inchToPix(.4f)*3);
    text("User took " + ((finishTime-startTime)/1000f/trialCount+(errorCount*errorPenalty)) + " sec per destination inc. penalty", width/2, inchToPix(.4f)*4);
    return;
  }
  
  // [IDEA 15b] Prevent user square from going off screen
  float logoCenter = logoZ / (logoZ/2);
  logoX = constrain(logoX, logoCenter, width - logoCenter);
  logoY = constrain(logoY, logoCenter, height - logoCenter);

  //===========DRAW DESTINATION SQUARES=================
  float targetSize = 0;
  for (int i=trialIndex; i<trialCount; i++) // reduces over time
  {
    pushMatrix();
    Destination d = destinations.get(i); //get destination trial
    translate(d.x, d.y); //center the drawing coordinates to the center of the destination trial
    rotate(radians(d.rotation)); //rotate around the origin of the destination trial
    noFill();
    strokeWeight(3f);
    if (trialIndex==i)
      stroke(255, 0, 0, 192); //set color to semi translucent
    else
      stroke(128, 128, 128, 128); //set color to semi translucent
    
    rect(0, 0, d.z, d.z);
    
    // add guides to the target
    if (trialIndex==i) {
      targetSize = d.z;
      drawCrosshair(d.z, color(255, 0, 0, 200), color(255, 0, 0));
      
      // [IDEA #1] Visual guide lines on TARGET square
      drawDashedGuideLines(d.z, color(255, 0, 0, 100), 2000, 6, 1);
    }
    
    popMatrix();
  }

  //===========DRAW LOGO SQUARE=================
  pushMatrix();
  translate(logoX, logoY); //translate draw center to the center oft he logo square
  rotate(radians(logoRotation)); //rotate using the logo square as the origin
  logoColor = (isLogoDragged) ? color(60, 60, 192, 70) : color(60, 60, 192, 192);
  
  noStroke();
  
  // [IDEA 20] User square turns lime green when all indicators are correct
  fill(checkForSuccess() ? deepLimeGreenSolid : logoColor);
  rect(0, 0, logoZ, logoZ);
  
  // [IDEA 5] Marching ants "selection" on user square
  if (mousePressed && isLogoDragged && currentMode == Mode.REST)   drawMarchingAnts(0, 0, logoZ, yellow, 3, 2);
  else                                                             drawMarchingAnts(0, 0, logoZ, yellow, 3, 1);
  
  // add white dot to center of logo square (with a fainter dot for extra visibility)
  noStroke();
  fill(255, 255, 255, 192);
  ellipse(0, 0, logoZ/16, logoZ/16);
  fill(255, 255, 255, 52);
  ellipse(0, 0, logoZ/8, logoZ/8);
  
  // [IDEA #1] Visual guide lines on USER square
  drawDashedGuideLines(logoZ, color(255, 255, 255, 50), 2000, 6, 1);
  popMatrix();

  //===========DRAW CONTROLS=================
  fill(255);
  controlLogic(); // replaces the scaffold control logic
  text("Trial " + (trialIndex+1) + " of " +trialCount, width/2, inchToPix(.8f));
  
  // [IDEA 19] Blinking timer
  timerDisplay();
}

void controlLogic()
{
  // =================CREATE PANEL=================  
  panel = createGraphics(panelWidth, panelHeight); // Create a groupbox
  panel.beginDraw();
  panel.background(255, 255, 255, 0); // Hide the rectangle
  drawPanel();
  panel.endDraw();
  
  // =================SET FLAGS=================  
  checkFlagsDraw();
  
  // =================SET DYNAMIC CURSOR================= 
  // [IDEA 8] Dynamic cursor icons
  setDynamicCursor();
  
  // =================DISPLAY PANEL=================  
  // [IDEA 10] Buttons contained within unified control panel
  // [IDEA 11] Control panel follows the user square
  // [IDEA 12] Panel buttons (up, down, left, right, +, -, CW, CCW) represented as three joysticks
  displayPanel();
}

void mousePressed()
{
  offsetX = logoX - mouseX;
  offsetY = logoY - mouseY;
  
  if (startTime == 0) //start time on the instant of the first user click
  {
    startTime = millis();
    println("time started!");
  }
}

void mouseReleased()
{
  checkFlagsMouseReleased();
  
  // [IDEA 9] Submit button
  if (onSubmit)
  {
    if (userDone==false && !checkForSuccess())
      errorCount++;

    trialIndex++; //and move on to next trial

    if (trialIndex==trialCount && userDone==false)
    {
      userDone = true;
      finishTime = millis();
    }
  }
}

void mouseDragged() {
  // [IDEA 4] Draggable user square
  checkFlagsMouseDragged();
}

//probably shouldn't modify this, but email me if you want to for some good reason.
public boolean checkForSuccess()
{
  Destination d = destinations.get(trialIndex);	
  boolean closeDist = dist(d.x, d.y, logoX, logoY)<inchToPix(.05f); //has to be within +-0.05"
  boolean closeRotation = calculateDifferenceBetweenAngles(d.rotation, logoRotation)<=5;
  boolean closeZ = abs(d.z - logoZ)<inchToPix(.1f); //has to be within +-0.1"	

  println("Close Enough Distance: " + closeDist + " (logo X/Y = " + d.x + "/" + d.y + ", destination X/Y = " + logoX + "/" + logoY +")");
  println("Close Enough Rotation: " + closeRotation + " (rot dist="+calculateDifferenceBetweenAngles(d.rotation, logoRotation)+")");
  println("Close Enough Z: " +  closeZ + " (logo Z = " + d.z + ", destination Z = " + logoZ +")");
  println("Close enough all: " + (closeDist && closeRotation && closeZ));

  return closeDist && closeRotation && closeZ;
}

//utility function I include to calc diference between two angles
double calculateDifferenceBetweenAngles(float a1, float a2)
{
  double diff=abs(a1-a2);
  diff%=90;
  if (diff>45)
    return 90-diff;
  else
    return diff;
}

//utility function to convert inches into pixels based on screen PPI
float inchToPix(float inch)
{
  return inch*screenPPI;
}
