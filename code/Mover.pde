/*
 This file is part of Make Your Own HCI!
 
 Copyright (c) 2014, Bobbie Smulders
 
 Contact: mail@bsmulders.com
 
 GNU General Public License Usage
 This file may be used under the terms of the GNU General Public License version 3.0 as published by the Free Software Foundation and appearing in the file LICENSE included in the packaging of this file.  Please review the following information to ensure the GNU General Public License version 3.0 requirements will be met: http://www.gnu.org/copyleft/gpl.html.
 
 Mover: Part of physics game. Based on the "The Nature of Code" example <http://www.shiffman.net/teaching/nature>
 */

class Mover {

  Body body;
  float radius = 8;

  Mover(float x, float y, Box2DProcessing box2d) {
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;

    bd.position = box2d.coordPixelsToWorld(x, y);
    setBody(box2d.world.createBody(bd));

    box2d.setScaleFactor(100);

    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(getRadius());

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;

    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    getBody().createFixture(fd);
  }

  public Body getBody() {
    return body;
  }

  public void setBody(Body body) {
    this.body = body;
  }

  public float getRadius() {
    return radius;
  }

  public void setRadius(float radius) {
    this.radius = radius;
  }

  void applyForce(Vec2 v, boolean repulse) {
    if (repulse) {
      Vec2 inverse = new Vec2(v.x*-1, v.y*-1);
      getBody().applyForce(inverse, getBody().getWorldCenter());
    }
    else {
      getBody().applyForce(v, getBody().getWorldCenter());
    }
  }
}

