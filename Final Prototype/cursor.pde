// Update cursor based on user's actions
void setDynamicCursor() {
  if (isLogoDragged && currentMode == Mode.REST) {
    noCursor();
  } else if (isLogoHover && currentMode == Mode.REST) {
    cursor(MOVE);
  } else if (currentMode != Mode.REST && !isPanelHover) {
    cursor(CROSS);
  } else if (currentMode != Mode.REST || isOnTranslate || isOnRotate || isOnScale || isHandleHover) {
    cursor(HAND);
  } else if (isPanelHover) {
    if (isSubmitHover) cursor(HAND);
    else cursor(ARROW);
  } else {
    cursor(CROSS);
  }
}
