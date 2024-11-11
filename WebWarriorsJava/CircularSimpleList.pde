public class CircularSimpleList extends List {

  // Constructor de CircularSimpleList
  public CircularSimpleList() {
    super();
  }

  // Método para agregar un nodo a la lista circular
  @Override
  public void addNode(Object info) {
    Node newNode = new SimpleNode(info);
    if (PTR == null) {  // Si la lista está vacía
      PTR = newNode;
      FINAL = newNode;
      FINAL.next = PTR;  // El siguiente del último nodo apunta al primer nodo
    } else {
      FINAL.next = newNode;  // El último nodo apunta al nuevo nodo
      newNode.next = PTR;    // El nuevo nodo apunta al primer nodo
      FINAL = newNode;       // Actualiza el puntero al último nodo
    }
  }
}
