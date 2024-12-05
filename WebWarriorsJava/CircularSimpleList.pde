public class CircularSimpleList extends List {

  // Constructor de CircularSimpleList
  public CircularSimpleList() {
    super();
  }

  // Método para agregar un nodo a la lista circular
  @Override
  public void addNode(Object info) {
    Node newNode = new SimpleNode(info);
    if (this.PTR == null) {  // Si la lista está vacía
      this.PTR = newNode;
      this.FINAL = newNode;
      this.FINAL.setNext(this.PTR);  // El siguiente del último nodo apunta al primer nodo
    } else {
      this.FINAL.setNext(newNode);  // El último nodo apunta al nuevo nodo
      newNode.setNext(this.PTR);    // El nuevo nodo apunta al primer nodo
      this.FINAL = newNode;       // Actualiza el puntero al último nodo
    }
  }
}
