/*
 This file is part of Make Your Own HCI!
 
 Copyright (c) 2013, Bobbie Smulders
 
 Contact: mail@bsmulders.com
 
 GNU General Public License Usage
 This file may be used under the terms of the GNU General Public License version 3.0 as published by the Free Software Foundation and appearing in the file LICENSE included in the packaging of this file.  Please review the following information to ensure the GNU General Public License version 3.0 requirements will be met: http://www.gnu.org/copyleft/gpl.html.
 
 View: It requests information from the model and draws it on screen.
 */

public class View {
  private Model model;

  public View() {
  }

  public View(Model model) {
    setModel(model);
  }

  public Model getModel() {
    return model;
  }

  public void setModel(Model model) {
    this.model = model;
  }

  public void drawScreen() {
    smooth();
    textFont(createFont("Futura", 12));

    drawBackground();
    drawHUD();

    switch(getModel().getProgramState()) {
    case CALIBRATING:
      drawButtons();
      drawTypeLabel();
      break;
    case CALIBRATED:
      drawMovers();   
      drawButtons(); 
      break;
    }
  }

  private void drawBackground() {
    strokeWeight(2);

    if (getModel().displayBackground()) {
      background(24);

      stroke(48);
      for (int row = 0; row < height; row += 30) {
        line (0, row, width, row);
      }
      for (int col = 0; col < width; col += 30) {
        line(col, 0, col, height);
      }
    } else {
      PImage bg = getModel().getWebcam().getLastCapture();
      if (bg != null) {        
        pushMatrix();
        scale(1.0, -1.0);
        image(bg, 0, -height, width, height);
        popMatrix();
      } else {
        background(128);
      }
    }
  }

  private void drawHUD() {
    textAlign(CENTER);
    textSize(26);
    fill(255);

    text(getModel().getProgramStateText(), width/2, height-40);
  }

  private void drawTypeLabel() {
    textAlign(CENTER);
    textSize(16);
    fill(255);

    for (Button button : getModel().getButtons()) {
      if (button!= null && button.getType() != null) {
        int startX = int(button.getStart().getX() * width);
        int startY = int(button.getStart().getY() * height) - 40;

        switch(button.getType()) {
        case KNOB:       
          text("Knob", startX, startY);       
          break;
        case SLIDER:     
          text("Slider", startX, startY);     
          break;
        case TOGGLE:     
          text("Toggle", startX, startY);     
          break;
        case UNDEFINED:  
          text("Undefined", startX, startY);  
          break;
        }
      }
    }
  }

  private void drawMovers() {
    for (Mover mover : getModel().getMovers()) {
      if (mover != null) {
        strokeWeight(3);
        stroke(0);

        Vec2 pos = getModel().getBox2D().getBodyPixelCoord(mover.getBody());
        float x = pos.x;
        float y = pos.y;

        fill(255, 0, 0);
        ellipse(x, y, 50, 50);
      }
    }
  }

  private void drawAttractors() {
    for (Attractor attractor : getModel().getAttractors()) {
      if (attractor != null) {
        strokeWeight(3);
        stroke(0);

        Vec2 pos = getModel().getBox2D().getBodyPixelCoord(attractor.getBody());
        float x = pos.x * width;
        float y = pos.y * height;

        fill(0, 0, 255);
        ellipse(x, y, 50, 50);
      }
    }
  }

  private void drawButtons() {
    for (Button button : getModel().getButtons()) {
      if (button != null && button.getCurrent() != null) {
        switch(button.getType()) {
        case KNOB:       
          drawKnobButton(button);       
          break;
        case SLIDER:     
          drawSliderButton(button);     
          break;
        case TOGGLE:     
          drawToggleButton(button);     
          break;
        case UNDEFINED:  
          drawUndefinedButton(button);  
          break;
        }
      }
    }
  }

  private void drawKnobButton(Button button) {
    textAlign(CENTER);
    textSize(16);
    strokeWeight(3);
    stroke(0);

    int startX = int(button.getStart().getX() * width);
    int startY = int(button.getStart().getY() * height);
    int rotX = int(startX + cos(radians(button.getCurrent().getRotation())) * 30);
    int rotY = int(startY + sin(radians(button.getCurrent().getRotation())) * 30);

    fill(242, 192, 0);
    ellipse(startX, startY, 50, 50);
    stroke(255);
    line(startX, startY, rotX, rotY);
    fill(255);
    text(button.getValue() + "%", startX, startY+40);
  }

  private void drawSliderButton(Button button) {
    textAlign(CENTER);
    textSize(16);
    rectMode(CENTER);
    strokeWeight(3);

    int startX = int(button.getStart().getX() * width);
    int startY = int(button.getStart().getY() * height);
    int endX = int(button.getEnd().getX() * width);
    int endY = int(button.getEnd().getY() * height);
    int curX = int(lerp(startX, endX, button.getValue() / 100.0));
    int curY = int(lerp(startY, endY, button.getValue() / 100.0));

    stroke(255);
    line(startX, startY, endX, endY);
    stroke(0);
    fill(242, 192, 0); 
    rect(curX, curY, 50, 50);             
    fill(255);
    text(button.getValue() + "%", curX, curY+40);
  }

  private void drawToggleButton(Button button) {
    textAlign(CENTER);
    textSize(16);
    rectMode(CENTER);
    strokeWeight(3);
    stroke(0);

    int startX = int(button.getStart().getX() * width);
    int startY = int(button.getStart().getY() * height);
    int endX = int(button.getEnd().getX() * width);
    int endY = int(button.getEnd().getY() * height);

    switch (button.getValue()) {
    case 0: 
      fill(200);
      rect(startX, startY, 50, 50); 
      fill(80);
      text("Undefined", startX, startY);
      break;
    case 1: 
      fill(242, 192, 0); 
      rect(startX, startY, 50, 50); 
      fill(255);
      text("On", startX, startY+40);  
      break;
    case 2: 
      fill(200);
      rect(startX, startY, 50, 50); 
      fill(255);
      text("Off", startX, startY+40);
      break;
    }
  }

  private void drawUndefinedButton(Button button) {
    rectMode(CENTER);
    strokeWeight(3);
    stroke(0);

    int startX = int(button.getStart().getX() * width);
    int startY = int(button.getStart().getY() * height);

    fill(100, 0, 0);    
    rect(startX, startY, 50, 50);
  }
}