public class Character {
  private GifPlayer gifPlayer;  // Instancia de GifPlayer para la animación
  private PApplet app;
  private float speed;  // Velocidad de movimiento
  private float velocityY;
  private float velocityX; // Nueva variable para la velocidad en X
  private boolean onGround;
  private final float gravity; // Fuerza de la gravedad
  private final float jumpStrength; // Fuerza del salto

  private boolean isInvulnerable; 
  private int invulnerabilityTimer; 
  private final int invulnerabilityDuration; 
  private int blinkTimer; 
  
  private boolean isJumping; 
  private int jumpTime; 
  private final int maxJumpTime; 
  
  // Variables de movimiento
  private boolean moveUp;
  private boolean moveLeft;
  private boolean moveRight;
  
  private int life;
  private int blinkCount;  // Contador para controlar el parpadeo
  private boolean showFirstImage; // Estado actual: ¿mostrar img1 o img2?
  private int blinkDuration; // Duración total del parpadeo en fotogramas
  private int blinkRate; // Tasa de parpadeo (en fotogramas)
  private boolean isBlinking; // Estado del parpadeo
  private PImage currentLifeBar; // Barra de vida actual
  private PImage previousLifeBar; // Barra de vida anterior
  
  private boolean isVibrating; // Estado de la vibración
  private float vibrationAmplitude; // Amplitud del movimiento
  private float vibrationDuration; // Duración total de la vibración en segundos
  private float vibrationElapsedTime; // Tiempo acumulado de vibración
  private float vibrationFrequency; // Frecuencia de vibración (ciclos por segundo)
  private float originalX; // Posición X inicial para restaurar después de la vibración
  
  public Character(PApplet app, String folder, int numFrames, float x, float y, float speed, float width, float height) {
      this.app = app;
      this.gifPlayer = new GifPlayer(app, folder, numFrames, x, y, width,height);
      this.speed = speed;
      this.moveUp = false;
      this.moveLeft = false;
      this.moveRight = false;
      this.velocityY = 0;
      this.velocityX = 0;
      this.onGround = false;
      this.isInvulnerable = false;
      this.invulnerabilityTimer = 0;
      this.blinkTimer = 0;
      this.life = 10;
      this.gravity = 0.5;
      this.jumpStrength = -12;
      this.invulnerabilityDuration = 100;
      this.maxJumpTime = 9;
      this.showFirstImage = true;
      this.isBlinking = false;
      this.blinkCount = 0;
      this.blinkDuration = 60;
      this.blinkRate = 10;
      this.isVibrating = false;
      this.vibrationAmplitude = 20;
      this.vibrationDuration = 1.0f;
      this.vibrationElapsedTime = 0;
      this.vibrationFrequency = 3;
  }

  // Método para iniciar la vibración
  public void vibrate() {
      if (!this.isVibrating) {
          this.isVibrating = true;
          this.vibrationElapsedTime = 0; // Reiniciar el tiempo acumulado
          this.originalX = this.gifPlayer.getX(); // Guardar la posición original
      }
  }
  
  // Método para actualizar la vibración (llamar dentro de `move` o `display`)
  private void updateVibration(PApplet app) {
      if (this.isVibrating) {
          // Incrementa el tiempo acumulado
          this.vibrationElapsedTime += 1.0 / app.frameRate;
  
          // Calcula el desplazamiento sinusoidal
          float offsetX = (float) Math.sin(this.vibrationElapsedTime * this.vibrationFrequency * PConstants.TWO_PI) * this.vibrationAmplitude;
  
          // Ajusta la posición temporal del personaje
          this.gifPlayer.setX(this.originalX + offsetX);
  
          // Detén la vibración al finalizar la duración
          if (this.vibrationElapsedTime >= this.vibrationDuration) {
              this.gifPlayer.setX(this.originalX); // Restaurar la posición original
              this.isVibrating = false;
          }
      }
  }
  
  //INVULNERABILIDAD
  public void updateInvulnerability() {
    if (this.isInvulnerable) {
      this.invulnerabilityTimer++;
      this.blinkTimer++;

      // Finalizar el periodo de inmunidad
      if (this.invulnerabilityTimer > this.invulnerabilityDuration) {
          this.isInvulnerable = false;
          this.invulnerabilityTimer = 0;
      }
    }
  }
  
  // Método para controlar el movimiento
  public void move(PApplet app, int index) {
      if (this.moveLeft) {
        this.velocityX = -this.speed; // Movimiento hacia la izquierda
      } else if (this.moveRight) {
          this.velocityX = this.speed; // Movimiento hacia la derecha
      } else {
          this.velocityX = 0; // Detener el movimiento horizontal
      }
      
      this.gifPlayer.setX(this.gifPlayer.getX() + this.velocityX); // Aplica el movimiento en el eje X
      
      // Gravedad
      if (!this.onGround) {
        this.velocityY += this.gravity;  // La gravedad va aumentando la velocidad hacia abajo
        this.gifPlayer.setY(this.gifPlayer.getY() + this.velocityY);  // Mueve al character hacia abajo
      } else {
        this.velocityY = 0;  // Resetea la velocidad Y cuando está en el suelo
      }
      
      // Salto variable
      if (this.moveUp && this.onGround && !this.isJumping) {
        this.velocityY = this.jumpStrength; 
        this.isJumping = true; 
        this.jumpTime = 0; 
        this.onGround = false;  
        game.playJumpSound();
      } else if (this.moveUp && this.isJumping && this.jumpTime < this.maxJumpTime) {
        this.velocityY -= this.gravity; // Reduce la velocidad hacia abajo mientras mantienes el salto
        this.jumpTime++; 
      }
      
      if (!this.moveUp && this.isJumping) {
        this.isJumping = false; // Finaliza el salto si se suelta la tecla
      }
      
      // PLATAFORMAS
      if (CollisionDetector.isColliding(index, mainCharacter, (SimpleList)game.getPlatforms(), backgroundOffset)) {
        this.onGround = true;
        this.isJumping = false;
      } else {
        this.onGround = false;
      }
      
      // PINCHOS
      if(!this.isInvulnerable){
        if (CollisionDetector.isCollidingWithSpikes(index, mainCharacter, (SimpleList)game.getSpikes(), backgroundOffset)) {
          mainCharacter.setLife(mainCharacter.getLife() - 1);
          this.velocityY = -20;
          this.isInvulnerable = true;
          this.blinkTimer = 0;
          game.playSpikeHitSound();
        }
      }
      updateInvulnerability(); // Actualizar estado de inmunidad
      
      // Detener el character por colisión lateral
      for (Node node = game.getPlatforms().getPTR(); node != null; node = node.getNext()) {
        Platform platform = (Platform) node.getInfo();
        if(platform.getIndex() == index){
            CollisionDetector.handleSideCollision(this, platform, backgroundOffset);
        }
      }
      
      constrainBorders(app);
  }
  
  // Método para mostrar el GIF en la screen
  public void display(PApplet app) {
    this.updateVibration(app); // Actualizar la vibración si está activa
    if (this.isInvulnerable && (this.blinkTimer / 5) % 2 == 0) {
        // Parpadeo: no mostrar el personaje
        return;
    }
    this.gifPlayer.display(app); // Mostrar el GIF del personaje
  }
  
  public void enemyDisplay(PApplet app, int xpos, int ypos){
      this.gifPlayer.enemyDisplay(app, xpos, ypos); 
  }
  
  public void constrainBorders(PApplet app){
    // Limitar la posición del character a los límites de la screen
        if (this.gifPlayer.getX() < 340) {
            this.gifPlayer.setX(340);
        }
        if (this.gifPlayer.getX() + this.gifPlayer.getWidth() > app.width - 450) {
            this.gifPlayer.setX(app.width - this.gifPlayer.getWidth() - 450);
        }
        if (this.gifPlayer.getY() < 0) {
            this.gifPlayer.setY(0);
        }
        if (this.gifPlayer.getY() + this.gifPlayer.getHeight() > app.height) {
            this.gifPlayer.setY(app.height - this.gifPlayer.getHeight());
        }
  }
  
  public void updateLifeBar(PApplet app) {
    if (this.isBlinking) {
        this.handleBlink(app); // Control del parpadeo
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
      if (this.blinkCount < this.blinkDuration) {
          if (app.frameCount % this.blinkRate == 0) {
              this.showFirstImage = !this.showFirstImage; // Alternar entre la barra actual y la anterior
          }
          this.blinkCount++;
      } else {
          this.isBlinking = false; // Detener el parpadeo
      }
  
      // Dibujar la imagen correspondiente
      if (this.showFirstImage) {
          app.image(this.currentLifeBar, 50, 60);
      } else {
          app.image(this.previousLifeBar, 50, 60);
      }
  }
  
  // Método para iniciar el parpadeo al cambiar la vida
  public void setLife(int newLife) {
      if (this.life != newLife) {
          // Establecer la barra de vida actual y la anterior
          this.previousLifeBar = getLifeBar(this.life); // Barra de vida antes del cambio
          this.currentLifeBar = getLifeBar(newLife);   // Barra de vida después del cambio
  
          this.life = newLife; // Actualizar la vida
  
          // Iniciar el parpadeo
          this.blinkCount = 0;
          this.isBlinking = true;
          this.showFirstImage = true;
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
  
  public GifPlayer getGifPlayer(){
    return this.gifPlayer;
  }
  
  // Setters
  public void setMoveUp(boolean moveUp) {
    this.moveUp = moveUp;
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
