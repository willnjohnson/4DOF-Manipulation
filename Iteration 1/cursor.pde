// Update cursor based on user's actions
void setDynamicCursor() {
  if ((isLogoHover||isLogoDragged) && currentMode == Mode.REST)
    cursor(MOVE);
  else if (currentMode != Mode.REST || isOnTranslate || isOnRotate || isOnScale)
    cursor(HAND);
  else if (isPanelHover) {
    if (onSubmit) cursor(HAND);
    else cursor(ARROW);
  } else {
    cursor(CROSS);
  }
}
