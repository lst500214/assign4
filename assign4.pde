//initialize 
  final int GAME_START = 0;
  final int GAME_RUN = 1;
  final int GAME_LOSE = 2;
  final int PART1 = 0;
  final int PART2 = 1;
  final int PART3 = 2;

  float x=0, y=0;
  float treasureX, treasureY;
  float enemyY = floor(random(40,219));
  float percentage, hpWeightX, hpWeightY; 
  float spacingX = 100, spacingY = 50;
  float indexOne, indexTwo;
  float treasureDist;
  //float [] enemyDist = new float[5];
  float [] enemyDistX = new float[8];
  float [] enemyDistY = new float[8];
  float [] enemyX = {-500, -400, -300, -200, -100};
  float [] enemyX3 = {-500, -400, -400, -300, -300, -200, -200, -100}; 
  float [] enemyY2 = {enemyY+240, enemyY+180, enemyY+120, enemyY+60, enemyY};
  float [] enemyY3 = {enemyY+120, enemyY+60, enemyY+180, enemyY, enemyY+240, enemyY+60, enemyY+180, enemyY+120};
  
  int currentFrame;
  int numFrames = 5;
  int gameState;
  int enemyPart;
  
  // key press moving for jet flying
  float speed = 5;
  float jetX = 580; 
  float jetY = 240;
  float jetH = 51;
  float jetW = 51;
  boolean [] enemyDestroy = new boolean[8];
  boolean [] touched = new boolean[8];
  boolean enemySwitch = false;
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
  
  //initialize enemy detection states
  for(int t=0; t<touched.length; t++){
  touched[t] = false;
  enemyDestroy[t] = false;
  }
  
  //X, Y setting for background
  indexOne = width;
  indexTwo = 0;
  
  //initial enemy x position
  enemyY = floor(random(40, 219));
  
  //treasure
  treasureX = floor(random(200,550));
  treasureY = floor(random(40,430));
  
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
     println(enemyDestroy[0],enemyDestroy[1],enemyDestroy[2],enemyDestroy[3],enemyDestroy[4]); 
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
      
      enemySwitch = false;
      
      //part 1: a line of 5 enemys 
      for(int i=0; i<enemyX.length; i++){
        image(enemy, enemyX[i], enemyY);
        enemyX[i] += speed;
        
      //initialize enemy detection states
      for(int t=0; t<touched.length; t++){
        touched[t] = false;
        enemyDestroy[t] = false;
      }
      
        //enemy detection
       enemyDistX[i] = abs(jetX-enemyX[i]);
       enemyDistY[i] = abs(jetY-enemyY); 
       
      if(enemyDistX[i] <= 51 && enemyDistY[i] <= 51){
        touched[i] = true;
      }
        
      if(touched[i] == true){
         
          //show flames//
          float flameX = enemyX[i];
          float flameY = enemyY;
          println("the flame X, y position is: " + flameX, flameY);
            if (frameCount % (60/10) == 0){//show flames
              int c = (currentFrame ++) % numFrames;
              image(flames[c], flameX, flameY);
              println("flames animation done");
            }
          
          hpWeightX = hpWeightX - percentage*20;
          enemyDestroy[i] = true;
        }
          
          if(enemyDestroy[i] == true){
          enemyX[i] = -9999;
          enemyDistX[i] = abs(jetX-enemyX[i]);
          enemyDistY[i] = abs(jetY-enemyY);
          touched[i] = false;
          }
          
        if(enemyX[i] > width){
          enemyDestroy[i] = false;
        }
        
        if(enemyX[i] > width+500){
          enemySwitch = true;
        }
        
        if(enemySwitch==true){
          enemyX[0] = -500;
          enemyX[1] = -400;
          enemyX[2] = -300;
          enemyX[3] = -200;
          enemyX[4] = -100;
          enemyY = random(40, 219);
          constrain(enemyY, 40, 219);
          enemyPart = PART2;
          println("part one done");
          enemySwitch = false;
        } 
    
        if(enemyX[0]<=-1000 && enemyX[1]<=-1000 && enemyX[2]<=-1000 && enemyX[3]<=-1000 && enemyX[4]<=-1000){
          enemyY = random(40, 219);
          constrain(enemyY, 40, 219);
          enemyX[0] = -500;
          enemyX[1] = -400;
          enemyX[2] = -300;
          enemyX[3] = -200;
          enemyX[4] = -100;
          enemyPart = PART2;
          println("part one done");
          enemySwitch = false;
        }
      }
        
      break;
      
      //part 2: lineslash enemys
      
      case PART2:
      println("this is part 2");
            
      for(int i=0; i<5; i++){
      println("the enemy x, y is: " + enemyX[i], enemyY2[i]);
      image(enemy, enemyX[i], enemyY2[i]);
      enemyX[i] += speed;
        
      //initialize enemy detection states
      for(int t=0; t<touched.length; t++){
        touched[t] = false;
        enemyDestroy[t] = false;
      }

      //enemy detection
       enemyDistX[i] = abs(jetX-enemyX[i]);
       enemyDistY[i] = abs(jetY-enemyY2[i]); 
       
      if(enemyDistX[i] <= 51 && enemyDistY[i] <= 51){
        touched[i] = true;
      }
        
      if(touched[i] == true){
         
          //show flames//
          float flameX = enemyX[i];
          float flameY = enemyY+spacingY*(4-i);
          println("the flame X, y position is: " + flameX, flameY);
          
          if (frameCount % (60/10) == 0){//show flames
            int c = (currentFrame ++) % numFrames;
            image(flames[c], flameX, flameY);
            println("flames animation done");
          }
          
          hpWeightX = hpWeightX - percentage*20;
     
          if(hpWeightX < 0){
            hpWeightX = 0;
          }
          
          enemyDestroy[i] = true;
       }
          
       if(enemyDestroy[i] == true){
         enemyX[i] = -9999;
         enemyDistX[i] = abs(jetX-enemyX[i]);
         enemyDistY[i] = abs(jetY-enemyY);
         touched[i] = false;
       }
          
        if(enemyX[i] > width){
          enemyDestroy[i] = false;
        }
        
        if(enemyX[i] > width+500){
          enemySwitch = true;
        }
        
        if(enemySwitch==true){
          enemyX[0] = -500;
          enemyX[1] = -400;
          enemyX[2] = -300;
          enemyX[3] = -200;
          enemyX[4] = -100;
          enemyY = random(40, 219);
          constrain(enemyY, 40, 219);
          enemyPart = PART3;
          println("part 2 done");
         enemySwitch = false;
        } 
    
        if(enemyX[0]<=-1000 && enemyX[1]<=-1000 && enemyX[2]<=-1000 && enemyX[3]<=-1000 && enemyX[4]<=-1000){
          enemyY = random(40, 219);
          enemyX[0] = -500;
          enemyX[1] = -400;
          enemyX[2] = -300;
          enemyX[3] = -200;
          enemyX[4] = -100;
          enemyPart = PART3;
          enemySwitch = false;
          println("part 2 done");
        }  
      }
      
      break;
      
      //part 3: a square enemys
      
      case PART3:
      println("this is part 3");
      for(int i=0; i<8; i++){
        
       //float [] count = new float [5];     
       //for(int a=0; a<count.length; a++){
       //  count[a] = abs(2-a);
       //}
       
       //float [] enemyY2 = new float [5];
       //for(int b=0; b<enemyY2.length; b++){
       //  float y2 = enemyY + spacingY*4;
       //  enemyY2[b] = y2 - spacingY*count[b];
       //}

      image(enemy, enemyX3[i], enemyY3[i]);
      enemyX3[i] += speed;
      
      //initialize enemy detection states
        for(int t=0; t<touched.length; t++){
          touched[t] = false;
          enemyDestroy[t] = false;
        }

      //enemy detection
       
       enemyDistX[i] = abs(jetX-enemyX3[i]);
       enemyDistY[i] = abs(jetY-enemyY3[i]); 
       
      if(enemyDistX[i] <= 51 && enemyDistY[i] <= 51){
        touched[i] = true;
      }
      
      if(touched[i] == true){
          println("now is in the touched state");
         
          //show flames//
          float flameX = enemyX3[i];
          float flameY = enemyY3[i];
          println("the flame X, y position is: " + flameX, flameY);
          
          if (frameCount % (60/10) == 0){//show flames
            int c = (currentFrame ++) % numFrames;
            image(flames[c], flameX, flameY);
            println("flames animation done");
          }
          
          hpWeightX = hpWeightX - percentage*20;
     
          if(hpWeightX < 0){
            hpWeightX = 0;
          }
          enemyDestroy[i] = true;
       }
          
       if(enemyDestroy[i] == true){
         enemyX3[i] = -9999;
         enemyDistX[i] = abs(jetX-enemyX3[i]);
         enemyDistY[i] = abs(jetY-enemyY3[i]);
         touched[i] = false;
       }
          
        if(enemyX3[i] > width){
          enemyDestroy[i] = false;
        }
        
        if(enemyX3[i] > width+500){
          enemyY = random(40, 219);
          enemySwitch = true;
        }
        
        if(enemySwitch==true){
          
          enemyX3[0] = -500; enemyX3[1] = -400;
          enemyX3[2] = -400; enemyX3[3] = -300;
          enemyX3[4] = -300; enemyX3[5] = -200;
          enemyX3[6] = -200; enemyX3[7] = -100;
          
          enemyX[0] = -500;
          enemyX[1] = -400;
          enemyX[2] = -300;
          enemyX[3] = -200;
          enemyX[4] = -100;
          
          enemyY = random(40, 219);
          println("the enemyY is: " + enemyY);
          enemyPart = PART1;
          println("part one done");
        } 
    
        if(enemyX[0]<=-1000 && enemyX[1]<=-1000 && enemyX[2]<=-1000 && enemyX[3]<=-1000 && enemyX[4]<=-1000){
          enemyX3[0] = -500; enemyX3[1] = -400;
          enemyX3[2] = -400; enemyX3[3] = -300;
          enemyX3[4] = -300; enemyX3[5] = -200;
          enemyX3[6] = -200; enemyX3[7] = -100;
          
          enemyX[0] = -500;
          enemyX[1] = -400;
          enemyX[2] = -300;
          enemyX[3] = -200;
          enemyX[4] = -100;
          
          enemyY = random(40, 219);
          enemyPart = PART1;
        }
       
      }
      
      break;//part3 end 
      }//part switch end
      
      //jet attach treasure
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
      
      println("the end hp " + hpWeightX);
      
      if (hpWeightX <= 0){
      gameState = GAME_LOSE;
      }
      
      break;
    
      
    case GAME_LOSE:
      
      enemyX3[0] = -500; enemyX3[1] = -400;
      enemyX3[2] = -400; enemyX3[3] = -300;
      enemyX3[4] = -300; enemyX3[5] = -200;
      enemyX3[6] = -200; enemyX3[7] = -100; 
      
      enemyX[0] = -500;
      enemyX[1] = -400;
      enemyX[2] = -300;
      enemyX[3] = -200;
      enemyX[4] = -100;
      
      hpWeightX = percentage * 20;
      jetX = 580;
      jetY = 240;
      
      for(int t=0; t<touched.length; t++){
        touched[t] = false;
      }
      
      for(int b=0; b<5; b++){
        enemyDestroy[b] = false;
      }
      
      image(end, x, y);

      //mouse action and hover on start bg
      
      if (mouseY > 300 && mouseY < 350){
        image(endHover, x, y);
        if (mousePressed){
          //click to start
          gameState = GAME_RUN; 
          enemyPart = PART1;
          
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
