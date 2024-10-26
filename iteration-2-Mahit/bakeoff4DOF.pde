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

// COLORS
color logoColor = color(60, 60, 192, 192);

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

int trialStartOffset = 0; //variable for timer by Mahit
//declared here globally for realtime guidelines of translation, scaling, and rotation--by Mahit
boolean closeDist;
boolean closeRotation;
boolean closeZ;

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
  }
  catch (AWTException e) {
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

  // Constrain logoX and logoY so the logo stays within screen bounds.--Added by Mahit
  logoX = constrain(logoX, logoZ / 2, width - logoZ / 2);
  logoY = constrain(logoY, logoZ / 2, height - logoZ / 2);

  //===========DRAW DESTINATION SQUARES=================
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
    popMatrix();
  }

  //===========REAL-TIME PROXIMITY CHECKS=================by Mahit
  Destination currentDest = destinations.get(trialIndex);
  boolean closeDist = dist(currentDest.x, currentDest.y, logoX, logoY) < inchToPix(.05f);
  boolean closeRotation = calculateDifferenceBetweenAngles(currentDest.rotation, logoRotation) <= 5;
  boolean closeZ = abs(currentDest.z - logoZ) < inchToPix(.1f);

  //===========DRAW LOGO SQUARE=================
  pushMatrix();
  translate(logoX, logoY); //translate draw center to the center oft he logo square
  rotate(radians(logoRotation)); //rotate using the logo square as the origin
  noStroke();

  // Turn square green if all parameters are correct, otherwise use default color--by Mahit
  if (closeDist && closeRotation && closeZ) {
    fill(color(0, 255, 0, 192)); // Green when all are close
  } else {
    fill(logoColor); // Default color if any condition isn't met
  }
  rect(0, 0, logoZ, logoZ);
  popMatrix();


  //===========DRAW CONTROLS=================
  fill(255);
  controlLogic(closeDist, closeRotation, closeZ); // Pass proximity checks to controlLogic for bubble coloring--by Mahit
  text("Trial " + (trialIndex+1) + " of " +trialCount, width/2, inchToPix(.8f));

  // Draw blinking timer
  timerDisplay(); //Call the blinking timer display function--by Mahit
  //timerDisplay2(); // Call the blinking timer display function
}

// Updated controlLogic function with proximity parameters
void controlLogic(boolean closeDist, boolean closeRotation, boolean closeZ) { //parameters added for realtime proximity checking--by Mahit
  panel = createGraphics(panelWidth, panelHeight);
  panel.beginDraw();
  panel.background(255, 255, 255, 0);

  // Pass proximity parameters to dynamically color bubbles--by Mahit
  drawPanel(closeDist, closeRotation, closeZ);
  panel.endDraw();

  // =================SET FLAGS=================
  checkFlagsDraw();

  // =================SET DYNAMIC CURSOR=================
  setDynamicCursor();

  // =================DISPLAY PANEL=================
  displayPanel();
}

void mousePressed()
{
  if (startTime == 0) //start time on the instant of the first user click
  {
    startTime = millis();
    println("time started!");
  }
}

void mouseReleased()
{
  checkFlagsMouseReleased();

  //check to see if user clicked submit button -- REPLACED: if (dist(width/2, height/2, mouseX, mouseY)<inchToPix(3f))
  if (onSubmit)
  {
    if (userDone==false && !checkForSuccess())
      errorCount++;

    trialIndex++; //and move on to next trial

    //updated for timer display--by Mahit
    if (trialIndex < trialCount) {
      trialStartOffset = millis(); // Set offset for the new trial
    } else if (trialIndex == trialCount && !userDone) {
      userDone = true;
      finishTime = millis();
    }
  }
}

void mouseDragged() {
  checkFlagsMouseDragged();
}

//timerDisplay() function to handle the blinking time of current trial--by Mahit
void timerDisplay() {
  int elapsedMillis = millis() - trialStartOffset; // Time since the start of the current trial
  int seconds = (elapsedMillis / 1000) % 60;
  int minutes = (elapsedMillis / (1000 * 60)) % 60;

  String timerText = nf(minutes, 2) + ":" + nf(seconds, 2);
  int currentSecond = seconds % 2;
  text("Trial " + (trialIndex+1) + " Elapsed Time: ", width / 2, inchToPix(1.2f));

  // Set color of time based on even/odd second
  fill(currentSecond == 0 ? color(255, 255, 255, 128) : color(255, 0, 0, 128));
  text(timerText, width / 1.55, inchToPix(1.2f)); // Display timer
}


//timerDisplay2() function to handle the blinking logic-overall time.--Added by Mahit

//void timerDisplay2() {
//  int elapsedTime = (millis() - startTime) / 1000; // Calculate elapsed time in seconds
//  int minutes = elapsedTime / 60; // Convert to minutes
//  int seconds = elapsedTime % 60; // Get remaining seconds

//  String timeString = nf(minutes, 2) + ":" + nf(seconds, 2); // Format as MM:SS

// Alternate colors for blinking effect
//if (seconds % 2 == 0) {
//fill(255, 255, 255, 128); // Semi-transparent white for even seconds
//} else {
//fill(255, 0, 0, 128); // Semi-transparent red for odd seconds
//}
//text("\n Total Time Elapsed: " + timeString, width / 2, inchToPix(1.2f)); // Centered display below trial text
//}


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
