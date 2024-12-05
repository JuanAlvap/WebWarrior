public class CircularDoublyList extends List {

  private DoublyNode current; // Nodo actual del personaje seleccionado

  private int characterNumber;

  // Constructor de CircularDoublyLinkedList
  public CircularDoublyList() {
    super();
    this.characterNumber = 1;
    this.current = null;
  }

  // Método para agregar un nodo a la lista doblemente circular
  @Override
    public void addNode(Object info) {
    DoublyNode newNode = new DoublyNode(info);
    if (this.PTR == null) {  // Si la lista está vacía
      this.PTR = newNode;
      this.FINAL = newNode;
      this.current = newNode;
      this.FINAL.setNext(this.PTR);  // El siguiente del último nodo apunta al primero
      ((DoublyNode)this.PTR).setPrev(((DoublyNode)this.FINAL));    // El anterior del primer nodo apunta al último
    } else {
      this.FINAL.setNext(newNode);       // El último nodo apunta al nuevo nodo
      newNode.setPrev(((DoublyNode)this.FINAL));       // El nuevo nodo apunta al nodo anterior
      ((DoublyNode)this.PTR).setPrev(((DoublyNode)newNode));  // El primer nodo apunta hacia atrás al nuevo nodo
      this.FINAL = newNode;            // Actualiza el puntero al último nodo
      this.FINAL.setNext(this.PTR);           // El siguiente del último nodo apunta al primero
    }
  }

  // Método para avanzar al siguiente personaje
  public void nextCharacter() {
    if (this.current != null) {
      this.current = (DoublyNode) this.current.getNext();
      this.characterNumber += 1;
      if (this.characterNumber == 6) {
        this.characterNumber = 1;
      }
    }
  }

  // Método para retroceder al personaje anterior
  public void prevCharacter() {
    if (this.current != null) {
      this.current = (DoublyNode) this.current.getPrev();
      this.characterNumber -= 1;
      if (this.characterNumber == 0) {
        this.characterNumber = 5;
      }
    }
  }

  // Método para mostrar el personaje actual
  public void displayCharacter() {
    if (this.current != null) {
      PImage characterImage = (PImage) this.current.getInfo();
      image(characterImage, 470, 125); // Ajusta las coordenadas según sea necesario
    }
  }

  public int getCharacterNumber() {
    return characterNumber;
  }

  public int size() {
    if (this.PTR == null) return 0;
    int count = 1;
    Node current = this.PTR;
    while (current.getNext() != this.PTR) {
      count++;
      current = current.getNext();
    }
    return count;
  }
}
