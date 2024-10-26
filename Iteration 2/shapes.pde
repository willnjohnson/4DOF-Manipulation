void makeArc(int x, int y, int w, int h, float start, float stop, int thickness) {
  panel.strokeWeight(thickness);
  panel.strokeCap(SQUARE);
  panel.arc(x, y, w, h, start, stop);
  panel.strokeCap(ROUND);
}

void makeTriangle(float x, float y, float size, int orientation) {
  float halfBase = size / 2;
  float height = sqrt(3) * halfBase;
  
  switch (orientation) {
    case 0: // UP
      panel.triangle(
        x, y - height / 2,
        x - halfBase, y + height / 2,
        x + halfBase, y + height / 2 
      );
      break;
    case 1: // DOWN
      panel.triangle(
        x, y + height / 2,
        x - halfBase, y - height / 2,
        x + halfBase, y - height / 2
      );
      break;
    case 2: // LEFT
      panel.triangle(
        x - halfBase, y,
        x + halfBase / 2, y - height / 2,
        x + halfBase / 2, y + height / 2
      );
      break;
    case 3: // RIGHT
      panel.triangle(
        x + halfBase, y,
        x - halfBase / 2, y - height / 2,
        x - halfBase / 2, y + height / 2
      );
      break;
    case 4: // SOUTHEAST
      panel.triangle(
        x, y + height / 3.33,
        x + halfBase, y - height / 3.33,
        x + halfBase, y + height / 3.33
      );
      break;
    case 5: // NORTHEAST
      panel.triangle(
        x, y - height / 3.33,
        x + halfBase, y + height / 3.33,
        x + halfBase, y - height / 3.33
      );
      break;
    default:
      break;
  }
}

boolean isInArc(int x, int y, int w, float start, float stop, int thickness) {
  float dx = mouseX - x;
  float dy = mouseY - y;
  
  float distance = sqrt(dx*dx + dy*dy);
  
  float outerRadius = (w / 2) + thickness;
  float innerRadius = (w / 2) - thickness;
  
  if (distance < outerRadius && distance > innerRadius) {
    float angle = atan2(dy, dx);
    if (angle < 0) angle += TWO_PI;
    if (angle >= start && angle <= stop) return true;
  }
  return false;
}
