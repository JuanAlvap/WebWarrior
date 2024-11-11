public abstract class Node {
  protected Object info;  
  protected Node next;    

  public Node(Object info) {
    this.info = info;
    this.next = null;
  }
}
