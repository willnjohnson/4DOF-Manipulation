PGraphics panel;
PFont font;

String textSubmit = "✓";

// Colors used for the panel
int lightGray = color(220, 220, 220, 120);
int darkGraySolid = color(100, 100, 100);
int darkRedSolid = color(140, 0, 0);
int darkerGray = color(80, 80, 80, 200);
int lightLimeGreen = color(200, 255, 200, 200);
int deepLimeGreen = color(100, 200, 100, 200);
int deepLimeGreenSolid = color(100, 200, 100);
int white = color(255, 255, 255);
int red = color(200, 0, 0);

// For translate and scale
int btnTranslateOffX = 0;
int btnTranslateOffY = 0;
int btnScaleOffY = 0;

// For rotate
float radius = inchToPix(0.75)/2;
float angle = radians(225);
float initialAngle = radians(225);
float minAngle = radians(135);
float maxAngle = radians(315);
float rotX = panelX+175 + radius * cos(angle);
float rotY = panelY+75 + radius * sin(angle);
boolean isRotationDrag = false;

// Draw the panel
void drawPanel() {
  // Light gray horizontal panel
  panel.stroke(darkGraySolid);
  panel.strokeWeight(2);
  panel.fill(lightGray);
  panel.rect(25, 25, 410, 100, 100);

  // Button #1: Translate
  panel.fill(darkerGray);
  panel.stroke(darkGraySolid);
  panel.strokeWeight(2);
  panel.ellipse(75, 75, inchToPix(0.75), inchToPix(0.75));
  panel.stroke(lightGray);
  panel.strokeWeight(4);
  panel.line(75, 50, 75, 100);
  panel.line(50, 75, 100, 75);

  // Button #1's dot
  panel.fill(currentMode==Mode.TRANSLATE ? red : white);
  panel.stroke(currentMode==Mode.TRANSLATE ? darkRedSolid : darkGraySolid);
  panel.strokeWeight(2);
  panel.ellipse(75+btnTranslateOffX, 75+btnTranslateOffY, inchToPix(0.25), inchToPix(0.25));

  // Button #2: Rotate
  panel.fill(darkerGray);
  panel.stroke(darkGraySolid);
  panel.ellipse(175, 75, inchToPix(0.75), inchToPix(0.75));
  panel.stroke(deepLimeGreen);
  panel.strokeWeight(4);
  panel.ellipse(375, 75, inchToPix(0.4), inchToPix(0.4));
  panel.stroke(lightGray);
  panel.ellipse(175, 75, inchToPix(0.4), inchToPix(0.4));

  // Button #2's dot
  panel.fill(currentMode==Mode.ROTATE ? red : white);
  panel.stroke(currentMode==Mode.ROTATE ? darkRedSolid : darkGraySolid);
  panel.strokeWeight(2);
  panel.ellipse(175 + radius * cos(angle), 75 + radius * sin(angle), inchToPix(0.25), inchToPix(0.25));

  // Button #3: Scale
  panel.fill(darkerGray);
  panel.stroke(darkGraySolid);
  panel.rectMode(CENTER);
  panel.rect(275, 75, inchToPix(0.4), inchToPix(1.0), 10);
  panel.fill(lightGray);
  panel.stroke(lightGray);
  panel.strokeWeight(4);
  panel.line(275, 95, 275, 60);
  panel.textSize(inchToPix(0.25));
  panel.textAlign(CENTER, CENTER);
  panel.fill(white);
  panel.text("+", 275, 50); // Plus symbol on top
  panel.text("-", 275, 100); // Minus symbol on bottom
  
  // Button #3's dot
  panel.fill(currentMode==Mode.SCALE ? red : white);
  panel.stroke(currentMode==Mode.SCALE ? darkRedSolid : darkGraySolid);
  panel.strokeWeight(2);
  panel.ellipse(275, 75+btnScaleOffY, inchToPix(0.25), inchToPix(0.25));

  // Button #4: Submit
  panel.stroke(deepLimeGreenSolid);
  int submitC1;
  int submitC2;
  if (!isLogoDragged && dist(mouseX, mouseY, panelX+375, panelY+75) < inchToPix(0.75) / 2) {
    onSubmit = true;
    submitC1 = deepLimeGreen;
    submitC2 = lightLimeGreen;
  } else {
    onSubmit = false;
    submitC1 = lightLimeGreen;
    submitC2 = deepLimeGreen;
  }
  panel.fill(submitC1);
  panel.ellipse(375, 75, inchToPix(0.75), inchToPix(0.75));
  panel.stroke(submitC2);
  panel.strokeWeight(2);
  panel.ellipse(375, 75, inchToPix(0.6), inchToPix(0.6));
  panel.textSize(inchToPix(0.5));
  panel.textAlign(CENTER, CENTER);
  panel.fill(submitC2);
  panel.text(textSubmit, 375, 75);
}

// Display panel if user does not mouse press outside of the panel (gives user more focus)
void displayPanel() {
  if (isPanelHover || !mousePressed || isPanelDragged) {
      if (currentMode == Mode.REST) { // i.e. control panel's not busy
        panelX = int(logoX/2);
        
        // Reposition the panel, if it's about to cut out of the screen
        // Can't be bothered with correct mathematics for symmetry, but I want to keep panel somewhat close to the user square
        if (isPanelBottom) {
            if ((panelY + panelHeight >= 800)) {
                panelYOffset = -logoZ - panelHeight;
                isPanelBottom = false;
            } else {
                panelYOffset = logoZ - panelHeight * 0.25;
            }
        } else {
            if ((panelY <= 0)) {
                panelYOffset = logoZ - panelHeight * 0.25;
                isPanelBottom = true;
            } else {
                panelYOffset = -logoZ - panelHeight;
            }
        }
        
        panelY = int(logoY+panelYOffset);
     }
     
     if (!isLogoDragged || currentMode!=Mode.REST)
       image(panel, panelX, panelY);
  }
}
