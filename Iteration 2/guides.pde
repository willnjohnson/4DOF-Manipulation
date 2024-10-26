float marchingAntOff = 0;

// Draw crosshair
void drawCrosshair(float squareSize, color strokeColor, color dotColor) {
  // Draw crosshair in the middle of the square
  stroke(strokeColor);
  strokeWeight(1);
  float crossLength = squareSize / 4;
  line(-crossLength / 2, 0, crossLength / 2, 0); // Horizontal line
  line(0, -crossLength / 2, 0, crossLength / 2); // Vertical line
  
  // Draw red dot at the center
  fill(dotColor);
  noStroke();
  float dotSize = squareSize / 16;
  ellipse(0, 0, dotSize, dotSize);
}

// Draw guide lines that help with alignment
void drawDashedGuideLines(float squareSize, color strokeColor, float lineLength, float dashLength, int weight) {
  // Define midpoints for guide lines
  float halfSize = squareSize / 2;
  PVector[] midpoints = {
    new PVector(0, -halfSize),   // Top midpoint
    new PVector(halfSize, 0),    // Right midpoint
    new PVector(0, halfSize),    // Bottom midpoint
    new PVector(-halfSize, 0)    // Left midpoint
  };
  
  // Draw dashed lines
  strokeWeight(weight);
  for (PVector midpoint : midpoints) {
    float perpendicularAngle = atan2(midpoint.y, midpoint.x) + HALF_PI;
    float alpha = 255; // Start with full opacity
    
    for (float d = squareSize/2; d < lineLength; d += dashLength * 2) {
      // Calculate each dash segment's position
      float x1 = midpoint.x + cos(perpendicularAngle) * d;
      float y1 = midpoint.y + sin(perpendicularAngle) * d;
      float x2 = midpoint.x + cos(perpendicularAngle) * (d + dashLength);
      float y2 = midpoint.y + sin(perpendicularAngle) * (d + dashLength);
      
      // Set stroke color with current alpha
      stroke(strokeColor, max(0, alpha)); // Ensure alpha doesn't go below 0
      line(x1, y1, x2, y2); // Draw each dash segment
      
      // Decrease alpha for the next dash
      alpha -= 5;
    }
  }
}

// Draw marching ants to indicate that there's a selection
void drawMarchingAnts(float x, float y, float squareSize, color strokeColor, float dashLength, int weight) {
  strokeWeight(weight);
  stroke(strokeColor);
  float halfSide = squareSize / 2;
  
  // Define vertices
  PVector[] vertices = {
    new PVector(x - halfSide, y - halfSide),  // Top left
    new PVector(x + halfSide, y - halfSide),  // Top right
    new PVector(x + halfSide, y + halfSide),  // Bottom right
    new PVector(x - halfSide, y + halfSide)   // Bottom left
  };
  
  // Loop to draw dashed lines
  for (int i = 0; i < 4; i++) {
    PVector start = vertices[i];
    PVector end = vertices[(i + 1) % 4];
    float distance = dist(start.x, start.y, end.x, end.y);
    float numDashes = distance / dashLength;
    float dx = (end.x - start.x) / numDashes;
    float dy = (end.y - start.y) / numDashes;

    // Draw dashes with offset to create marching ants effect
    for (int j = 0; j < numDashes-1; j += 2) {
      float startX = start.x + (j * dx) + (marchingAntOff % dashLength) * dx / dashLength;
      float startY = start.y + (j * dy) + (marchingAntOff % dashLength) * dy / dashLength;
      float endX = startX + dx;
      float endY = startY + dy;
      line(startX, startY, endX, endY);
    }
  }
  marchingAntOff += 0.1;
}
