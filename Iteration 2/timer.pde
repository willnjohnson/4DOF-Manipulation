void timerDisplay() {
  int elapsedMillis = startTime == 0 ? 0 : (millis() - startTime); // Time since the start of the current trial
  int seconds = (elapsedMillis / 1000) % 60;
  int minutes = (elapsedMillis / (1000 * 60)) % 60;
  int milliseconds = (elapsedMillis % 1000) / 10; // Get milliseconds for display, divided by 10 to show 2 digits

  // Format the timer text to include milliseconds
  String timerText = nf(minutes, 2) + ":" + nf(seconds, 2) + "." + nf(milliseconds, 3);

  int currentSecond = seconds % 2;

  // Draw gradient rectangle with a more transparent effect
  float centerX = width / 2;
  float centerY = inchToPix(1.2);
  float rectWidth = 180;
  float rectHeight = 25;

  if (currentSecond == 0) {
    fill(lightGray); // light gray text
  } else {
    // Loop to create gradient effect by layering rectangles
    for (int i = 0; i < 10; i++) {
      int alpha = int(map(i, 0, 10, 10, 0)); // Center is semi-transparent, edges are fully transparent
      fill(red, alpha);
  
      float w = rectWidth + i * 10;
      float h = rectHeight;
      rect(centerX, centerY, w, h);
    }
    fill(red); // red text
  }

  // Bold text by repeating the text
  textAlign(CENTER, CENTER);
  for (float i = -0.5; i <= 0.5; i++) {
    for (float j = -0.5; j <= 0.5; j++) {
      text(timerText, width / 2 + i, inchToPix(1.2) + j);
    }
  }
}
