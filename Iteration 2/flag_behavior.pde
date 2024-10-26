void checkFlagsDraw() {
  // set flags on hover of user square
  isPanelHover = (mouseX > panelX && mouseX < panelX + panelWidth && mouseY > panelY && mouseY < panelY + panelHeight);
  isLogoHover = isMouseInLogo(mouseX, mouseY, logoX, logoY, logoZ, logoZ, logoRotation);
  isLogoDragged = isLogoHover && mousePressed;
  
  // determine mode flags by cursor region
  if (!isLogoDragged) {
    if (currentMode!=Mode.ROTATE && currentMode!=Mode.SCALE)
      isOnTranslate = dist(mouseX, mouseY, panelX+50, panelY+50) < inchToPix(0.15);
    if (currentMode!=Mode.TRANSLATE && currentMode!=Mode.SCALE)
      isOnRotate = dist(mouseX, mouseY, panelX+(130 + radius * cos(angle)), panelY+(50 + radius * sin(angle))) < inchToPix(0.15);
    if (currentMode!=Mode.TRANSLATE && currentMode!=Mode.ROTATE)
      isOnScale = dist(mouseX, mouseY, panelX+200, panelY+50) < inchToPix(0.15);
  }
  
  // set mode
  if (mousePressed && isOnTranslate)     currentMode = Mode.TRANSLATE;
  else if (mousePressed && isOnRotate)   currentMode = Mode.ROTATE;
  else if (mousePressed && isOnScale)    currentMode = Mode.SCALE;
  
  if (mousePressed) transformLogo();
}

void checkFlagsMouseReleased() {
  Point pointer = MouseInfo.getPointerInfo().getLocation();

  if (currentMode == Mode.TRANSLATE) {
    int px = mouseX - (panelX+50);
    int py = mouseY - (panelY+50);
    
    // nudge effect for translation
    if (abs(px) > abs(py)) {
      // horizontal logic
      if (px < 0) {
        setLogoTranslate(-1, 0);
        pointerState = 0;
      } else if (px > 0) {
        setLogoTranslate(1, 0);
        pointerState = 1;
      }
    } else {
      // vertical logic
      if (py < 0) {
        setLogoTranslate(0, -1);
        pointerState = 2;
      } else if (py > 0) {
        setLogoTranslate(0, 1);
        pointerState = 3;
      }
    }
    
    // add event to reposition mouse to center of button on the next iteration
  } else if (currentMode == Mode.ROTATE) {
    float px = mouseX - (panelX+130 + radius * cos(initialAngle));
    float py = mouseY - (panelY+50 + radius * sin(initialAngle));
    
    // nudge effect for rotation
    if (px!=0) {
      if (py > px) {
        // counter-clockwise
        setLogoRotate(-2);
        pointerState = 4;
      } else {
        // clockwise
        setLogoRotate(2);
        pointerState = 5;
      }
    } else {
      // clockwise
      setLogoRotate(2);
      pointerState = 5;
    }

  } else if (currentMode == Mode.SCALE) {
    int py = mouseY - (panelY+50);
    
    // nudge effect for scaling
    if (py < 0) {
      // shrink
      setLogoScale(-1);
      pointerState = 6;
    } else if (py > 0) {
      // grow
      setLogoScale(1);
      robot.mouseMove(pointer.x, pointer.y-1);
      pointerState = 7;
    }
    // ...
  }
  
  currentMode = Mode.REST;
  isDisabledBtnTranslateHorizontal = false;
  isDisabledBtnTranslateVertical = false;
  angle = initialAngle;
  btnTranslateOffX = 0;
  btnTranslateOffY = 0;
  btnScaleOffY = 0;
  
  // reset all drag events
  isPanelDragged = false;
  isLogoDragged = false;
}

void checkFlagsMouseDragged() {
  if(isPanelHover) isPanelDragged = true; // if user plays with the panel controls, we want to keep the panel alive
  
  // logo is in drag mode
  if(isLogoHover||isLogoDragged) {
    if (currentMode==Mode.REST) {
      // Add offset to prevent logo from centering to the pointer
      logoX = mouseX + offsetX;
      logoY = mouseY + offsetY;
    }
  }
}

// Checks if the mouse cursor is inside the logo
boolean isMouseInLogo(float mx, float my, float bx, float by, float bw, float bh, float rotation) {
  float translatedX = mx - bx;
  float translatedY = my - by;
  
  float angle = radians(-rotation);
  float rotatedX = translatedX * cos(angle) - translatedY * sin(angle);
  float rotatedY = translatedX * sin(angle) + translatedY * cos(angle);
  
  return rotatedX > -bw / 2 && rotatedX < bw / 2 && rotatedY > -bh / 2 && rotatedY < bh / 2;
}
