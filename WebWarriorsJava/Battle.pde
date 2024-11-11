public class Battle {
    private boolean isPlayerTurn;
    private boolean inBattle;
    private int playerHealth;
    private int enemyHealth;
    private PApplet app;

    private SimpleList squareTexts;  // Lista de textos
    private SimpleList squareX;      // Lista de posiciones X
    private SimpleList squareY;      // Lista de posiciones Y
    private SimpleList comments;      // Lista de posiciones Y
    private int squareSize;     // Tamaño de los cuadrados

    private int enemyTurnStartTime; // Variable para marcar el inicio del turno enemigo
    private boolean printNext;
    private int selectedAction; // Variable para almacenar la acción seleccionada
    private int round; // Contador de rondas
    private String damageMessage; // Mensaje de daño que se muestra al jugador
    private String enemyDamageMessage; // Mensaje de daño del enemigo

    // Daño que los botones causan en cada ronda
    private int[][] damageMatrix = {
        {2, 3, 4, 0}, // Daños para ronda 1
        {1, 4, 3, 2}, // Daños para ronda 2
        {3, 2, 1, 4}, // Daños para ronda 3
        {4, 0, 2, 3}, // Daños para ronda 4
        {2, 3, 1, 0}  // Daños para ronda 5
    };
    
    private int currentCommentIndex; // Índice del comentario actual
    private int letterCount;         // Contador de letras mostradas
    private int lastUpdate;          // Tiempo del último incremento de letra
    private int displaySpeed;      // Tiempo entre letras (milisegundos)
    
    private WebWarriors game; // Referencia a WebWarriors

    public Battle(PApplet app, SimpleList texts, SimpleList xPositions, SimpleList yPositions, WebWarriors game, SimpleList comments) {
        this.app = app;
        this.squareTexts = texts;
        this.squareX = xPositions;
        this.squareY = yPositions;
        this.game = game; // Guardar la referencia
        this.comments = comments;
        this.displaySpeed = 100;
        this.lastUpdate = 0;
        this.letterCount = 0;
        this.currentCommentIndex = 0;
        this.enemyDamageMessage = "";
        this.damageMessage = "";
        this.enemyTurnStartTime = 0;
        this.squareSize = 80;
    }

    public void start() {
        isPlayerTurn = true;
        inBattle = true;
        playerHealth = 10;
        enemyHealth = 10;
        selectedAction = 0; // Resetear la acción seleccionada al inicio de cada batalla
        round = 0; // Resetear las rondas
        damageMessage = ""; // Resetear mensaje de daño
        enemyDamageMessage = ""; // Resetear mensaje de daño del enemigo
        printNext = false;
    }

    public void displayStatus() {
        app.fill(0);
        app.text("Player Health: " + playerHealth, 50, 100);
        app.text("Enemy Health: " + enemyHealth, 50, 120);
    }

    public void displaySquares() {
        if (inBattle) {
            Node textNode = squareTexts.PTR;  // Recorrer la lista de textos
            Node xNode = squareX.PTR;         // Recorrer la lista de posiciones X
            Node yNode = squareY.PTR;         // Recorrer la lista de posiciones Y
            int pos = 0;
            while (textNode != null) {
                pos++;
                // Dibuja los cuadrados con bordes redondeados
                app.fill(255);
                if (pos == 5) {
                    app.rect((Integer) xNode.info, (Integer) yNode.info, squareSize + 350, squareSize + 80, 20);
                } else {
                    app.rect((Integer) xNode.info, (Integer) yNode.info, squareSize + 350, squareSize, 20);
                }

                // Dibuja el texto dentro de los cuadrados
                app.fill(0); // Color de texto blanco
                app.text((String) textNode.info, (Integer) xNode.info + squareSize / 2, (Integer) yNode.info + squareSize / 2);

                // Avanzamos al siguiente nodo
                textNode = textNode.next;
                xNode = xNode.next;
                yNode = yNode.next;
            }
        }
    }

    public void playerAction() {
        if (isPlayerTurn && inBattle && round < 5) {
            // Obtener el daño que corresponde a la ronda y al botón presionado
            int damage = damageMatrix[round][selectedAction - 1]; // Restar 1 porque las acciones están indexadas desde 0

            // Reducir la salud del enemigo
            enemyHealth -= damage;

            // Mensaje de daño
            damageMessage = "You chose action " + selectedAction + " and dealt " + damage + " damage to the enemy!";
            enemyDamageMessage = "";
            if (enemyHealth <= 0) {
                System.out.print("you won");
                showYouWon = true;
                startTime = millis();
                inBattle = false; // Terminar la batalla si el enemigo muere
                game.setBattleState(false); // Actualizar battleState en WebWarriors
            } else {
                isPlayerTurn = false;
                enemyTurnStartTime = millis(); // Marcar el inicio del turno enemigo
            }
        }
    }

    public void enemyAction() {
        if (!isPlayerTurn && inBattle) {
            
          // El enemigo hace un ataque
          int enemyDamage = (int) random(1, 5); // Daño aleatorio del enemigo
          playerHealth -= enemyDamage;
          enemyDamageMessage = "Enemy dealt " + enemyDamage + " damage to you!";
          // Verificar si la batalla ha terminado
          selectedAction = 0; // Resetear la acción seleccionada
          round++; // Incrementar la ronda
          damageMessage = "";
          
          // Cambiar al siguiente comentario cuando cambia de ronda
          currentCommentIndex = (currentCommentIndex + 1) % comments.size();
          letterCount = 0;  // Reinicia el conteo de letras para el nuevo mensaje
          
          if (playerHealth <= 0) {
              System.out.print("you lose");
              showYouLose = true;
              startTime = millis();
              inBattle = false; // Terminar la batalla si el jugador muere
              game.setBattleState(false); // Actualizar battleState en WebWarriors
          } 
        }
    }

    public void displayTurn() {
        if (inBattle) {
            if (isPlayerTurn) {
                app.fill(0);
                app.text("Your turn. Choose \nan action.", 72, 570);
                app.image(textBox, 500, 20, 500, 300);
                Object comment = comments.getNode(currentCommentIndex);
                if (comment != null) {
                    String currentComment = (String) comment;

                    // Control de tiempo para mostrar letra por letra
                    if (app.millis() - lastUpdate > displaySpeed) {
                        if (letterCount < currentComment.length()) {
                            letterCount++;
                        }
                        lastUpdate = app.millis();
                    }

                    // Mostrar las letras hasta `letterCount`
                    app.fill(0);
                    app.text(currentComment.substring(0, letterCount), 570, 100);
                }
            } else {
                app.fill(0);
                app.rect(37, 530, 1440, 183);
                app.fill(255);
                // Mostrar el mensaje de daño después del turno del jugador
                app.text(damageMessage, 72, 650);
                if (millis() - enemyTurnStartTime >= 5000 && printNext == false) {
                    enemyAction();
                    enemyTurnStartTime = millis();
                    printNext = true;
                }else if (millis() - enemyTurnStartTime <= Integer.MAX_VALUE) {
                    app.text(enemyDamageMessage, 72, 650);
                    app.fill(255);
                    if(printNext){
                      app.image(next, 1200, 550, 100, 100);
                    }
                }else if(playerHealth <= 0 || enemyHealth <= 0){
                    inBattle = false;
                    game.setBattleState(false); // Actualizar battleState en WebWarriors
                }
                
            }
        }
    }
    public boolean isInBattle() {
        return inBattle;
    }

    public boolean isPlayerTurn() {
        return isPlayerTurn;
    }
    
    public int getEnemyHealth(){
      return this.enemyHealth;
    }
    public int getPlayerHealth(){
      return this.playerHealth;
    }
    
    public void mousePressed() {
        if (isPlayerTurn && inBattle) {
            // Aquí comprobamos si el jugador presionó alguno de los botones y asignamos la acción correspondiente
            if (app.mouseX >= 545 && app.mouseX <= 545 + squareSize + 350 && app.mouseY >= 537 && app.mouseY <= 537 + squareSize) {
                selectedAction = 1;
                playerAction();
            } else if (app.mouseX >= 1000 && app.mouseX <= 1000 + squareSize + 350 && app.mouseY >= 537 && app.mouseY <= 537 + squareSize) {
                selectedAction = 2;
                playerAction();
            } else if (app.mouseX >= 545 && app.mouseX <= 545 + squareSize + 350 && app.mouseY >= 630 && app.mouseY <= 630 + squareSize) {
                selectedAction = 3;
                playerAction();
            } else if (app.mouseX >= 1000 && app.mouseX <= 1000 + squareSize + 350 && app.mouseY >= 630 && app.mouseY <= 630 + squareSize) {
                selectedAction = 4;
                playerAction();
            }
        }else if(!isPlayerTurn && inBattle && printNext == true){
          if (app.mouseX >= 1200 && app.mouseX <= 1200 + 100 && app.mouseY >= 550 && app.mouseY <= 550 + 100) {
             isPlayerTurn = true;
             printNext = false;
          }
        }
    }
}
