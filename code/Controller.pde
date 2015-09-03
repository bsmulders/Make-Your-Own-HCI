/*
 This file is part of Make Your Own HCI!
 
 Copyright (c) 2012, Bobbie Smulders
 
 Contact: mail@bsmulders.com
 
 GNU General Public License Usage
 This file may be used under the terms of the GNU General Public License version 3.0 as published by the Free Software Foundation and appearing in the file LICENSE included in the packaging of this file.  Please review the following information to ensure the GNU General Public License version 3.0 requirements will be met: http://www.gnu.org/copyleft/gpl.html.
 
 Controller: It sends all input to the model in the appropriate way
 */

public class Controller {
  private Model model;
  private View view;

  public Controller() {
  }

  public Controller(Model model, View view) {
    setModel(model);
    setView(view);
  }

  public Model getModel() {
    return model;
  }

  public void setModel(Model model) {
    this.model = model;
  }

  public void setView(View view) {
    this.view = view;
  }

  public void mousePress() {
    if (mouseButton == RIGHT) {
      getModel().toggleBackground();
    }
    else if (mouseButton == LEFT) {
      getModel().nextProgramState();
    }
  }
}