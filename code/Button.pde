/*
 This file is part of Make Your Own HCI!
 
 Copyright (c) 2012, Bobbie Smulders
 
 Contact: mail@bsmulders.com
 
 GNU General Public License Usage
 This file may be used under the terms of the GNU General Public License version 3.0 as published by the Free Software Foundation and appearing in the file LICENSE included in the packaging of this file.  Please review the following information to ensure the GNU General Public License version 3.0 requirements will be met: http://www.gnu.org/copyleft/gpl.html.
 
 Button: Representation of a button. It holds the start position, end postion and current position. It also has intelligence to calculate what type of button it is and what value it holds.
 */

public class Button {
  private MarkerPosition start;
  private MarkerPosition end;
  private MarkerPosition current;
  private ButtonType type = ButtonType.UNDEFINED;
  private int value;
  private int appearances = 0;

  public Button() {
  }

  public Button(MarkerPosition start) {
    setStart(start);
  }

  public MarkerPosition getStart() {
    return start;
  }

  public void setStart(MarkerPosition start) {
    this.start = start;
  }

  public MarkerPosition getEnd() {
    return end;
  }

  public void setEnd(MarkerPosition end) {
    this.end = end;
  }

  public MarkerPosition getCurrent() {
    return current;
  }

  public void setCurrent(MarkerPosition current) {
    this.current = current;
    setValue(calculateValue());
  }

  public int getValue() {
    return value;
  }

  private void setValue(int value) {
    this.value = value;
  }

  public ButtonType getType() {
    return type;
  }

  private void setType(ButtonType type) {
    this.type = type;
  }

  public int getAppearances() {
    return appearances;
  }

  public void addCalibrationPosition(MarkerPosition mp) {
    setCurrent(mp);
    appearances++;

    if (getStart() == null) {
      setStart(mp);
    } else if (getEnd() == null) {
      setEnd(mp);
    } else {
      float startToEndDistance = dist(getStart().getX(), getStart().getY(), getEnd().getX(), getEnd().getY());
      float distanceToStart = dist(getStart().getX(), getStart().getY(), mp.getX(), mp.getY());
      float distanceToEnd = dist(getEnd().getX(), getEnd().getY(), mp.getX(), mp.getY());

      if (distanceToStart > startToEndDistance || distanceToEnd > startToEndDistance) {
        if (distanceToStart < distanceToEnd) {
          setStart(mp);
        } else if (distanceToEnd <= distanceToStart) {
          setEnd(mp);
        }
        setType(calculateType());
      }
    }
  }

  private ButtonType calculateType() {
    float dDiff = dist(getStart().getX(), getStart().getY(), getEnd().getX(), getEnd().getY());
    float rDiff = getStart().getRotation() - getEnd().getRotation();
    while (rDiff < -180) rDiff += 360;
    while (rDiff > 180) rDiff -= 360;

    if (rDiff > 30)
      return ButtonType.KNOB; 
    else if (dDiff < 0.11 && dDiff > 0.02)
      return ButtonType.TOGGLE;
    else if (dDiff > 0.11)
      return ButtonType.SLIDER;
    else 
    return ButtonType.UNDEFINED;
  }

  private int calculateValue() {    
    switch(type) {
    case SLIDER:
      return calculateSliderValue();
    case TOGGLE:
      return calculateToggleValue();
    case KNOB:
      return calculateKnobValue();
    default:
      return 0;
    }
  }

  private int calculateSliderValue() {
    float distanceStart = abs(getStart().getX() - getCurrent().getX()) + abs(getStart().getY() - getCurrent().getY());
    float distanceEnd = abs(getEnd().x - current.x) + abs(getEnd().y - getCurrent().y);  
    float distanceTotal = distanceStart + distanceEnd;

    return int( (distanceStart / distanceTotal) * 100.0 );
  }

  private int calculateToggleValue() {
    float distanceStart = abs(getStart().getX() - getCurrent().getX()) + abs(getStart().getY() - getCurrent().getY());
    float distanceEnd = abs(getEnd().getX() - getCurrent().getX()) + abs(getEnd().getY() - getCurrent().getY());  

    return (distanceStart < distanceEnd) ? 1 : 2;
  }

  private int calculateKnobValue() {
    float distanceStart = abs(getStart().getRotation() - getCurrent().getRotation());
    float distanceEnd = abs(getEnd().getRotation() - getCurrent().getRotation());  
    float distanceTotal = distanceStart + distanceEnd;

    return int( (distanceStart / distanceTotal) * 100.0 );
  }
}