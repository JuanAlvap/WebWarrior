public class DoublyNode extends Node {
  private DoublyNode prev;  // Puntero al nodo anterior

  public DoublyNode(Object info) {
    super(info);
    this.prev = null;
  }
  
  public Node getPrev() {
     return prev;
  }
  public void setPrev(DoublyNode prev) {
     this.prev = prev;
  }
}
