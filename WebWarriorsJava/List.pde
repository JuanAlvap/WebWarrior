public abstract class List {
  protected Node PTR;
  protected Node FINAL;
  
  public List() {
    this.PTR = null;
    this.FINAL = null;
  }
  
  protected abstract void addNode(Object info);
}
