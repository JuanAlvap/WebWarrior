public class Character {
  private GifPlayer gifPlayer;  // Instancia de GifPlayer para la animación
  private float speed;  // Velocidad de movimiento
  private float velocityY;
  private float velocityX; // Nueva variable para la velocidad en X
  private boolean onGround;
  private final float gravity = 0.5; // Fuerza de la gravedad
  private final float jumpStrength = -12; // Fuerza del salto

  // Variables de movimiento
  private boolean moveUp;
  private boolean moveDown;
  private boolean moveLeft;
  private boolean moveRight;
  
  public Character(PApplet app, String folder, int numFrames, float x, float y, float speed) {
      this.gifPlayer = new GifPlayer(app, folder, numFrames, x, y);
      this.speed = speed;
      this.moveUp = false;
      this.moveDown = false;
      this.moveLeft = false;
      this.moveRight = false;
      this.velocityY = 0;
      this.velocityX = 0;
      this.onGround = false;
  }
  
  // Método para controlar el movimiento
  public void move(PApplet app) {
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
      
      if (CollisionDetector.isColliding(mainCharacter, (SimpleList)game.getPlatforms(), backgroundOffset)) {
        //gifPlayer.setY(600);  // No deja que el character pase por debajo del suelo
        onGround = true;
      } else {
        onGround = false;
      }
      
      // Detener el character por colisión lateral
      for (Node node = game.getPlatforms().PTR; node != null; node = node.next) {
        Platform platform = (Platform) node.info;
        CollisionDetector.handleSideCollision(this, platform, backgroundOffset);
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
      gifPlayer.display(app);
  }
  
  public void constrainBorders(PApplet app){
    // Limitar la posición del character a los límites de la screen
        if (gifPlayer.getX() < 0) {
            gifPlayer.setX(0);
        }
        if (gifPlayer.getX() + gifPlayer.getWidth() > app.width) {
            gifPlayer.setX(app.width - gifPlayer.getWidth());
        }
        if (gifPlayer.getY() < 0) {
            gifPlayer.setY(0);
        }
        if (gifPlayer.getY() + gifPlayer.getHeight() > app.height) {
            gifPlayer.setY(app.height - gifPlayer.getHeight());
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
