public class SimpleList extends List{

  // Constructor de SimpleList
  public SimpleList() {
    super();
  }

  // Método para agregar un nodo a la lista
  @Override
  public void addNode(Object info) {
    Node newNode = new SimpleNode(info);  // Crea un nuevo nodo
    if (this.PTR == null) {  // Si la lista está vacía
      this.PTR = newNode;
      this.FINAL = newNode;
    } else {
      this.FINAL.setNext(newNode);  // Enlaza el último nodo con el nuevo nodo
      this.FINAL = newNode;       // Actualiza el puntero al último nodo
    }
  }

  // Método para obtener un nodo por su índice
  public Object getNode(int index) {
    Node current = this.PTR;
    int i = 0;
    while (current != null) {
      if (i == index) {
        return current.getInfo();  // Devuelve la información del nodo
      }
      current = current.getNext();  // Avanza al siguiente nodo
      i++;
    }
    return null;  // Si el índice es inválido
  }
  
  // Implementación del método size
  public int size() {
    int count = 0;
    Node current = this.PTR; // Comenzamos desde el primer nodo

    // Recorremos la lista hasta llegar al FINAL
    while (current != null) {
      count++;  // Incrementamos el contador por cada nodo
      current = current.getNext();  // Avanzamos al siguiente nodo
    }

    return count;  // Retornamos el tamaño de la lista
  }
  
    // Método para obtener el índice de un nodo en la lista
  public int getIndex(Node node) {
      Node current = this.PTR; // Comienza desde el primer nodo
      int index = 0;      // Contador de índice
  
      while (current != null) {
          if (current == node) { // Comparar referencias para encontrar el nodo
              return index;
          }
          current = current.getNext(); // Avanza al siguiente nodo
          index++;
      }
      return -1; // Si el nodo no está en la lista, devuelve -1
  }
  
  public Node getPTR(){
    return this.PTR;
  }

}
