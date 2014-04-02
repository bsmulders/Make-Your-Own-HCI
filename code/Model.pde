/*
 This file is part of Make Your Own HCI!
 
 Copyright (c) 2013, Bobbie Smulders
 
 Contact: mail@bsmulders.com
 
 GNU General Public License Usage
 This file may be used under the terms of the GNU General Public License version 3.0 as published by the Free Software Foundation and appearing in the file LICENSE included in the packaging of this file.  Please review the following information to ensure the GNU General Public License version 3.0 requirements will be met: http://www.gnu.org/copyleft/gpl.html.
 
 Model:  It holds all the program state and all application data. 
 */

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import java.util.Timer;

public class Model {
  private MarkerSearcher markerSearcher;
  private Webcam webcam;
  private Button[] buttons;
  private ProgramState programState;
  private boolean displayBackground;

  private Box2DProcessing box2d;
  private Mover[] movers;
  private Attractor[] attractors;
  private MagnetState magnetState;

  public Model(PApplet parent) {    
    setWebcam(new Webcam(parent, 640, 480));
    setMarkerSearcher(new MarkerSearcher(parent, webcam.getWidth(), webcam.getHeight()));
    setBox2D(new Box2DProcessing(parent));

    initModel();
  }

  public MarkerSearcher getMarkerSearcher() {
    return markerSearcher;
  }

  public void setMarkerSearcher(MarkerSearcher markerSearcher) {
    this.markerSearcher = markerSearcher;
  }

  public Webcam getWebcam() {
    return webcam;
  }

  public void setWebcam(Webcam webcam) {
    this.webcam = webcam;
  }

  public Button[] getButtons() {
    return buttons;
  }

  public void setButtons(Button[] buttons) {
    this.buttons = buttons;
  }

  public Mover[] getMovers() {
    return movers;
  }

  public void setMovers(Mover[] movers) {
    this.movers = movers;
  }

  public Attractor[] getAttractors() {
    return attractors;
  }

  public void setAttractors(Attractor[] attractors) {
    this.attractors = attractors;
  }

  public Button getButton(int i) {
    return buttons[i];
  }

  private void setButton(int i, Button b) {
    buttons[i] = b;
  }

  public Attractor getAttractor(int i) {
    return attractors[i];
  }

  public void setAttractor(int i, Attractor a) {
    attractors[i] = a;
  }

  public int getButtonAmount() {
    return buttons.length;
  }

  public ProgramState getProgramState() {
    return programState;
  }

  public void setProgramState(ProgramState programState) {
    this.programState = programState;
  }

  public String getProgramStateText() {
    switch(getProgramState()) {
    case AWAITING_CALIBRATION:
      return "Awaiting calibration";
    case START_POSITIONS:
      return "Calibrating start positions";
    case END_POSITIONS:
      return "Calibrating end positions";
    case CLEANUP:
      return "Cleaning up";
    case CALIBRATED:
      return "Calibrated";
    default:
      return "Undefined state";
    }
  }

  public void nextProgramState() {
    switch(getProgramState()) {
    case AWAITING_CALIBRATION:
      setProgramState(ProgramState.START_POSITIONS);
      break;
    case START_POSITIONS:
      setProgramState(ProgramState.END_POSITIONS);
      break;
    case END_POSITIONS:
      setProgramState(ProgramState.CLEANUP);
      break;
    case CLEANUP:
      setProgramState(ProgramState.CALIBRATED);
      break;
    case CALIBRATED:
      initModel();
      break;
    }
  }

  public MagnetState getMagnetState() {
    return magnetState;
  }

  public void setMagnetState(MagnetState magnetState) {
    this.magnetState = magnetState;
  }

  public boolean displayBackground() {
    return displayBackground;
  }

  public void setDisplayBackground(boolean displayBackground) {
    this.displayBackground = displayBackground;
  }

  public void toggleBackground() {
    setDisplayBackground(!displayBackground());
  }

  public Box2DProcessing getBox2D() {
    return box2d;
  }

  public void setBox2D(Box2DProcessing box2d) {
    this.box2d = box2d;
  }

  private void initModel() {
    setButtons(new Button[getMarkerSearcher().getMarkerCount()]);
    setProgramState(ProgramState.AWAITING_CALIBRATION);
    setDisplayBackground(true);
    setMovers(new Mover[25]);
    setAttractors(new Attractor[getMarkerSearcher().getMarkerCount()]);
    resetBox2D();
  }

  private void resetBox2D() {
    box2d.createWorld();
    box2d.setGravity(0, 0);

    for (int i = 0; i < movers.length; i++) {
      movers[i] = new Mover(random(width), random(height), box2d);
    }

    new Boundary(width/2, height-5, width, 10, box2d);
    new Boundary(width/2, 5, width, 10, box2d);
    new Boundary(width-5, height/2, 10, height, box2d);
    new Boundary(5, height/2, 10, height, box2d);
  }

  public void threadEvent() {      
    switch(getProgramState()) {
    case AWAITING_CALIBRATION:
      if (!displayBackground()) {
        updateCamera();
      }
      break;
    case START_POSITIONS:
      setStartPositions();
      break;
    case END_POSITIONS:
      setEndPositions();
      break;
    case CLEANUP:
      cleanupCalibration();
      nextProgramState();
      break;
    case CALIBRATED:
      updateCurrentPositions(); 
      updateWorld();
      break;
    }
  }

  private void updateCamera() {
    getWebcam().getCameraImage();
  }

  private void setStartPositions() {
    PImage capture = getWebcam().getCameraImage();
    MarkerPosition[] mps = getMarkerSearcher().getMarkerLocations(capture);    

    for (int i = 0; i < mps.length; i++) {
      if (mps[i] != null) {
        setButton(i, new Button(mps[i]));
      }
    }
  }

  private void setEndPositions() {
    PImage capture = getWebcam().getCameraImage();
    MarkerPosition[] mps = getMarkerSearcher().getMarkerLocations(capture);    

    for (int i = 0; i < mps.length; i++) {
      if (mps[i] != null && getButton(i) != null) {
        getButton(i).setEnd(mps[i]);
      }
    }
  }

  private void updateCurrentPositions() {
    PImage capture = getWebcam().getCameraImage();
    MarkerPosition[] mps = getMarkerSearcher().getMarkerLocations(capture);

    for (int i = 0; i < mps.length; i++) {
      if (mps[i] != null && getButton(i) != null) {
        Button button = getButton(i);
        button.setCurrent(mps[i]);

        if (button.getType() == ButtonType.KNOB) {
          getAttractor(i).setForce(button.getValue());
        } 
        else if (button.getType() == ButtonType.TOGGLE) {
          if (button.getValue() == 1)
            setMagnetState(MagnetState.ATTRACTING);
          else if (button.getValue() == 2)
            setMagnetState(MagnetState.REPULSING);
        } 
        else if (button.getType() == ButtonType.SLIDER) {
          getBox2D().setGravity(0.0, button.getValue() * -1);
        }
      }
    }
  }

  private void cleanupCalibration() {
    for (int i = 0; i < getButtonAmount(); i++) {
      Button button = getButton(i);
      if (button == null || button.getStart() == null || button.getEnd() == null) {
        setButton(i, null);
      } 
      else if (button.getType() == ButtonType.KNOB) {
        setAttractor(i, new Attractor(button.getStart().getX() * width, button.getStart().getY() * height, box2d));
      }
    }
  }

  private void updateWorld() {
    box2d.step();    

    for (int i = 0; i < movers.length; i++) {
      for (int j = 0; j < attractors.length; j++) {
        if (attractors[j] != null) {
          Vec2 force = attractors[j].attract(movers[i]);
          movers[i].applyForce(force, (getMagnetState() == MagnetState.REPULSING));
        }
      }
    }
  }
}

