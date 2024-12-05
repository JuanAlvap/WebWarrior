public abstract class Node {
  protected Object info;  
  protected Node next;    

  public Node(Object info) {
    this.info = info;
    this.next = null;
  }
  
  public Object getInfo(){
    return this.info;
  }
  
  public Node getNext(){
    return this.next;
  }
  
  public void setNext(Node next){
    this.next = next;
  }
}
