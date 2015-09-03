/*
 This file is part of Make Your Own HCI!
 
 Copyright (c) 2012, Bobbie Smulders
 
 Contact: mail@bsmulders.com
 
 GNU General Public License Usage
 This file may be used under the terms of the GNU General Public License version 3.0 as published by the Free Software Foundation and appearing in the file LICENSE included in the packaging of this file.  Please review the following information to ensure the GNU General Public License version 3.0 requirements will be met: http://www.gnu.org/copyleft/gpl.html.
 
 Application startpoint: It initializes the MVC model and forwards all events.
 */

Model model;
View view;
Controller controller;

void setup() {
  size(displayWidth, displayHeight);  
  frameRate(30);

  model = new Model(this);
  view = new View(model);
  controller = new Controller(model, view);
}

void draw() {
  model.threadEvent();
  view.drawScreen();
}

void mousePressed() {
  controller.mousePress();
}