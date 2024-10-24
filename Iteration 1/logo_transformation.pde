// Handles transformation - translation, rotation, scaling
void transformLogo() {
  switch(currentMode) {
    case TRANSLATE:
      doPanelTranslate();
      break;
    case ROTATE:
      doPanelRotate();
      break;
    case SCALE:
      doPanelScale();
      break;
    default: 
      break;
  }
}

void doPanelTranslate() {
 if (abs(mouseX-(panelX+75)) > abs(mouseY-(panelY+75))) {
    if (isDisabledBtnTranslateHorizontal == false) {
      isDisabledBtnTranslateVertical = true;
      btnTranslateOffX = constrain(mouseX - (panelX + 75), -25, 25);
    }
  } else {
    if (isDisabledBtnTranslateVertical == false) {
      isDisabledBtnTranslateHorizontal = true;
      btnTranslateOffY = constrain(mouseY-(panelY+75), -25, 25);
    }
  }
  
  setPanelTranslate(btnTranslateOffX/5, btnTranslateOffY/5);
}

void doPanelRotate() {
  float tmpRotX = panelX+175 + radius * cos(angle);
  float tmpRotY = panelY+75 + radius * sin(angle);
  float d = dist(mouseX, mouseY, tmpRotX, tmpRotY);
  if (d < radius) isRotationDrag = true;
  
  if (isRotationDrag) {
    float mouseAngle = atan2(mouseY - (panelY+75), mouseX - (panelX+175));
    if (mouseAngle < 0) mouseAngle += TWO_PI;
    
    // Clamp angle
    if (mouseAngle < minAngle || mouseAngle > maxAngle) {
      if (mouseAngle < radians(180)) {
        angle = minAngle;
      } else {
        angle = maxAngle;
      }
    } else {
      angle = mouseAngle;
    }
  }
  
  setLogoRotate(round((angle-initialAngle)*1.5));
}


void doPanelScale() {
  btnScaleOffY = constrain(mouseY-(panelY+75), -25, 25);
  
  setLogoScale(btnScaleOffY/10);
}

void setPanelTranslate(int xamt, int yamt) {
  logoX+=xamt;
  logoY+=yamt;
}

void setLogoRotate(int amt) {
  logoRotation += amt;
}

void setLogoScale(int amt) {
  logoZ = constrain(logoZ-amt, .01, inchToPix(4f)); //leave min and max alone!
}
