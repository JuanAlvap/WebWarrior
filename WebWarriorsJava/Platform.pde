class Platform{
  private float x, y;
  private float width, height; 
  private int index;
  
  public Platform(int index, float x, float y, float width, float height) {
    this.index = index;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }
    
  public void display(PApplet app){
    app.fill(255, 0, 0);  // Color rojo para las plataformas
    app.rect(x - backgroundOffset, y, width, height);
  }
  
  //getters
  public float getX(){
    return this.x;
  }
  public float getY(){
    return this.y;
  }
  public float getIndex(){
    return this.index;
  }
  public float getHeight(){
    return this.height;
  }
  public float getWidth(){
    return this.width;
  }
}
