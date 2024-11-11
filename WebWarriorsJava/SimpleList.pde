public class SimpleList extends List{

  // Constructor de SimpleList
  public SimpleList() {
    super();
  }

  // Método para agregar un nodo a la lista
  @Override
  public void addNode(Object info) {
    Node newNode = new SimpleNode(info);  // Crea un nuevo nodo
    if (PTR == null) {  // Si la lista está vacía
      PTR = newNode;
      FINAL = newNode;
    } else {
      FINAL.next = newNode;  // Enlaza el último nodo con el nuevo nodo
      FINAL = newNode;       // Actualiza el puntero al último nodo
    }
  }

  // Método para obtener un nodo por su índice
  public Object getNode(int index) {
    Node current = PTR;
    int i = 0;
    while (current != null) {
      if (i == index) {
        return current.info;  // Devuelve la información del nodo
      }
      current = current.next;  // Avanza al siguiente nodo
      i++;
    }
    return null;  // Si el índice es inválido
  }
  
  // Implementación del método size
  public int size() {
    int count = 0;
    Node current = PTR; // Comenzamos desde el primer nodo

    // Recorremos la lista hasta llegar al FINAL
    while (current != null) {
      count++;  // Incrementamos el contador por cada nodo
      current = current.next;  // Avanzamos al siguiente nodo
    }

    return count;  // Retornamos el tamaño de la lista
  }
}
