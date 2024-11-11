public class DoublyList extends List {
  private DoublyNode current; // Nodo actual del personaje seleccionado

  // Constructor
  public DoublyList() {
    super();
    this.current = null;
  }

  // Método para agregar un personaje (imagen) a la lista
  @Override
  public void addNode(Object info) {
    DoublyNode newNode = new DoublyNode(info);
    if (PTR == null) {  // Si la lista está vacía
      PTR = newNode;
      FINAL = newNode;
      current = newNode;
    } else {
      FINAL.next = newNode;           // El último nodo apunta al nuevo nodo
      newNode.setPrev((DoublyNode) FINAL);  // El nuevo nodo apunta al anterior
      FINAL = newNode;                // Actualiza el último nodo
    }
    // Hacer la lista circular
    FINAL.next = PTR;
    ((DoublyNode) PTR).setPrev((DoublyNode) FINAL);
  }

  // Método para avanzar al siguiente personaje
  public void nextCharacter() {
    if (current != null) {
      current = (DoublyNode) current.next;
    }
  }

  // Método para retroceder al personaje anterior
  public void prevCharacter() {
    if (current != null) {
      current = (DoublyNode) current.getPrev();
    }
  }

  // Método para mostrar el personaje actual
  public void displayCharacter() {
    if (current != null) {
      PImage characterImage = (PImage) current.info;
      image(characterImage, 470, 125); // Ajusta las coordenadas según sea necesario
    }
  }
}
