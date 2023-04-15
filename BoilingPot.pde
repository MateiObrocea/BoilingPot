/*
 */

Stove gasStove;
Pot pot;

void setup() {
  //fullScreen();
  size(650, 500);
  gasStove = new Stove(width/2 - 100, height - 100);
  pot = new Pot(gasStove.xPos, gasStove.yPos - 270);
}

void draw() {
  background(50, 50, 50);
  gasStove.display();
  pot.render();
  pot.boil(gasStove.button.isOn, 3, int(gasStove.button.buttonAngle * 100));
}


void mousePressed() {
  gasStove.turnOn(mouseX, mouseY);
}

class Bubble {

  float xPos, yPos, initX, initY;
  float xSpeed, ySpeed;

  Bubble(float myX, float myY) {
    xPos = myX;
    yPos = myY;
    initX = myX;
    initY = myY;
    ySpeed = -3;
  }

  void display() {
    stroke(255, 40);
    strokeWeight(3);
    noFill();
    circle(xPos, yPos, 15);
  }

  void update(float middlePos,float threshold) {
    initX = randomGaussian();
    initX = (initX * 20) + middlePos;
    yPos += ySpeed;
    if (yPos < threshold) { //a loop animation
      xPos = initX;
      yPos = initY;
    }
  }
}

class BubbleSystem {
  final int maxElements = 10; //maximum nr of bubbles
  int generated;
  int counter = 0;
  
  Bubble[] bubbleArray = new Bubble[maxElements];
  BubbleSystem() {
  }

  void raise(float middlePos, float threshold) {
    for (int i=0; i < generated; i++) {         
      bubbleArray[i].display();
      bubbleArray[i].update(middlePos, threshold);
    }
  }

  void generate(float bubbleX, float bubbleY, float stepSize) {
    //a function that generates bubbles progresively
    //stepSize becomes the size of the flame, and the larger the flame the quicker the bubbles generate
    //part of this function is similar to the approach of Angelika Mader on generating confetties in an example of Wk1
    counter++;
    if (stepSize != 0) {//avoid division by 0
      if (counter % stepSize == 0) {
        if (generated < maxElements) {
          Bubble newBubble = new Bubble(bubbleX, bubbleY); 
          bubbleArray[generated] = newBubble;
          generated++;
        }
      }
      if (counter > maxElements * stepSize) { //avoids an overincrease in the value of counter
        counter = 0;
      }
    }
  }

  void eliminate(int stepSize) {
    //eliminates the bubbles in a similar manner as generating them, when the stove is off
    counter ++;
    if (counter % stepSize * 4 == 0) { //stepSize*4 because we want to eliminate the bubbles quicker than generating them
      if (generated > 0) {
        generated-- ;
      }
      if (counter > maxElements * stepSize) {
        counter = 0;
      }
    }
  }
}


class Button {
  float xPos, yPos, buttonAngle;
  boolean isOn;

  Button(float myX, float myY) {
    xPos = myX + 50;
    yPos = myY;
    buttonAngle = 0;
    isOn = false;
  }

  void display() {
    pushMatrix();
    translate(xPos, yPos);
    rotate(buttonAngle);
    arc(0, 0, 20, 20, -PI/3, 4 * PI/3);
    line(0, -2, 0, - 12);
    popMatrix();
  }

  boolean isWithin(float mX, float mY) {
    //checks if the mouse is above the button
    if (dist(mX, mY, xPos, yPos) < 20) {
      return true;
    } else return false;
  }

  void turnOn(float mX, float mY) {
    //function that rotates the button for 2 separate angles
    if (isWithin(mX, mY) ) {
      if (buttonAngle >= PI/3) {
        buttonAngle = 0;
      } else buttonAngle += PI/6;
      if (buttonAngle == 0) {
        isOn = false;
      } else {
        isOn = true;
      }
    }
  }
}



class Flame {
  float xOff = 0;
  float xPos, yPos;

  Flame(float myX, float myY) {
    xPos = myX;
    yPos = myY;
  }

  void display(float scaleFactor) {
    //for each flame, two parameters of them are tweaked with perlin noise
    
    float y = 0;
    xOff += 0.04;
      
    //middle flame
    pushMatrix();
    translate(xPos, yPos);
    y = map(noise(xOff), 0, 1, -200, 200); //
    scale(scaleFactor);
    fill(240, 170, 50);
    bezier(0, 0, -160, 0, -60 - y * 0.75, -325, y, -400);
    bezier(0, 0, 160, 0, 60 - y * 0.75, -325, y, -400);
    scale(0.5);
    fill(255, 255, 0);
    bezier(0, -25, -160, -25, -60 - y * 0.4, -315, y * 0.6, -390);
    bezier(0, -25, 160, -25, 60 - y * 0.4, -315, y * 0.6, -390);
    popMatrix();


    //left flame
    pushMatrix();
    translate(xPos - 5, yPos);
    rotate (-PI/3);
    scale(scaleFactor);
    y = map(noise(xOff), 0, 1, 0, 200); //move from down to up
    fill(255);
    fill(240, 170, 50);
    bezier(0, 0, -160, 0, -60 - y * 0.75, -325, y, -400);
    bezier(0, 0, 160, 0, 60 - y * 0.75, -325, y, -400);
    scale(0.5);
    fill(255, 255, 0);
    bezier(0, -25, -160, -25, -60 - y * 0.4, -315, y * 0.6, -390);
    bezier(0, -25, 160, -25, 60 - y * 0.4, -315, y * 0.6, -390);
    popMatrix();

   //right flame
    pushMatrix();
    translate(xPos + 5, yPos);
    rotate (PI/3);
    scale(scaleFactor);
    y = map(noise(xOff), 0, 1, 0, -200); //move from down to up; different values because it has another angle
    fill(255);
    fill(240, 170, 50);
    bezier(0, 0, -160, 0, -60 - y * 0.75, -325, y, -400);
    bezier(0, 0, 160, 0, 60 - y * 0.75, -325, y, -400);

    scale(0.5);
    fill(255, 255, 0);
    bezier(0, -25, -160, -25, -60 - y * 0.4, -315, y * 0.6, -390);
    bezier(0, -25, 160, -25, 60 - y * 0.4, -315, y * 0.6, -390);

    popMatrix();
  }
}


class Pot {

  float xPos, yPos;
  int nrElements = 110;
  boolean isBoiling;

  WaterSegment[] segments = new WaterSegment[nrElements];
  BubbleSystem bubbles;

  Pot(float myX, float myY) {
    xPos = myX;
    yPos = myY;
    for (int i = 0; i < nrElements; i++) {         
      segments[i] = new WaterSegment(xPos + i * 2, yPos, 0.5, 0.1, 0.15);
    }
    bubbles = new BubbleSystem();
  }

  void render() {
    //water part
    for (int i = nrElements-1; i >= 0; i--) {
      segments[i].display();
    }

    //pot part
    pushMatrix();
    translate(xPos, yPos);
    fill(segments[2].waterColor);
    rect(-4, 20, nrElements * 2 + 6, 200);
    fill(150);
    rect(-15, -50, 15, 270);
    rect(nrElements * 2 - 9, -50, 15, 270);
    rect(-15, 210, nrElements * 2 + 21, 15);
    popMatrix();
  }

  void boil(boolean heatUp, float intensity, int stepSize) {
    updateSegments();
    spawnBubbles(xPos, yPos, heatUp, stepSize);
    updateBubbles(intensity);
  }

  void updateSegments() {
    //gives the neighbours a force and a velocity
    for (int i = nrElements-1; i >= 0; i--) {
      float f = 0;
      float v = 0;
      if (i == nrElements-1) {
        f = 0;
      } else if (i == 0) {
        v = 0;
      } else {
        f = segments[i-1].force;
        v = segments[i+1].velocity;
      }
      segments[i].update(f, v);
    }
  }

  void spawnBubbles(float potX, float potY, boolean heatUp, int stepSize) {
    if (heatUp) {
      bubbles.generate(potX + 100, random(potY + 60, potY + 200), 120 - stepSize); //the bigger the flame the quicker it boils
    } else bubbles.eliminate(10);
  }

  void updateBubbles(float intensity) {
    //iterates through all the bubbles and segments, and give a force to the water segment that coincides in xposition with the bubble
    for (int j = 0; j < bubbles.generated; j++) {
      for (int i = 0; i < nrElements; i++) {
        if (bubbles.bubbleArray[j].xPos >= segments[i].xPos - segments[i].radius && bubbles.bubbleArray[j].xPos <= segments[i].xPos + segments[i].radius 
          && bubbles.bubbleArray[j].yPos >= segments[i].yPos - segments[i].radius && bubbles.bubbleArray[j].yPos <= segments[i].yPos + segments[i].radius) {
          segments[i].addForce(intensity);
        }
      }
    }
    bubbles.raise(xPos + 100, yPos);
  }
}



class Stove {
  float xPos, yPos;
  Flame stoveFlames;
  Button button;

  Stove(float myX, float myY) {
    xPos = myX;
    yPos = myY;
    stoveFlames = new Flame(xPos + 100, yPos);
    button = new Button(xPos + 50, yPos + 35);
  }

  void display() {

    if (button.isOn == true) {
      stoveFlames.display(button.buttonAngle /(PI/3 * 10)); //the flames render when the button is on and they change in size based on the button's angle
    }

    pushMatrix();
    translate(xPos, yPos);
    stroke(0);
    strokeWeight(7);
    noFill();

    bezier(50, 0,60, - 15,80, -15, 80, - 15);
    bezier(150, 0, 140, -15, 120, -15, 120, -15);
    line(100, 0, 100, -15);

    fill(201);
    noStroke();
    rect(20, 0, 160, 65, 10);
    stroke(0);
    strokeWeight(2);
    popMatrix();

    button.display();
  }

  void turnOn(float mX, float mY) {
    //for (int i = 0; i < buttons.length; i++) {
    button.turnOn(mX, mY);
    //}
  }
}

class WaterSegment {
  color waterColor;
  float xPos, yPos, mass, springConstant, friction, force, velocity, initPos, radius;
  float yDisplacement = 0;

  WaterSegment(float myX, float myY, float myMass, float mySpringConstant, float myFriction) {
    velocity = 0;
    xPos = myX;
    yPos = myY;
    mass = myMass;
    springConstant = mySpringConstant;
    friction = myFriction;
    force = 0;
    yPos = myY;
    initPos = myY;
    radius = 4;
  }

  void display() { 
    colorMode(HSB);
    waterColor = color(145, 255, 255); 
    colorMode(RGB);
    fill(waterColor);
    noStroke();
    circle(xPos, yPos, radius);
    rect(xPos - radius, yPos, 2 * radius, 70);
  }

  void update(float myForce, float myVelocity) {
    //function that describes the movement of the segments
    float f = myForce - force;
    float acceleration = f/mass;
    velocity += acceleration;
    float v = velocity - myVelocity;
    yDisplacement += v;
    float upperSegment = v * friction;
    float lowerSegment = yDisplacement * springConstant;
    force = upperSegment + lowerSegment;
    yPos = initPos - yDisplacement;
  }

  void addForce(float myForce) {
    //receives force here
    force = myForce;
  }
}
