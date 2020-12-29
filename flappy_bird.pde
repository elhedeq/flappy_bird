int lives = 3;
PImage mountain, bird, gameover;  //images vriables
Bird b = new Bird();  //bird object
Pipe [] p = new Pipe[3];  //pipes

void setup(){
  size(600,800);
  mountain = loadImage("background.jpg"); // Fetch the mountain image
  bird = loadImage("bird.png"); //Fetch the image of bird
  
  for(int i=0;i<3;i++){  //create pipe objects
    p[i] = new Pipe((i+1)*random(200,250));
  }
}

void draw(){
  image(mountain, 0,0);
  if(lives == 0 || b.pos.y>width+2*b.r){  //game over if no lives or bird hits the ground
    gameoverScreen();
  } else {
    if(mousePressed){  //press mouse button to jump
        delay(10);
        b.applyForce();
    }
    
    for(int i=0;i<3;i++){  //display pipes
      p[i].show();
      p[i].update();
      if(p[i].collide()){  //if bird collides with any pipe decrement lives
        lives--;
        b.pos.x+=p[i].w+5;  //skip the pipe that bird collided with
        tint(255,150);
      }
    }
    
    b.show();  //display bird
    tint(255,255);
    b.update();
    //display lives count
    textSize(20);
    fill(color(255,0,0));
    text("lives: "+lives,width-80,30);
  }
}

void gameoverScreen(){
  textSize(38);
  fill(color(255,0,0));
  text("Game Over", 200, 200);
  text("play again? (y|n)", 200, 300);  //ask if user wants to play again
  if(keyPressed){
    if(key == 'y' || key == 'Y'){  //if y is pressed reset game
      reset();
    } else {  //otherwise exit game
      exit();
    }
  }
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
   pos.y-=20;
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
    if( (b.pos.x>x) && (b.pos.x < ( x+w ) ) ){  //if bird x coordinate within pipe's
      if((b.pos.y<top || b.pos.y>(height-bottom-b.r))) {  //if bird y coordinate within pipe's
        return true;  //bird collided
      }
    }
      return false;
  }
  
}

void reset(){  //reset game variables
  lives = 3;
  b.pos.x = 0;
  b.pos.y = height/18;
  for(int i=0;i<3;i++){  //create pipe objects
    p[i] = new Pipe((i+1)*random(200,250));
  }
}
