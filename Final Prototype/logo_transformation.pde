// Handles transformation - translation, rotation, scaling
void transformLogo() {
  switch(currentMode) {
    case TRANSLATE:
      doLogoTranslate();
      break;
    case ROTATE:
      doLogoRotate();
      break;
    case SCALE:
      doLogoScale();
      break;
    default: 
      break;
  }
}

void doLogoTranslate() {
  btnTranslateOffX = constrain(mouseX - (panelX + 50), -25, 25);
  btnTranslateOffY = constrain(mouseY - (panelY + 50), -25, 25);
  
  int px = mouseX - (panelX + 50);
  int py = mouseY - (panelY + 50);
  if ((px <= -12 || px >= 12) || (py <= -12 || py >= 12))
    setLogoTranslate(btnTranslateOffX/5, btnTranslateOffY/5);
}

void doLogoRotate() {
  float tmpRotX = panelX+130 + radius * cos(angle);
  float tmpRotY = panelY+50 + radius * sin(angle);
  float d = dist(mouseX, mouseY, tmpRotX, tmpRotY);
  if (d < radius) isRotationDrag = true;
  
  if (isRotationDrag) {
    float mouseAngle = atan2(mouseY - (panelY+50), mouseX - (panelX+130));
    if (mouseAngle < 0) mouseAngle += TWO_PI;
    
    // Clamp angle
    if (!(mouseAngle < minAngle || mouseAngle > maxAngle))
      angle = mouseAngle;
  }
  
  setLogoRotate(round((angle-initialAngle)*1.5));
}


void doLogoScale() {
  btnScaleOffY = constrain(mouseY-(panelY+50), -25, 25);
  
  setLogoScale(btnScaleOffY/10);
}

void setLogoTranslate(int xamt, int yamt) {
  logoX+=xamt;
  logoY+=yamt;
}

void setLogoRotate(int amt) {
  logoRotation += amt;
  
  // Ensure handle is properly updated
  float distance = dist(oldLogoX, oldLogoY, handleX, handleY);
  float angleInRadians = radians(logoRotation);
  handleX = logoX + distance * cos(angleInRadians - radians(-225));
  handleY = logoY + distance * sin(angleInRadians - radians(-225));
}

void setLogoScale(int amt) {
  logoZ = constrain(logoZ-amt, .01, inchToPix(4f)); //leave min and max alone!
  
  // Ensure handle is properly updated
  float scaleFactor = logoZ / oldLogoZ;
  handleX = logoX + (handleX - logoX) * scaleFactor;
  handleY = logoY + (handleY - logoY) * scaleFactor;
}
