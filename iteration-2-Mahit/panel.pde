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
void drawPanel(boolean closeDist, boolean closeRotation, boolean closeZ) {
  // Light gray horizontal panel
  panel.stroke(darkGraySolid);
  panel.strokeWeight(2);
  panel.fill(lightGray);
  panel.rect(0, 0, 315, 100, 20);

  // Define bubble colors based on proximity flags--by Mahit
  color translateBubbleColor = getColorForProximity(closeDist);
  color rotateBubbleColor = getColorForProximity(closeRotation);
  color scaleBubbleColor = getColorForProximity(closeZ);

  // Button #1: Translate
  panel.fill(darkerGray);
  panel.stroke(darkGraySolid);
  panel.strokeWeight(2);
  panel.rectMode(CENTER);
  panel.rect(50, 50, inchToPix(0.75), inchToPix(0.75), 10);
  panel.stroke(lightGray);
  panel.strokeWeight(4);
  panel.line(50, 25, 50, 75);
  panel.line(25, 50, 75, 50);

  // Button #1's dot
  panel.fill(currentMode==Mode.TRANSLATE ? color(195, 195, 42, 200) : color(255, 255, 102, 255));//dot color updated--by Mahit
  panel.stroke(currentMode==Mode.TRANSLATE ? color(255, 255, 255, 50) : color(255, 255, 255, 100));//dot color updated--by Mahit
  panel.strokeWeight(2);
  panel.ellipse(50+btnTranslateOffX, 50+btnTranslateOffY, inchToPix(0.25), inchToPix(0.25));

  // Bubble for Translate with dynamic color--by Mahit
  panel.fill(translateBubbleColor);
  panel.noStroke();
  panel.ellipse(85, 85, inchToPix(0.2), inchToPix(0.2));

  // Button #2: Rotate
  panel.fill(darkerGray);
  panel.stroke(darkGraySolid);
  panel.ellipse(130, 50, inchToPix(0.75), inchToPix(0.75));
  panel.stroke(deepLimeGreen);
  panel.strokeWeight(4);
  panel.stroke(lightGray);
  panel.ellipse(130, 50, inchToPix(0.4), inchToPix(0.4));


  // Button #2's dot
  panel.fill(currentMode==Mode.ROTATE ? color(195, 195, 42, 200) : color(255, 255, 102, 255));
  panel.stroke(currentMode==Mode.ROTATE ? color(255, 255, 255, 50) : color(255, 255, 255, 100));
  panel.strokeWeight(2);
  panel.ellipse(130 + radius * cos(angle), 50 + radius * sin(angle), inchToPix(0.25), inchToPix(0.25));

  // Bubble for Rotate with dynamic color--by Mahit
  panel.fill(rotateBubbleColor);
  panel.noStroke();
  panel.ellipse(155, 85, inchToPix(0.2), inchToPix(0.2));

  // Button #3: Scale
  panel.fill(darkerGray);
  panel.stroke(darkGraySolid);
  panel.rectMode(CENTER);
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
  panel.fill(currentMode==Mode.SCALE ? color(195, 195, 42, 200) : color(255, 255, 102, 255));//dot color updated--by Mahit
  panel.stroke(currentMode==Mode.SCALE ? color(255, 255, 255, 50) : color(255, 255, 255, 100));//dot color updated--by Mahit
  panel.strokeWeight(2);
  panel.ellipse(200, 50+btnScaleOffY, inchToPix(0.25), inchToPix(0.25));

  // Bubble for Scale with dynamic color--by Mahit
  panel.fill(scaleBubbleColor);
  panel.noStroke();
  panel.ellipse(225, 85, inchToPix(0.2), inchToPix(0.2));

  // Button #4: Submit
  panel.stroke(deepLimeGreenSolid);
  int submitC1;
  int submitC2;
  if (!isLogoDragged && dist(mouseX, mouseY, panelX+265, panelY+50) < inchToPix(0.75) / 2) {
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
    submitC1 = lightLimeGreen;
    submitC2 = deepLimeGreen;
  }
  panel.fill(submitC1);
  panel.ellipse(265, 50, inchToPix(0.75), inchToPix(0.75));
  panel.stroke(submitC2);
  panel.strokeWeight(2);
  panel.ellipse(265, 50, inchToPix(0.6), inchToPix(0.6));
  panel.textSize(inchToPix(0.5));
  panel.textAlign(CENTER, CENTER);
  panel.fill(submitC2);
  panel.text(textSubmit, 265, 50);

  panel.textAlign(LEFT, CENTER);
  panel.textSize(inchToPix(0.15));
  panel.fill(lightGray);
  panel.text(panelName, 20, 10);
}

// Utility function to determine bubble color based on proximity--by Mahit
color getColorForProximity(boolean proximityFlag) {
  if (proximityFlag) return color(0, 255, 0, 180);  // Green for true
  // Add conditional logic for yellow if "close to true" criteria is defined
  return color(255, 0, 0, 180);  // Red otherwise
}

// Display panel if user does not mouse press outside of the panel (gives user more focus)
void displayPanel() {
  if ((isPanelHover || !mousePressed || isPanelDragged) && (currentMode != Mode.REST || !isLogoDragged)) {
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
        if ((panelY <= 0)) {
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

    image(panel, panelX, panelY);
  }
}
