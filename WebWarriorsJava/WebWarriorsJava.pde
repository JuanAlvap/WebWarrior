import processing.sound.*;
WebWarriors game;
PImage backgroundImage;
PImage character, combate, youWon, youLose, next, textBox;
Character mainCharacter, enemy1, battleCharacter;
GifPlayer gifPlayer;
boolean showYouWon = false, showYouLose = false;
int startTime, finishTime;
float backgroundOffset = 0; // Ancho total de la imagen de principalPage
float backgroundWidth = 8000; // Ancho total de la imagen de principalPage
PFont mouse = null;

boolean booleanBattle1 = false, booleanBattle2 = false, booleanBattle3 = false;
SimpleList battle1Texts, battle1xPositions, battle1yPositions, comments;
Battle battle1, battle2;

//JUANCHO STUFF
PImage principalPage, selectYourCharacter, howToPlay, credits, setting, characterVariable1, characterVariable2, characterVariable3, characterVariable4, characterVariable5, ok, start, okn, mapa = null;
int screen = 0, characterVariable = 1;
boolean oke = false;
boolean map1, map2, map3 =false;
DoublyList characterSelector;

void setup(){
  mouse = createFont("PressStart2P.ttf", 20);
  size(1500, 720);
  backgroundImage = loadImage("FONDO MAPA VIDEOJUEGO.png");
  combate = loadImage("Combate.png");
  combate.resize(1500, 720);
  youWon = loadImage("you won.png");
  youWon.resize(width, height);
  youLose = loadImage("you won.png");
  youLose.resize(width, height);
  next = loadImage("next.png");
  textBox = loadImage("textBox.png");
  
  principalPage = loadImage("Start.png");
  selectYourCharacter = loadImage("SelectYourCharacter.png");
  howToPlay = loadImage("How To Play.png");
  credits = loadImage("Credits.png");
  setting = loadImage("Settings.png");
  ok = loadImage("Ok.png");
  start = loadImage("Start.png");
  okn = loadImage("Okselect.png");
  mapa = loadImage("Mapa.png");
  
  game = new WebWarriors(this);
  game.addSong("music1.mp3");
  game.addSong("music2.mp3");
  
  //Plataformas
  game.addPlatform(new Platform(0, 625, 465, 15));
  game.addPlatform(new Platform(465, 560, 168, 15));
  game.addPlatform(new Platform(633, 484, 353, 15));
  game.addPlatform(new Platform(986, 562, 166, 15));
  game.addPlatform(new Platform(1154, 625, 1713, 15));
  game.addPlatform(new Platform(1740, 500, 350, 15));
  game.addPlatform(new Platform(2195, 370, 350, 15));
  game.addPlatform(new Platform(2867, 565, 125, 15));
  game.addPlatform(new Platform(2993, 492, 688, 55));
  game.addPlatform(new Platform(3680, 630, 220, 15));
  game.addPlatform(new Platform(3900, 545, 352, 15));
  game.addPlatform(new Platform(4252, 630, 910, 15));
  game.addPlatform(new Platform(5162, 580, 168, 15));
  game.addPlatform(new Platform(5332, 500, 355, 15));
  game.addPlatform(new Platform(5685, 575, 166, 15));
  game.addPlatform(new Platform(5852, 627, 1240, 15));
  game.addPlatform(new Platform(6074, 472, 352, 15));
  game.addPlatform(new Platform(6527, 355, 352, 15));
  game.addPlatform(new Platform(7096, 560, 126, 15));
  game.addPlatform(new Platform(7223, 488, 688, 55));
  
  mainCharacter = new Character(this, "F", 5, 0, 0, 5);
  
  battleCharacter = new Character(this, "B", 10, 200, 300, 5);
  enemy1 = new Character(this, "A", 10, 1000, 0, 5);
  
  battle1xPositions = new SimpleList();
  battle1xPositions.addNode(545);
  battle1xPositions.addNode(1000);
  battle1xPositions.addNode(545);
  battle1xPositions.addNode(1000);
  battle1xPositions.addNode(50);
  
  battle1yPositions = new SimpleList();
  battle1yPositions.addNode(537);
  battle1yPositions.addNode(537);
  battle1yPositions.addNode(630);
  battle1yPositions.addNode(630);
  battle1yPositions.addNode(537);
  
  // Crear listas de texto y posiciones para las batallas
  battle1Texts = new SimpleList();
  battle1Texts.addNode("1");
  battle1Texts.addNode("2");
  battle1Texts.addNode("3");
  battle1Texts.addNode("4");
  battle1Texts.addNode("");
  
  comments = new SimpleList();
  comments.addNode("buenos dias\ncomo estas\ncomo te llamas");
  comments.addNode("me gusta la papaaaaa");
  comments.addNode("3");
  comments.addNode("4");
  comments.addNode("5");
  
  // Crear batallas
  battle1 = new Battle(this, battle1Texts, battle1xPositions, battle1yPositions, game, comments);
  battle2 = new Battle(this, battle1Texts, battle1xPositions, battle1yPositions, game, comments); // Puedes personalizar otra batalla
  
  // Agregar batallas a WebWarriors
  game.addBattle(battle1);
  game.addBattle(battle2);
  
  characterSelector = new DoublyList();
  characterSelector.addNode(loadImage("SelPersonaje1.png"));
  characterSelector.addNode(loadImage("SelPersonaje2.png"));
  characterSelector.addNode(loadImage("SelPersonaje3.png"));
  characterSelector.addNode(loadImage("SelPersonaje4.png"));
  characterSelector.addNode(loadImage("SelPersonaje5.png"));
  
}

void draw(){
  
  background(0);
  if (screen == 0) {
    image(principalPage, 0, 0, width, height);
  } else if (screen == 1) {
    image(selectYourCharacter, 0, 0, width, height);
    if (!oke) {
      image(ok, (750-55), 600);
    } else {
      image(okn, (750-55), 600);
    }

    characterSelector.displayCharacter();
    
  } else if (screen == 2) {
    image(credits, 0, 0, width, height);
  } else if (screen == 3) {
    image(howToPlay, 0, 0, width, height);
  } else if (screen == 4) {
    image(setting, 0, 0, width, height);
  } else if (screen == 5) {
    image(mapa, 0, 0, width, height);
    if(map1){
        image(backgroundImage, -backgroundOffset, 0);
        //BATALLAS EN JUEGO
        if (game.isBattleActive()) {
          game.updateBattle();
          battleCharacter.display(this);
          enemy1.display(this);
        } else if(showYouWon){
          finishTime = millis() - startTime;
          if (finishTime < 5000) {
            image(youWon, 0, 0); // Muestra la imagen en (100, 100)
          } else {
            showYouWon = false; // Deja de mostrar la imagen después de 5 segundos
          }
        }else if(showYouLose){
          finishTime = millis() - startTime;
          if (finishTime < 5000) {
            image(youLose, 0, 0); // Muestra la imagen en (100, 100)
          } else {
            showYouLose = false; // Deja de mostrar la imagen después de 5 segundos
          }
        }else{
          //JUEGO PLATAFORMAS
          mainCharacter.move(this);
          mainCharacter.display(this);
          moveBackground();
          
          // Mostrar plataformas
          Node platformNode = game.getPlatforms().PTR;
          while (platformNode != null) {
            Platform platform = (Platform) platformNode.info;
            platform.display(this);
            platformNode = platformNode.next;
          }
          
          // Verificar colisión con plataformas
          if (CollisionDetector.isColliding(mainCharacter, (SimpleList)game.getPlatforms(), backgroundOffset)) {
            mainCharacter.setOnGround(true);
          } else {
            mainCharacter.setOnGround(false);
          }
          
          //CONTROL DE BATALLAS
          if(mainCharacter.gifPlayer.getX() + mainCharacter.gifPlayer.getWidth() + backgroundOffset >= 4036 && !booleanBattle1){
            print("llegue");
            game.setActiveBattle(0); // Comienza con la primera batalla
            game.startBattle();
            booleanBattle1 = true;
          }else if(mainCharacter.gifPlayer.getX() + mainCharacter.gifPlayer.getWidth() + backgroundOffset >= 5000 && !booleanBattle2){
            print("llegue");
            game.nextBattle();
            booleanBattle2 = true;
          }else if(mainCharacter.gifPlayer.getX() + mainCharacter.gifPlayer.getWidth() + backgroundOffset >= 7000 && !booleanBattle3){
            print("llegue");
            game.nextBattle();
            booleanBattle3 = true;
          }
          text("Press T for next battle", 50, 100);
        }
    }else if(map2){
      print("map2");
      image(howToPlay, 0, 0, width, height);
    }else if(map3){
      print("map3");
      image(credits, 0, 0, width, height);
    }
  }
  
  textFont(mouse);
  text("mouseX "+ mouseX + " mouseY " + mouseY + " offsetX" + backgroundOffset + " Total" + (int(mouseX) + backgroundOffset), 20, 20);
}

void mousePressed() {
  
  float dx1 = 922, dy1 = 297, ix1 = 560, iy1 = 297;
  float dx2 = 974, dy2 = 358, ix2 = 509, iy2 = 358;
  float dx3 = 922, dy3 = 410, ix3 = 560, iy3 = 410;

  if (screen == 0) {
    if (mouseX>78 && mouseX<583 && mouseY>300 && mouseY<352) {
      screen = 1;
    } else if (mouseX>154 && mouseX<507 && mouseY>418 && mouseY<468) {
      screen = 2;
    } else if (mouseX>869 && mouseX<1426 && mouseY>356 && mouseY<412) {
      screen = 3;
    } else if (mouseX>945 && mouseX<1350 && mouseY>480 && mouseY<538) {
      screen = 4;
    }
  } else if (screen == 1) {
    if (isPointInTriangle(mouseX, mouseY, dx1, dy1, dx2, dy2, dx3, dy3)) {
      characterSelector.nextCharacter();
    } else if (isPointInTriangle(mouseX, mouseY, ix1, iy1, ix2, iy2, ix3, iy3)) {
      characterSelector.prevCharacter();
    } else if (mouseX > 20 && mouseX < 141 && mouseY > 29 && mouseY < 49) {
      screen = 0;
    } else if (mouseX > 694 && mouseX <792 && mouseY >600 && mouseY <650) {
      screen = 5;
    }
  } else if(screen == 5 && !game.isBattleActive()){
      if(mouseX>290 && mouseX<378 && mouseY>509 && mouseY<556){
        map1 = true;
        map2 = false;
        map3 = false;
      }else if(mouseX>1141 && mouseX<1245 && mouseY>637 && mouseY<692){
        map1 = false;
        map2 = true;
        map3 = false;
      }else if(mouseX>718 && mouseX<839 && mouseY>623 && mouseY<688){
        map1 = false;
        map2 = false;
        map3 = true;
      }
  } else if (screen == 2 || screen == 3 || screen == 4) {
    if (mouseX > 20 && mouseX < 141 && mouseY > 29 && mouseY < 49) {
      screen = 0;
    }
  }
  
  if (game.isBattleActive()) {
    game.mousePressed();
  }
}

// Control de movimiento
void keyPressed() {
  // Activar las variables de movimiento al presionar teclas
  if (key == ' ' || key == 'W') {
    mainCharacter.setMoveUp(true);
  }
  if (key == 's' || key == 'S') {
    mainCharacter.setMoveDown(true);
  }
  if (key == 'a' || key == 'A') {
    mainCharacter.setMoveLeft(true);
  }
  if (key == 'd' || key == 'D') {
    mainCharacter.setMoveRight(true);
  }
  if (key == 'n') {  // Siguiente canción
    game.nextSong();
  } else if (key == 'p') {  // Canción anterior
    game.previousSong();
  }
}

void keyReleased() {
  // Desactivar las variables de movimiento al soltar teclas
  if (key == ' ' || key == 'W') {
    mainCharacter.setMoveUp(false);
  }
  if (key == 's' || key == 'S') {
    mainCharacter.setMoveDown(false);
  }
  if (key == 'a' || key == 'A') {
    mainCharacter.setMoveLeft(false);
  }
  if (key == 'd' || key == 'D') {
    mainCharacter.setMoveRight(false);
  }
}

void moveBackground(){
  if (mainCharacter.gifPlayer.getX() > width - 150 && backgroundOffset < backgroundWidth - width) {
    if (mainCharacter.getMoveRight()) {
      backgroundOffset += mainCharacter.getSpeed(); // Desplazar el principalPage a la derecha
    }  
  }
  if (mainCharacter.gifPlayer.getX() < 150 && backgroundOffset > 0) {
    if (mainCharacter.getMoveLeft()) {
      backgroundOffset -= mainCharacter.getSpeed(); // Desplazar el principalPage a la izquierda
    }  
  }
}

void mouseMoved() {
  if (mouseX > 694 && mouseX <792 && mouseY >600 && mouseY <650) {
    oke=true;
  } else {
    oke = false;
  }
}

boolean isPointInTriangle(float px, float py, float x1, float y1, float x2, float y2, float x3, float y3) {
  float areaOrig = abs((x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1));
  float area1 = abs((x1 - px) * (y2 - py) - (x2 - px) * (y1 - py));
  float area2 = abs((x2 - px) * (y3 - py) - (x3 - px) * (y2 - py));
  float area3 = abs((x3 - px) * (y1 - py) - (x1 - px) * (y3 - py));

  return abs(area1 + area2 + area3 - areaOrig) < 1.0;
}
