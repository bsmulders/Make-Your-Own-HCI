/*
 This file is part of Make Your Own HCI!
 
 Copyright (c) 2014, Bobbie Smulders
 
 Contact: mail@bsmulders.com
 
 GNU General Public License Usage
 This file may be used under the terms of the GNU General Public License version 3.0 as published by the Free Software Foundation and appearing in the file LICENSE included in the packaging of this file.  Please review the following information to ensure the GNU General Public License version 3.0 requirements will be met: http://www.gnu.org/copyleft/gpl.html.
 
 Webcam: Helper class for the webcam. After initialisation, a capture from the camera can be requested. It also holds a PImage with the last capture for displaying purposes.
 */

import processing.video.*;

public class Webcam {
  private int width;
  private int height;
  Capture webcam;
  private PImage lastCapture;

  public Webcam(PApplet parent, int width, int height) {
    this.width = width;
    this.height = height;

    webcam = new Capture(parent, width, height);
    webcam.start();
  }

  public int getWidth() {
    return width;
  }

  public void setWidth(int width) {
    this.width = width;
  }

  public int getHeight() {
    return height;
  }

  public void setHeight(int height) {
    this.height = height;
  }

  public PImage getLastCapture() {
    return lastCapture;
  }

  public void setLastCapture(PImage lastCapture) {
    this.lastCapture = lastCapture;
  }

  public PImage getCameraImage() {
    if (webcam.available()) {
      webcam.read();
      PImage cap = webcam.get();
      setLastCapture(cap);
    }

    return getLastCapture();
  }

  public PImage flipImage(PImage img) {
    PImage result = new PImage(img.width, img.height);
    img.loadPixels();

    for (int i = 0; i < img.pixels.length; i++) {
      int mod = i % img.width;
      int x = ((img.width - mod - 1) + i) - mod;
      result.pixels[i] = img.pixels[x];
    } 

    return result;
  }
}

