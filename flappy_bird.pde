import processing.sound.*;
import controlP5.*;

int lives = 10;
PImage mountain, bird, gameover;  //images vriables
Bird b = new Bird();  //bird object
Pipe [] p = new Pipe[3];  //pipes
SoundFile flap, collision;  //sound files
ControlP5 control;  //gui object
boolean start;  //boolean to decide when to start the game

void setup(){
  size(600,800);
  mountain = loadImage("background.jpg"); // Fetch the mountain image
  bird = loadImage("bird.png"); //Fetch the image of bird
  
  flap = new SoundFile(this, "birdflap.wav");  //wing flapping sound
  flap.rate(0.75);
  collision = new SoundFile(this, "metal-impact.wav");  //collision sound
  collision.amp(0.3);
  
  gui();  //create gui elements
  welcomeScreen();  //show welcome screen
  
  for(int i=0;i<3;i++){  //create pipe objects
    p[i] = new Pipe((i+1)*random(200,250));
  }
  start = false;
}

void draw(){
  image(mountain, 0,0);
  if(lives == 0 || b.pos.y>width+2*b.r){  //game over if no lives or bird hits the ground
    gameoverScreen();
  } else if(start) {
    removeControlItems();
    if(mousePressed){  //press mouse button to jump
        delay(10);
        b.applyForce();
    }
    
    for(int i=0;i<3;i++){  //display pipes
      p[i].show();
      p[i].update();
      if(p[i].collide()){  //if bird collides with any pipe decrement lives
        lives--;
        b.pos.x+=p[i].w+b.r;  //skip the pipe that bird collided with
        tint(color(255,0,0),150);
      }
    }
    
    b.show();  //display bird
    delay(30);
    tint(255,255);
    b.update();
    //display lives count
    textSize(20);
    fill(color(255,0,0));
    text("lives: "+lives,width-80,30);
  }
}

void gameoverScreen(){//show gamee over screen elements
  control.getController("gameover").show();
  control.getController("Yes").show();
  control.getController("No").show();
}

void welcomeScreen(){//show welcome screen elements
  control.getController("difficulty").show();
  control.getController("Easy").show();
  control.getController("Medium").show();
  control.getController("Hard").show();
  control.getController("Play").show();
}

void removeControlItems(){//removing welcome screen elements
      control.getController("Easy").hide();
      control.getController("Medium").hide();
      control.getController("Hard").hide();
      control.getController("Play").hide();
      control.getController("difficulty").hide();
}

class Bird{
  PVector pos;  //bird position
  float r=41;  //bird image radius
  
  Bird(){
    pos = new PVector(height/18, width/2.13);
  }
  
  void show(){
    if(lives>0){
      image(bird, pos.x, pos.y);
    }
  }
  
  void update(){  //bird falls down by default
    delay(50);
    pos.y+=10;
  }
  
  void applyForce(){  //jump upwards
   flap.play();
   pos.y-=50;
  }
}

class Pipe{
  float x;  //horizontal pipe position
  float w;  //pipe width
  float top;  //top pipe height
  float bottom;  //bottom pipe height
  
  public Pipe(float x){
    this.x = x;
    w=50;
    top=random(200,400);  //top pipe with random height
    bottom=height-(top+200);  //bottom pipe away from top pipe by 200
  }
  void show(){
    fill(color(0,255,0));
    stroke(0);
    rect(x,0, w, top);
    rect(x,height-bottom, w, bottom);
  }
  
  void update(){
    delay(10);  //pipes move to left
    x-=5;
    if(x<=-50){  //if pipe our of screen  generate new one
      x=width+50;
      top=random(200,400);
      bottom=height-(top+200);
    }
  }
  
  boolean collide(){
    if( (b.pos.x+b.r>x) && (b.pos.x < ( x+w ) ) ){  //if bird x coordinate within pipe's
      if((b.pos.y<top || b.pos.y>(height-bottom-1.3*b.r))) {  //if bird y coordinate within pipe's
        collision.play();
        return true;  //bird collided
      }
    }
      return false;
  }
  
}

void reset(){  //hide game over screen
  control.getController("gameover").hide();
  control.getController("Yes").hide();
  control.getController("No").hide();
  //reset game variables
  lives = 10;
  b.pos.x = 0;
  b.pos.y = height/18;
  for(int i=0;i<3;i++){  //create pipe objects
    p[i] = new Pipe((i+1)*random(200,250));
  }
  start = false;
  //show welcome screen
  welcomeScreen();
}

void gui(){//gui elements used in welcome and game over screens
  control = new ControlP5(this);
  //welcome screen elements
  control.addTextlabel("difficulty","Easy")
  .setPosition(250,300)
  .setColor(0)
  .setFont(createFont("Arial", 38))
  .hide();
  
  control.addButton("Easy")
  .setBroadcast(false)
  .setPosition(0, height-150)
  .setSize(width/3, 50)
  .hide()
  .setBroadcast(true);
  
  control.addButton("Medium")
  .setBroadcast(false)
  .setPosition(200, height-150)
  .setSize(width/3, 50)
  .hide()
  .setBroadcast(true);
  
  control.addButton("Hard")
  .setBroadcast(false)
  .setPosition(400, height-150)
  .setSize(width/3, 50)
  .hide()
  .setBroadcast(true);
  
  control.addButton("Play")
  .setBroadcast(false)
  .setPosition(200, 200)
  .setSize(width/3, 50)
  .hide()
  .setBroadcast(true);
  //game over screen elments
  control.addTextlabel("gameover","Game Over\nPlay again?")
  .setPosition(200,200)
  .setColor(0)
  .setFont(createFont("Arial", 38))
  .hide();
  
  control.addButton("Yes")
  .setBroadcast(false)
  .setPosition(100, 500)
  .setSize(150, 50)
  .setColorBackground(color(0,255,0))
  .hide()
  .setBroadcast(true);
  
  control.addButton("No")
  .setBroadcast(false)
  .setPosition(300, 500)
  .setSize(150, 50)
  .setColorBackground(color(255,0,0))
  .hide()
  .setBroadcast(true);
}

void controlEvent(ControlEvent theEvent){//events listener
  if(theEvent.isController()){
    if(theEvent.isFrom("Yes")){
      reset();
    } else if(theEvent.isFrom("No")){
      exit();
    } else if(theEvent.isFrom("Easy")){
      lives = 10;
      control.getController("difficulty").setValueLabel("Easy");
    } else if(theEvent.isFrom("Medium")){
      lives = 5;
      control.getController("difficulty").setValueLabel("Medium");
    } else if(theEvent.isFrom("Hard")){
      lives = 2;
      control.getController("difficulty").setValueLabel("Hard");
    } else {  //play button
      start = true;
    }
  }
}
