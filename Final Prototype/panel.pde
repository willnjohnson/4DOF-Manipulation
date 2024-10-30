PGraphics panel;
PFont font;

String textSubmit = "✓";
String panelName = "FINE TUNE CONTROLLER";

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
float rotX = panelX+155 + radius * cos(angle);
float rotY = panelY+75 + radius * sin(angle);
boolean isRotationDrag = false;

// Draw the panel
void drawPanel() {
  // Get indicator status on each frame
  Destination d = destinations.get(trialIndex);
  
  // Check translation indicator status
  if (dist(d.x, d.y, logoX, logoY)<inchToPix(.2f)) {
    indicatorTranslate = 1;
    if (dist(d.x, d.y, logoX, logoY)<inchToPix(.05f)) {
      indicatorTranslate = 2;
    }
  } else {
    indicatorTranslate = 0;
  }
  
  // Check rotation indicator status
  if (calculateDifferenceBetweenAngles(d.rotation, logoRotation)<=20) {
    indicatorRotate = 1;
    if (calculateDifferenceBetweenAngles(d.rotation, logoRotation)<=5) {
      indicatorRotate = 2;
    }
  } else {
    indicatorRotate = 0;
  }
  
  // Check scaling indicator status
  if (abs(d.z - logoZ)<inchToPix(.4f)) {
    indicatorScale = 1;
    if (abs(d.z - logoZ)<inchToPix(.1f)) {
      indicatorScale = 2;
    }
  } else {
    indicatorScale = 0;
  }
  
  // Light gray horizontal panel
  panel.stroke(lightGray);
  panel.strokeWeight(2);
  panel.fill(darkerGray);
  panel.rect(0, 0, 315, 100, 20);

  // Button #1: Translate
  if (indicatorTranslate == 2) {
    for (int i = 3; i > 0; i--) {
      panel.strokeWeight(5);
      panel.stroke(deepLimeGreen, map(i, 5, 1, 0, 255));
      panel.noFill();
      panel.rectMode(CENTER);
      panel.rect(50, 50, inchToPix(0.75 + i * 0.025), inchToPix(0.75 + i * 0.025), 10);
    }
  } else if (indicatorTranslate == 1) {
    panel.strokeWeight(3);
    panel.stroke(yellowTransparent);
  } else {
    panel.strokeWeight(2);
    panel.stroke(darkGraySolid);
  }

  panel.rectMode(CENTER);
  panel.fill(darkerGray);
  panel.rect(50, 50, inchToPix(0.75), inchToPix(0.75), 10);
  panel.stroke(lightGray);
  panel.strokeWeight(4);
  panel.line(50, 25, 50, 75);
  panel.line(25, 50, 75, 50);
  
  // Button #1's dot
  panel.fill(currentMode==Mode.TRANSLATE ? color(0, 0, 132, 200) : color(60, 60, 192, 255));
  panel.stroke(currentMode==Mode.TRANSLATE ? color(255, 255, 255, 50) : color(255, 255, 255, 100));
  panel.strokeWeight(2);
  panel.ellipse(50+btnTranslateOffX, 50+btnTranslateOffY, inchToPix(0.25), inchToPix(0.25));

  // Button #2: Rotate
  panel.fill(darkerGray);
  if (indicatorRotate == 2) {
    for (int i = 3; i > 0; i--) {
      panel.strokeWeight(5);
      panel.stroke(deepLimeGreen, map(i, 5, 1, 0, 255));
      panel.noFill();
      panel.rectMode(CENTER);
      panel.ellipse(130, 50, inchToPix(0.75 + i * 0.025), inchToPix(0.75 + i * 0.025));
    }
  } else if (indicatorRotate == 1) {
    panel.strokeWeight(3);
    panel.stroke(yellowTransparent);
  } else {
    panel.strokeWeight(2);
    panel.stroke(darkGraySolid);
  }
  
  panel.fill(darkerGray);
  panel.ellipse(130, 50, inchToPix(0.75), inchToPix(0.75));
  panel.strokeWeight(4);
  panel.stroke(lightGray);
  panel.ellipse(130, 50, inchToPix(0.4), inchToPix(0.4));

  // Button #2's dot
  panel.fill(currentMode==Mode.ROTATE ? color(195, 195, 42, 200) : color(255, 255, 102, 255));
  panel.stroke(currentMode==Mode.ROTATE ? color(255, 255, 255, 50) : color(255, 255, 255, 100));
  panel.strokeWeight(2);
  panel.ellipse(130 + radius * cos(angle), 50 + radius * sin(angle), inchToPix(0.25), inchToPix(0.25));

  // Button #3: Scale
  panel.fill(darkerGray);
  if (indicatorScale == 2) {
    for (int i = 3; i > 0; i--) {
      panel.strokeWeight(5);
      panel.stroke(deepLimeGreen, map(i, 5, 1, 0, 255));
      panel.noFill();
      panel.rectMode(CENTER);
      panel.rect(200, 50, inchToPix(0.4 + i * 0.025), inchToPix(1.2 + i * 0.025), 10);
    }
  } else if (indicatorScale == 1) {
    panel.strokeWeight(3);
    panel.stroke(yellowTransparent);
  } else {
    panel.strokeWeight(2);
    panel.stroke(darkGraySolid);
  }
  
  panel.rectMode(CENTER);
  panel.fill(darkerGray);
  panel.rect(200, 50, inchToPix(0.4), inchToPix(1.2), 10);
  panel.fill(lightGray);
  panel.stroke(lightGray);
  panel.strokeWeight(4);
  panel.line(200, 72.5, 200, 30);
  panel.textSize(inchToPix(0.25));
  panel.textAlign(CENTER, CENTER);
  panel.fill(white);
  panel.strokeWeight(1);
  panel.text("+", 200, 15); // Plus symbol on top
  panel.text("-", 200, 85); // Minus symbol on bottom
  
  // Button #3's dot
  panel.fill(currentMode==Mode.SCALE ? color(144, 0, 0, 200) : color(204, 0, 51, 255));
  panel.stroke(currentMode==Mode.SCALE ? color(255, 255, 255, 50) : color(255, 255, 255, 100));
  panel.strokeWeight(2);
  panel.ellipse(200, 50+btnScaleOffY, inchToPix(0.25), inchToPix(0.25));

  // Button #4: Submit
  panel.stroke(deepLimeGreenSolid);
  int submitC1;
  int submitC2;
  if (!isLogoDragged && !isHandleDragged && dist(mouseX, mouseY, panelX+265, panelY+50) < inchToPix(0.75) / 2) {
    if (mousePressed && currentMode==Mode.REST)
      onSubmit = true;
    isSubmitHover = true;
    submitC1 = deepLimeGreen;
    submitC2 = lightLimeGreen;
    panel.strokeWeight(0);
    if (mousePressed) {
      for (int i = 3; i > 0; i--) {
        panel.fill(lightLimeGreen, map(i, 6, 0, 0, 255));
        panel.ellipse(265, 50, inchToPix(0.65 + i * 0.1), inchToPix(0.65 + i * 0.1));
      }  
    } else {
      for (int i = 2; i > 0; i--) {
        panel.fill(deepLimeGreen, map(i, 5, 0, 0, 255));
        panel.ellipse(265, 50, inchToPix(0.65 + i * 0.1), inchToPix(0.65 + i * 0.1));
      }
    }
  } else {
    onSubmit = false;
    isSubmitHover = false;
    
    submitC1 = deepLimeGreen;
    submitC2 = lightLimeGreen;
  }
  panel.fill(submitC1);
  panel.ellipse(265, 50, inchToPix(0.75), inchToPix(0.75));
  panel.stroke(submitC2);
  panel.strokeWeight(2);
  panel.ellipse(265, 50, inchToPix(0.6), inchToPix(0.6));
  panel.textSize(inchToPix(0.5));
  panel.textAlign(CENTER, CENTER);
  panel.fill(white);
  panel.text(textSubmit, 265, 50);
  
  panel.textAlign(LEFT, CENTER);
  panel.textSize(inchToPix(0.15));
  panel.fill(lightGray);
  panel.text(panelName, 20, 10);
}

// Display panel if user does not mouse press outside of the panel (gives user more focus)
void displayPanel() {
  if ((isPanelHover || !mousePressed || isPanelDragged) && (currentMode != Mode.REST || !isLogoDragged || !isHandleDragged)) {
      if (currentMode == Mode.REST) { // i.e. control panel's not busy
        panelX = int(logoX/1.5);
      
        // Reposition the panel, if it's about to cut out of the screen
        // Can't be bothered with correct mathematics for symmetry, but I want to keep panel somewhat close to the user square
        if (isPanelBottom) {
            if ((panelY + panelHeight >= 800)) {
                panelYOffset = -logoZ - panelHeight;
                isPanelBottom = false;
            } else {
                panelYOffset = logoZ*0.75+10;
            }
        } else {
            if ((panelY <= inchToPix(1.1))) {
                panelYOffset = logoZ*0.75-10;
                isPanelBottom = true;
            } else {
                panelYOffset = -logoZ - panelHeight;
            }
        }
        
        panelY = int(logoY+panelYOffset);
     }
     
     // recenter pointer to center of button last used with wiggle-room to nudge the button
     Point pointer = MouseInfo.getPointerInfo().getLocation();
     
     if (pointerState == 0) {
       robot.mouseMove(pointer.x-mouseX+panelX+50-2, pointer.y-mouseY+panelY+50);
       pointerState = -1;
     } else if (pointerState == 1) {
       robot.mouseMove(pointer.x-mouseX+panelX+50+2, pointer.y-mouseY+panelY+50);
       pointerState = -1;
     } else if (pointerState == 2) {
       robot.mouseMove(pointer.x-mouseX+panelX+50, pointer.y-mouseY+panelY+50-2);
       pointerState = -1;
     } else if (pointerState == 3) {
       robot.mouseMove(pointer.x-mouseX+panelX+50, pointer.y-mouseY+panelY+50+2);
       pointerState = -1;
     } else if (pointerState == 4) {
       robot.mouseMove((int) (pointer.x-mouseX+panelX+130 + radius * cos(initialAngle)) - 2, (int) (pointer.y-mouseY+panelY+50 + radius * sin(initialAngle)) + 2);
       pointerState = -1;
     } else if (pointerState == 5) {
       robot.mouseMove((int) (pointer.x-mouseX+panelX+130 + radius * cos(initialAngle)) + 2, (int) (pointer.y-mouseY+panelY+50 + radius * sin(initialAngle)) - 2);
       pointerState = -1;
     } else if (pointerState == 6) {
       robot.mouseMove(pointer.x-mouseX+panelX+200, pointer.y-mouseY+panelY+50-2);
       pointerState = -1;
     } else if (pointerState == 7) {
       robot.mouseMove(pointer.x-mouseX+panelX+200, pointer.y-mouseY+panelY+50+2);
       pointerState = -1;
     }
     
     if (!disablePanelInteraction)
       image(panel, panelX, panelY);
  }
}
