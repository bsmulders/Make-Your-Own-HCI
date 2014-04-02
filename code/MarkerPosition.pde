/*
 This file is part of Make Your Own HCI!
 
 Copyright (c) 2013, Bobbie Smulders
 
 Contact: mail@bsmulders.com
 
 GNU General Public License Usage
 This file may be used under the terms of the GNU General Public License version 3.0 as published by the Free Software Foundation and appearing in the file LICENSE included in the packaging of this file.  Please review the following information to ensure the GNU General Public License version 3.0 requirements will be met: http://www.gnu.org/copyleft/gpl.html.
 
 MarketPosition: Representation of the positions of a marker. It holds the x and y position (relative, going from 0 to 1) and the rotation in degrees.
 */

public class MarkerPosition {
  private float x;
  private float y;
  private float rotation;

  public MarkerPosition() {
  }

  public MarkerPosition(float x, float y, float rotation) {
    setX(x);
    setY(y);
    setRotation(rotation);
  }

  public float getX() {
    return map(x, 0, 1, 1, 0);
  }

  public void setX(float x) {
    this.x = x;
  }

  public void setY(float y) {
    this.y = y;
  }

  public float getY() {
    return y;
  }

  public void setRotation(float rotation) {
    this.rotation = rotation;
  }

  public float getRotation() {
    return rotation;
  }

  public PVector getPVector() {
    return new PVector(getX(), getY());
  }
}

