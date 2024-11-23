public class Character {
  private GifPlayer gifPlayer;  // Instancia de GifPlayer para la animación
  private PApplet app;
  private float speed;  // Velocidad de movimiento
  private float velocityY;
  private float velocityX; // Nueva variable para la velocidad en X
  private boolean onGround;
  private final float gravity = 0.5; // Fuerza de la gravedad
  private final float jumpStrength = -12; // Fuerza del salto

  private boolean isInvulnerable; 
  private int invulnerabilityTimer; 
  private final int invulnerabilityDuration = 100; 
  private int blinkTimer; 
  
  private boolean isJumping; 
  private int jumpTime; 
  private final int maxJumpTime = 9; 
  
  // Variables de movimiento
  private boolean moveUp;
  private boolean moveDown;
  private boolean moveLeft;
  private boolean moveRight;
  
  private int life;
  private int blinkCount = 0;  // Contador para controlar el parpadeo
  private boolean showFirstImage = true; // Estado actual: ¿mostrar img1 o img2?
  private int blinkDuration = 60; // Duración total del parpadeo en fotogramas
  private int blinkRate = 10; // Tasa de parpadeo (en fotogramas)
  private boolean isBlinking = false; // Estado del parpadeo
  private PImage currentLifeBar; // Barra de vida actual
  private PImage previousLifeBar; // Barra de vida anterior
  
  private boolean isVibrating = false; // Estado de la vibración
  private float vibrationAmplitude = 20; // Amplitud del movimiento
  private float vibrationDuration = 1.0f; // Duración total de la vibración en segundos
  private float vibrationElapsedTime = 0; // Tiempo acumulado de vibración
  private float vibrationFrequency = 3; // Frecuencia de vibración (ciclos por segundo)
  private float originalX; // Posición X inicial para restaurar después de la vibración
  
  public Character(PApplet app, String folder, int numFrames, float x, float y, float speed, float width, float height) {
      this.app = app;
      this.gifPlayer = new GifPlayer(app, folder, numFrames, x, y, width,height);
      this.speed = speed;
      this.moveUp = false;
      this.moveDown = false;
      this.moveLeft = false;
      this.moveRight = false;
      this.velocityY = 0;
      this.velocityX = 0;
      this.onGround = false;
      this.isInvulnerable = false;
      this.invulnerabilityTimer = 0;
      this.blinkTimer = 0;
      this.life = 10;
  }

  // Método para iniciar la vibración
  public void vibrate() {
      if (!isVibrating) {
          isVibrating = true;
          vibrationElapsedTime = 0; // Reiniciar el tiempo acumulado
          originalX = gifPlayer.getX(); // Guardar la posición original
      }
  }
  
  // Método para actualizar la vibración (llamar dentro de `move` o `display`)
  private void updateVibration(PApplet app) {
      if (isVibrating) {
          // Incrementa el tiempo acumulado
          vibrationElapsedTime += 1.0 / app.frameRate;
  
          // Calcula el desplazamiento sinusoidal
          float offsetX = (float) Math.sin(vibrationElapsedTime * vibrationFrequency * PConstants.TWO_PI) * vibrationAmplitude;
  
          // Ajusta la posición temporal del personaje
          gifPlayer.setX(originalX + offsetX);
  
          // Detén la vibración al finalizar la duración
          if (vibrationElapsedTime >= vibrationDuration) {
              gifPlayer.setX(originalX); // Restaurar la posición original
              isVibrating = false;
          }
      }
  }
  
  //INVULNERABILIDAD
  public void updateInvulnerability() {
    if (isInvulnerable) {
      invulnerabilityTimer++;
      blinkTimer++;

      // Finalizar el periodo de inmunidad
      if (invulnerabilityTimer > invulnerabilityDuration) {
          isInvulnerable = false;
          invulnerabilityTimer = 0;
      }
    }
  }
  
  // Método para controlar el movimiento
  public void move(PApplet app, int index) {
      if (moveLeft) {
        velocityX = -speed; // Movimiento hacia la izquierda
      } else if (moveRight) {
          velocityX = speed; // Movimiento hacia la derecha
      } else {
          velocityX = 0; // Detener el movimiento horizontal
      }
      
      gifPlayer.setX(gifPlayer.getX() + velocityX); // Aplica el movimiento en el eje X
      
      // Gravedad
      if (!onGround) {
        velocityY += gravity;  // La gravedad va aumentando la velocidad hacia abajo
        gifPlayer.setY(gifPlayer.getY() + velocityY);  // Mueve al character hacia abajo
      } else {
        velocityY = 0;  // Resetea la velocidad Y cuando está en el suelo
      }
      
      // Salto variable
      if (moveUp && onGround && !isJumping) {
        velocityY = jumpStrength; 
        isJumping = true; 
        jumpTime = 0; 
        onGround = false;  
      } else if (moveUp && isJumping && jumpTime < maxJumpTime) {
        velocityY -= gravity; // Reduce la velocidad hacia abajo mientras mantienes el salto
        jumpTime++; 
      }
      
      if (!moveUp && isJumping) {
        isJumping = false; // Finaliza el salto si se suelta la tecla
      }
      
      // PLATAFORMAS
      if (CollisionDetector.isColliding(index, mainCharacter, (SimpleList)game.getPlatforms(), backgroundOffset)) {
        onGround = true;
        isJumping = false;
      } else {
        onGround = false;
      }
      
      // PINCHOS
      if(!isInvulnerable){
        if (CollisionDetector.isCollidingWithSpikes(index, mainCharacter, (SimpleList)game.getSpikes(), backgroundOffset)) {
          mainCharacter.setLife(mainCharacter.getLife() - 1);
          velocityY = -20;
          isInvulnerable = true;
          blinkTimer = 0;
        }
      }
      updateInvulnerability(); // Actualizar estado de inmunidad
      
      // Detener el character por colisión lateral
      for (Node node = game.getPlatforms().PTR; node != null; node = node.next) {
        Platform platform = (Platform) node.info;
        if(platform.getIndex() == index){
            CollisionDetector.handleSideCollision(this, platform, backgroundOffset);
        }
      }
      
      // Salto
      if (moveUp && onGround) {
        velocityY = jumpStrength;
        onGround = false;  
      }
      
      constrainBorders(app);
  }
  
  // Método para mostrar el GIF en la screen
  public void display(PApplet app) {
    updateVibration(app); // Actualizar la vibración si está activa
    if (isInvulnerable && (blinkTimer / 5) % 2 == 0) {
        // Parpadeo: no mostrar el personaje
        return;
    }
    gifPlayer.display(app); // Mostrar el GIF del personaje
  }
  
  public void enemyDisplay(PApplet app, int xpos, int ypos){
      gifPlayer.enemyDisplay(app, xpos, ypos); 
  }
  
  public void constrainBorders(PApplet app){
    // Limitar la posición del character a los límites de la screen
        if (gifPlayer.getX() < 340) {
            gifPlayer.setX(340);
        }
        if (gifPlayer.getX() + gifPlayer.getWidth() > app.width - 450) {
            gifPlayer.setX(app.width - gifPlayer.getWidth() - 450);
        }
        if (gifPlayer.getY() < 0) {
            gifPlayer.setY(0);
        }
        if (gifPlayer.getY() + gifPlayer.getHeight() > app.height) {
            gifPlayer.setY(app.height - gifPlayer.getHeight());
        }
  }
  
  public void updateLifeBar(PApplet app) {
    if (isBlinking) {
        handleBlink(app); // Control del parpadeo
    } else {
        // Dibujar la barra de vida correspondiente
        switch (this.life) {
            case 10:
                app.image(lifeBar10, 50, 60);
                break;
            case 9:
                app.image(lifeBar9, 50, 60);
                break;
            case 8:
                app.image(lifeBar8, 50, 60);
                break;
            case 7:
                app.image(lifeBar7, 50, 60);
                break;
            case 6:
                app.image(lifeBar6, 50, 60);
                break;
            case 5:
                app.image(lifeBar5, 50, 60);
                break;
            case 4:
                app.image(lifeBar4, 50, 60);
                break;
            case 3:
                app.image(lifeBar3, 50, 60);
                break;
            case 2:
                app.image(lifeBar2, 50, 60);
                break;
            case 1:
                app.image(lifeBar1, 50, 60);
                break;
            case 0:
                app.image(lifeBar0, 50, 60);
                break;
          }
      }
  }
  
  // Método para manejar el parpadeo
  private void handleBlink(PApplet app) {
      if (blinkCount < blinkDuration) {
          if (app.frameCount % blinkRate == 0) {
              showFirstImage = !showFirstImage; // Alternar entre la barra actual y la anterior
          }
          blinkCount++;
      } else {
          isBlinking = false; // Detener el parpadeo
      }
  
      // Dibujar la imagen correspondiente
      if (showFirstImage) {
          app.image(currentLifeBar, 50, 60);
      } else {
          app.image(previousLifeBar, 50, 60);
      }
  }
  
  // Método para iniciar el parpadeo al cambiar la vida
  public void setLife(int newLife) {
      if (this.life != newLife) {
          // Establecer la barra de vida actual y la anterior
          previousLifeBar = getLifeBar(this.life); // Barra de vida antes del cambio
          currentLifeBar = getLifeBar(newLife);   // Barra de vida después del cambio
  
          this.life = newLife; // Actualizar la vida
  
          // Iniciar el parpadeo
          blinkCount = 0;
          isBlinking = true;
          showFirstImage = true;
      }
  }

  // Método auxiliar para obtener la barra de vida según el estado de vida
  private PImage getLifeBar(int life) {
      switch (life) {
          case 10:
              return lifeBar10;
          case 9:
              return lifeBar9;
          case 8:
              return lifeBar8;
          case 7:
              return lifeBar7;
          case 6:
              return lifeBar6;
          case 5:
              return lifeBar5;
          case 4:
              return lifeBar4;
          case 3:
              return lifeBar3;
          case 2:
              return lifeBar2;
          case 1:
              return lifeBar1;
          case 0:
              return lifeBar0;
          default:
              return null;
      }
  }
  
  // Getters
  public float getSpeed(){
    return this.speed;
  }
  
  public float getVelocityY(){
    return this.velocityY;
  }
  
  public float getVelocityX(){
    return this.velocityX;
  } 
  
  public boolean getMoveLeft(){
    return this.moveLeft;
  }
  
  public boolean getMoveRight(){
    return this.moveRight;
  }
  
  public int getLife(){
    return this.life;
  }
  
  // Setters
  public void setMoveUp(boolean moveUp) {
    this.moveUp = moveUp;
  }
  
  public void setMoveDown(boolean moveDown) {
    this.moveDown = moveDown;
  }
  
  public void setMoveLeft(boolean moveLeft) {
    this.moveLeft = moveLeft;
  }
  
  public void setMoveRight(boolean moveRight) {
    this.moveRight = moveRight;
  }
  
  public void setOnGround(boolean onGround){
   this.onGround = onGround;
  }
  
  public void setVelocityY(float velocityY){
    this.velocityY = velocityY;
  }
  
  public void setSpeed(float speed){
    this.speed = speed;
  }
  
  public void setVelocityX(float velocityX){
    this.velocityX = velocityX;
  }
  
}
