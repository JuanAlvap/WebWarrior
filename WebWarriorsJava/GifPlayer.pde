import processing.sound.*;

public class GifPlayer {
  private SimpleList frames; // Lista de cuadros
  private PApplet app;  // Referencia al PApplet principal
  private int numFrames; // Número total de cuadros
  private int frameIndex; // Índice del cuadro actual
  private float x, y; // Posición del GIF
  private float width, height; // Dimensiones del GIF
  private int frameDelay; // Retraso entre cuadros
  private int delayCounter; // Contador de retraso de cuadros
  private float speed; // Velocidad del movimiento
  
  public GifPlayer(PApplet app, String folder, int numFrames, float x, float y, float width, float height) {
    this.app = app;  // Guardar la referencia para usar métodos de Processing
    this.frames = new SimpleList();
    this.numFrames = numFrames;
    this.frameIndex = 0;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.frameDelay = 5;
    this.delayCounter = 0;
    this.speed = 5;
  
    // Cargar los cuadros en la lista de frames
    for (int i = 0; i < this.numFrames; i++) {
        String filename = folder + i + ".png";
        PImage frame = app.loadImage(filename);
        //frame.resize((int) width, (int) height);
        this.frames.addNode(frame); // Agregar el cuadro a SimpleList
    }
  }
  
  // Método para mostrar el GIF en la screen
  public void display(PApplet app) {
      if (this.numFrames > 0) {
          PImage currentFrame = (PImage) this.frames.getNode(this.frameIndex);
          app.image(currentFrame, this.x, this.y, width, height);
      }
  
      // Lógica de avance de cuadros
      this.delayCounter++;
      if (this.delayCounter >= this.frameDelay) {
          this.frameIndex = (this.frameIndex + 1) % this.numFrames;  // Avanzar al siguiente cuadro
          this.delayCounter = 0;  // Reiniciar contador
      }
  }
  
  public void enemyDisplay(PApplet app, int xpos, int ypos){

      if (this.numFrames > 0) {
          PImage currentFrame = (PImage) this.frames.getNode(this.frameIndex);
          app.image(currentFrame, xpos - backgroundOffset, ypos, width, height);
      }
  
      // Lógica de avance de cuadros
      this.delayCounter++;
      if (this.delayCounter >= this.frameDelay) {
          this.frameIndex = (this.frameIndex + 1) % this.numFrames;  // Avanzar al siguiente cuadro
          this.delayCounter = 0;  // Reiniciar contador
      }
  }
  
  // Métodos getters y setters para la posición
  public float getX() {
      return x;
  }
  
  public void setX(float x) {
      this.x = x;
  }
  
  public float getY() {
      return y;
  }
  
  public void setY(float y) {
      this.y = y;
  }
  
  public float getWidth() {
      return width;
  }
  
  public void setWidth(float width) {
      this.width = width;
  }
  
  public float getHeight() {
      return height;
  }
  
  public void setHeight(float height) {
      this.height = height;
  }
  
  public int getNumFrames() {
      return numFrames;
  }
  
  public void setFrameDelay(int frameDelay) {
      this.frameDelay = frameDelay;
  }
  
  public float getSpeed(){
    return this.speed;
  }
}
