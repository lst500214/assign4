//initialize 
  final int GAME_START = 0;
  final int GAME_RUN = 1;
  final int GAME_LOSE = 2;
  final int PART1 = 0;
  final int PART2 = 1;
  final int PART3 = 2;

  float x=0, y=0;
  float treasureX, treasureY;
  float percentage, hpWeightX, hpWeightY; 
  //enemyY2, enemyY3;
  float spacingX = 60, spacingY = 50;
  float indexOne, indexTwo;
  //float [] enemyDist = new float [3];
  float enemyDist;
  float treasureDist;
  float [] enemyX;
  float enemyY;
  int currentFrame;
  int numFrames = 5;
  int wave5 = 5;
  int gameState;
  int enemyPart;
  
  // key press moving for jet flying
  float speed = 5;
  float jetX = 580; 
  float jetY = 240;
  float jetH = 51;
  float jetW = 51;
  boolean [] enemyDestroy = new boolean[wave5];
  boolean [] touched = new boolean[wave5];
  boolean upPressed = false;
  boolean downPressed = false;
  boolean leftPressed = false;
  boolean rightPressed = false;
  boolean enterPressed = false;

  PImage jet, hpBar, treasure, bgOne, bgTwo, enemy, end, endHover, start, startHover; 
  PImage [] flames;
  
void setup () {
  size(640,480) ;  
  background(255);
  
  //loading images
  bgOne      = loadImage("img/bg1.png");
  bgTwo      = loadImage("img/bg2.png");
  jet        = loadImage("img/fighter.png");
  hpBar      = loadImage("img/hp.png");
  treasure   = loadImage("img/treasure.png");
  enemy      = loadImage("img/enemy.png");
  end        = loadImage("img/end2.png");
  endHover   = loadImage("img/end1.png");
  start      = loadImage("img/start2.png");
  startHover = loadImage("img/start1.png");
  
  //initialize frame count of flames
  currentFrame = 0;
  
  //loading flame 5 images
  flames     = new PImage[numFrames];
  for(int f=0; f<flames.length; f++){
    String imageName = "img/flame" + (f+1) + ".png";
    flames[f] = loadImage(imageName);
  }
  
  //initialize enemy distance status
  for(int b=0; b<5; b++){
    enemyDestroy[b] = false;
  }
  
  for(int t=0; t<touched.length; t++){
  touched[t] = false;
  }
  
  //X, Y setting for background
  indexOne = width;
  indexTwo = 0;
  
  //initial enemy x position
  enemyX = new float [wave5];
  enemyY = floor(random(40, 219));
  treasureX = floor(random(200,550));
  treasureY = floor(random(40,430));
  
  enemyX[0] = -250;
  
  //set HP Bar percentage
  percentage = 200/100;
  hpWeightX = percentage * 20;
  hpWeightY = 30;
  
  //set initial gameState in start;
  gameState = GAME_START;
  enemyPart = PART1;
}

void draw() {
  background(255);
  
  switch (gameState){
    
    case GAME_START:
      //reset HP bar
      hpWeightX = percentage * 20;
      image(start, x, y);
      
      //reset jet x y position
      jetX = 580; 
      jetY = 240;
      
      //reset treasure position in random X asix and Y asix
      treasureX = floor(random(200,550));
      treasureY = floor(random(40,430));
      
      //mouse action and hover on start background 
      if (mouseY > 370 && mouseY < 420){
        if(mouseX > 200 && mouseX < 470)
          //start button hovered
          image(startHover, x, y);
            if (mousePressed){
            //click to start
            gameState = GAME_RUN;        
            }
        }
      break;
      
    case GAME_RUN:
    
     println("the first hp " + hpWeightX);
      
      //infinite looping background
      image(bgOne, indexOne - width, 0);
      image(bgTwo, indexTwo - width, 0);
      indexOne++;
      indexTwo++;
      indexOne %= width*2;
      indexTwo %= width*2;

      //jet moving
       if (upPressed) 
         jetY -= speed;
       if (downPressed) 
         jetY += speed;
       if (leftPressed) 
         jetX -= speed;
       if (rightPressed) 
         jetX += speed;
       
      //boundary detection
      if( jetX > width - jetW)
       jetX  = width - jetW;
      if( jetX < 0 )
       jetX = 0 ;
      if( jetY > height - jetH)
       jetY = height - jetH;
      if( jetY < 0)
       jetY = 0;
      
      //enemy
      
      switch(enemyPart){
     
      case PART1:  
      //part 1: a line of 5 enemys 
      for(int i=0; i<enemyX.length; i++){
        enemyX[i] = enemyX[0]+spacingX*i;
        enemyX[i] += speed;
        println(enemyX[i], enemyY);
        
        //enemy detection
        //distance between jet and enemy
        enemyDist= dist(jetX, jetY, enemyX[i], enemyY);
        
        if(enemyDist <= 61){
          //hp bar down 20 point
          touched[i] = true;
          enemyDestroy[i] = true;
          
          if(enemyX[i]>(jetX+250)){
             touched[i] = false;
          }
          
          //show flames
          if (frameCount % (60/10) == 0){
            int c = (currentFrame ++) % numFrames;
            image(flames[c], enemyX[i], jetY);
          }
        }
        
        if(enemyX[i] > width){
          enemyDestroy[i] = false;
          }
          
        if(enemyX[i] > width+250){
          enemyX[0]= -250;
          enemyY = random(40, 219);
          enemyPart = PART2;
        }
      
        if(enemyDestroy[i] == false){
          image(enemy, enemyX[i], enemyY);
        }
      } 
      println(touched[0]);
      break;
      
      //part 2: lineslash enemys
    
      case PART2:
      for(int j=0; j<5; j++){  
       int lineCount = 4-j;
       enemyX[j] = enemyX[0]+spacingX*j;
       enemyX[j] += speed;
        
        //enemy detection
        //distance between jet and enemy
        enemyDist = dist(jetX, jetY, enemyX[j], enemyY+spacingY*lineCount);
        
        if(enemyDist <= 61){
          //hp bar down 20 point
          touched[1] = true;
          enemyDestroy[j] = true;

          //show flames
          if (frameCount % (60/10) == 0){
            int d = (currentFrame ++) % numFrames;
            image(flames[d], enemyX[j], jetY);
          }
        }
        
        if(enemyX[j] > width){
          enemyDestroy[j] = false;
         }
        
         if(enemyX[j] >= width+250){
           enemyX[0]=-250;
           enemyY = random(40, 219);
           enemyPart = PART3; 
         }
        if(enemyDestroy[j] == false){ 
          image(enemy, enemyX[j], enemyY+spacingY*lineCount);
        }
      }
      break;
      
      //part 3: a square enemys
      
      case PART3:
      for(int g=0; g<5; g++){
       int Count = abs(2-g);
        
        //upperEnemys
        float part3_y = enemyY+spacingY*Count;
        enemyX[g] = enemyX[0]+spacingX*g;
 
        //downEnemeys
        float enemyY2 = enemyY+spacingY*4;
        float part3_y2 = enemyY2-spacingY*Count; 
        
        enemyX[g] += speed;
         
        //distance between jet and enemy
        enemyDist = dist(jetX, jetY, enemyX[g], part3_y);
        
        //enemy detection
        if(enemyDist <= 61){
          //hp bar down 20 point
          touched[2] = true;
          enemyDestroy[g] = true;
          
          //show flames
          if (frameCount % (60/10) == 0){
            int e = (currentFrame ++) % numFrames;
            image(flames[e], enemyX[g], jetY);
          }
        }
        
        if(enemyX[g] > width){
          enemyDestroy[g] = false;
        }
        
        if(enemyX[g] >= width+250){
          enemyX[0]=-250;
          enemyY = random(40, 219);
          enemyPart = PART1; 
        }
         
        if(enemyDestroy[g] == false){ 
          image(enemy, enemyX[g], part3_y);
          image(enemy, enemyX[g], part3_y2);
        }
         
        //println("the enemy distance is "+ enemyDist);
        //println("the x position of enemy" + g + " is " + enemyX[g]);
        //println("enemy State is:" + "[" + g +"]" + enemyDestroy[g]);
       }
      
      break;//part3 end 
      }
      
      //treasure
      //when jet attach treasure
      treasureDist = dist(jetX, jetY, treasureX, treasureY);
      
      if (treasureDist <= 41){
        hpWeightX += (percentage*10); //hp bar up 10 point
        
        //set HP bar maximus 
        if(hpWeightX >= 200){
           hpWeightX = 200;
        }
        
        if(hpWeightX < 0){
          hpWeightX = 0;
        }
        
      //reset treasure random X, Y-axis
      treasureX = floor(random(200,550));
      treasureY = floor(random(40,430));
      }
      
      //treasure
      image(treasure, treasureX, treasureY);
      
      //jet
      image(jet, jetX, jetY);
      
      //HP bar
      scale(1,1);
      fill(#FF0000);
      noStroke();
      rect(6, y, hpWeightX, hpWeightY);
      image(hpBar, x, y);
      
      //game lose
      for (int r=0; r<touched.length; r++){
        if(touched[r] == true){
          hpWeightX = hpWeightX - (percentage*20);
        }   
      }
      println("the end hp " + hpWeightX);
      
      //if (hpWeightX <= 0){
      //gameState = GAME_LOSE;
      //}
      
      break;
      

      
    case GAME_LOSE:
      
      hpWeightX = percentage * 20;
      jetX = 580;
      jetY = 240;
      
      enemyX[0] = -250;
      for(int i=0; i<enemyX.length; i++){
        enemyX[i] = enemyX[0]+spacingX*i;
      }
        
      image(end, x, y);

      //mouse action and hover on start bg
      
      if (mouseY > 300 && mouseY < 350){
        image(endHover, x, y);
        if (mousePressed){
          //click to start
          gameState = GAME_RUN;
          
        }
      }
     
     break;
     
  }//switch()
}//draw()

//setting keypress boolean action

void keyPressed(){
  if (key == CODED && gameState == GAME_RUN) { 
    switch (keyCode) {
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
      case ENTER:
        enterPressed = true;
        break;
    }
  }
  
  //jet shooting when press space bar
  //if(key == " " && gameState == GAME_RUN){}
}
void keyReleased(){
    if (key == CODED) {
    switch (keyCode) {
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
      case ENTER:
        enterPressed = false;
        break;
    }
  }
}
