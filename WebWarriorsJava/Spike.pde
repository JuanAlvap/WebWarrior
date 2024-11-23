public class Spike {
  private int index; 
  private float x, y, width, height;

  public Spike(int index, float x, float y, float width, float height) {
    this.index = index;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  public void display(PApplet app){
    // Dibuja el rectángulo que representa la hitbox
    app.noFill();
    app.stroke(255, 0, 0); // Rojo para la hitbox
    app.strokeWeight(2);  // Grosor del borde
    app.rect(x - backgroundOffset, y, width, height);
  }

  public int getIndex() {
    return index;
  }

  public float getX() {
    return x;
  }

  public float getY() {
    return y;
  }

  public float getWidth() {
    return width;
  }

  public float getHeight() {
    return height;
  }
}
