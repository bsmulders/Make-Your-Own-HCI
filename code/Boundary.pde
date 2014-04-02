/*
 This file is part of Make Your Own HCI!
 
 Copyright (c) 2014, Bobbie Smulders
 
 Contact: mail@bsmulders.com
 
 GNU General Public License Usage
 This file may be used under the terms of the GNU General Public License version 3.0 as published by the Free Software Foundation and appearing in the file LICENSE included in the packaging of this file.  Please review the following information to ensure the GNU General Public License version 3.0 requirements will be met: http://www.gnu.org/copyleft/gpl.html.
 
 Boundary: Part of physics game. Based on the "The Nature of Code" example <http://www.shiffman.net/teaching/nature>
 */

class Boundary {

  Body body;

  Boundary(float x, float y, float w, float h, Box2DProcessing box2d) {
    PolygonShape sd = new PolygonShape();

    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);

    sd.setAsBox(box2dW, box2dH);

    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    setBody(box2d.createBody(bd));

    getBody().createFixture(sd, 1);
  }

  public Body getBody() {
    return body;
  }

  public void setBody(Body body) {
    this.body = body;
  }
}

