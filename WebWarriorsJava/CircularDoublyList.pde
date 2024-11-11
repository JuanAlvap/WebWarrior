public class CircularDoublyList extends List {

  // Constructor de CircularDoublyLinkedList
  public CircularDoublyList() {
    super();
  }

  // Método para agregar un nodo a la lista doblemente circular
  @Override
  public void addNode(Object info) {
    DoublyNode newNode = new DoublyNode(info);
    if (PTR == null) {  // Si la lista está vacía
      PTR = newNode;
      FINAL = newNode;
      FINAL.next = PTR;  // El siguiente del último nodo apunta al primero
      ((DoublyNode)PTR).setPrev(((DoublyNode)FINAL));    // El anterior del primer nodo apunta al último
    } else {
      FINAL.next = newNode;       // El último nodo apunta al nuevo nodo
      newNode.prev = ((DoublyNode)FINAL);       // El nuevo nodo apunta al nodo anterior
      ((DoublyNode)PTR).setPrev(((DoublyNode)newNode));  // El primer nodo apunta hacia atrás al nuevo nodo
      FINAL = newNode;            // Actualiza el puntero al último nodo
      FINAL.next = PTR;           // El siguiente del último nodo apunta al primero
    }
  }
  
  public int size() {
    if (PTR == null) return 0;
    int count = 1;
    Node current = PTR;
    while (current.next != PTR) {
      count++;
      current = current.next;
    }
    return count;
  }

}
