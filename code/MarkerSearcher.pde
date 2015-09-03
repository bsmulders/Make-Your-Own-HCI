/*
 This file is part of Make Your Own HCI!
 
 Copyright (c) 2012, Bobbie Smulders
 
 Contact: mail@bsmulders.com
 
 GNU General Public License Usage
 This file may be used under the terms of the GNU General Public License version 3.0 as published by the Free Software Foundation and appearing in the file LICENSE included in the packaging of this file.  Please review the following information to ensure the GNU General Public License version 3.0 requirements will be met: http://www.gnu.org/copyleft/gpl.html.
 
 MarkerSearcher:  Helper class for searchign markers. After initialisation, the position of the markers can be requested by inputing an image.
 */

import jp.nyatla.nyar4psg.*; 
import java.io.FilenameFilter;

public class MarkerSearcher {
  private int width;
  private int height;
  private MultiMarker nyAR;
  private int markerCount;

  public MarkerSearcher(PApplet parent, int width, int height) {
    setWidth(width);
    setHeight(height);

    initNyAR(parent, sketchPath("") + "res/camera_para.dat");
    loadPatterns(sketchPath("") + "pattern");
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

  public MultiMarker getNyAR() {
    return nyAR;
  }

  public void setNyAR(MultiMarker nyAR) {
    this.nyAR = nyAR;
  }

  public int getMarkerCount() {
    return markerCount;
  }

  private void setMarkerCount(int markerCount) {
    this.markerCount = markerCount;
  }

  private void initNyAR(PApplet parent, String cParam) {
    setNyAR(new MultiMarker(parent, getWidth(), getHeight(), cParam, NyAR4PsgConfig.CONFIG_DEFAULT));
    getNyAR().setLostDelay(5);
    getNyAR().setConfidenceThreshold(0.8);
  }

  private void loadPatterns(String patternPath) {
    String[] patterns = getPatternFilenames(patternPath);
    setMarkerCount(patterns.length);
    for (int i = 0; i < markerCount; i++) {
      getNyAR().addARMarker(patternPath + "/" + patterns[i], 80);
    }
  }

  public MarkerPosition[] getMarkerLocations(PImage cameraImage) {
    MarkerPosition[] result = new MarkerPosition[markerCount];

    getNyAR().detect(cameraImage);
    for (int i = 0; i < markerCount; i++) {
      if (getNyAR().isExistMarker(i)) {
        result[i] = getMarkerPosition(getNyAR().getMarkerVertex2D(i));
      }
    }


    return result;
  }

  private MarkerPosition getMarkerPosition(PVector[] pvs) {
    int x = int((pvs[0].x + pvs[2].x)/2);
    int y = int((pvs[0].y + pvs[2].y)/2);
    float relX = norm(x, width, 0);
    float relY = norm(y, height, 0);
    float rot = degrees(atan2(pvs[1].y-pvs[0].y, pvs[1].x-pvs[0].x)); 
    rot = (rot < 0) ? 360 + rot : rot;
    return new MarkerPosition(relX, relY, rot);
  }

  private String[] getPatternFilenames(String path) {
    File folder = new File(path);
    FilenameFilter pattFilter = new FilenameFilter() {
      public boolean accept(File dir, String name) {
        return name.toLowerCase().endsWith(".patt");
      }
    };

    return folder.list(pattFilter);
  }
}