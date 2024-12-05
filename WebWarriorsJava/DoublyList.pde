public class DoublyList extends List {

  // Constructor
  public DoublyList() {
    super();
  }

  // Método para agregar un personaje (imagen) a la lista
  @Override
  public void addNode(Object info) {
    DoublyNode newNode = new DoublyNode(info);
    if (this.PTR == null) {  // Si la lista está vacía
      this.PTR = newNode;
      this.FINAL = newNode;
    } else {
      this.FINAL.setNext(newNode);           // El último nodo apunta al nuevo nodo
      newNode.setPrev((DoublyNode) this.FINAL);  // El nuevo nodo apunta al anterior
      this.FINAL = newNode;                // Actualiza el último nodo
    }
  }
  
}
