void checkFlagsDraw() {
  // set flags on hover of user square
  isPanelHover = (mouseX > panelX && mouseX < panelX + panelWidth && mouseY > panelY && mouseY < panelY + panelHeight);
  isLogoHover = isMouseInLogo(mouseX, mouseY, logoX, logoY, logoZ, logoZ, logoRotation);
  isLogoDragged = isLogoHover && mousePressed;
  
  // determine mode flags by cursor region
  if (!isLogoDragged) {
    if (currentMode!=Mode.ROTATE && currentMode!=Mode.SCALE)
      isOnTranslate = dist(mouseX, mouseY, panelX+75, panelY+75) < inchToPix(0.5);
    if (currentMode!=Mode.TRANSLATE && currentMode!=Mode.SCALE)
      isOnRotate = dist(mouseX, mouseY, panelX+(175 + radius * cos(angle)), panelY+(75 + radius * sin(angle))) < inchToPix(0.15);
    if (currentMode!=Mode.TRANSLATE && currentMode!=Mode.ROTATE)
      isOnScale = dist(mouseX, mouseY, panelX+275, panelY+75) < inchToPix(0.25);
  }
  
  // set mode
  if (mousePressed && isOnTranslate)     currentMode = Mode.TRANSLATE;
  else if (mousePressed && isOnRotate)   currentMode = Mode.ROTATE;
  else if (mousePressed && isOnScale)    currentMode = Mode.SCALE;
  
  if (isMouseHeld) transformLogo();
}

void checkFlagsMouseReleased() {
  isMouseHeld = false;
  
  if (currentMode == Mode.TRANSLATE) {
    // add event to reposition mouse to center of button on the next iteration
  } else if (currentMode == Mode.ROTATE) {
  } else if (currentMode == Mode.SCALE) {
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
      logoX = mouseX; 
      logoY = mouseY;
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
