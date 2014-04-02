/*
 This file is part of Make Your Own HCI!
 
 Copyright (c) 2014, Bobbie Smulders
 
 Contact: mail@bsmulders.com
 
 GNU General Public License Usage
 This file may be used under the terms of the GNU General Public License version 3.0 as published by the Free Software Foundation and appearing in the file LICENSE included in the packaging of this file.  Please review the following information to ensure the GNU General Public License version 3.0 requirements will be met: http://www.gnu.org/copyleft/gpl.html.
 
 Attractor: Part of physics game. Based on the "The Nature of Code" example <http://www.shiffman.net/teaching/nature>
 */

public class Attractor {

  Body body;
  float radius = 16;
  float force = 100;

  public Attractor(float x, float y, Box2DProcessing box2d) {
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;

    bd.position = box2d.coordPixelsToWorld(x, y);
    setBody(box2d.world.createBody(bd));

    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(getRadius());

    getBody().createFixture(cs, 1);
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

  public float getForce() {
    return force;
  }

  public void setForce(float force) {
    this.force = force;
  }

  public Vec2 attract(Mover m) {
    Vec2 pos = getBody().getWorldCenter();    
    Vec2 moverPos = m.getBody().getWorldCenter();

    Vec2 force = pos.sub(moverPos);
    float distance = force.length();

    distance = constrain(distance, 1, 5);
    force.normalize();

    float strength = (getForce() * 1 * m.getBody().m_mass) / (distance * distance); 
    force.mulLocal(strength);
    return force;
  }
}

