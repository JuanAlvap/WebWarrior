public class Battle {
    private boolean isPlayerTurn;
    private boolean inBattle;
    private int playerHealth;
    private int enemyHealth;
    private PApplet app;

    private SimpleList textsRound0;  // Lista de textos
    private SimpleList textsRound1;  // Lista de textos
    private SimpleList textsRound2;  // Lista de textos
    private SimpleList textsRound3;  // Lista de textos
    private SimpleList textsRound4;  // Lista de textos
    private SimpleList textsRound5;  // Lista de textos
    
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
    
    private int startBattleStartTime; // Tiempo de inicio de la imagen inicial
    private boolean showStartImage; // Indica si se debe mostrar la imagen inicial

    // Daño que los botones causan en cada ronda
    private int[][] damageMatrix = {
        {2, 3, 4, 0}, // Daños para ronda 1
        {1, 4, 3, 0}, // Daños para ronda 2
        {3, 0, 1, 4}, // Daños para ronda 3
        {4, 1, 2, 3}, // Daños para ronda 4
        {2, 3, 4, 0}, // Daños para ronda 5
        {3, 4, 1, 0}  // Daños para ronda 6
    };
    
    private int currentCommentIndex; // Índice del comentario actual
    private int letterCount;         // Contador de letras mostradas
    private int lastUpdate;          // Tiempo del último incremento de letra
    private int displaySpeed;      // Tiempo entre letras (milisegundos)
    
    private Character battleCharacter;
    private Character enemy;
    
    private WebWarriors game; // Referencia a WebWarriors

    public Battle(PApplet app, SimpleList textsRound0, SimpleList textsRound1, SimpleList textsRound2, SimpleList textsRound3, SimpleList textsRound4, SimpleList textsRound5, SimpleList xPositions, SimpleList yPositions, WebWarriors game, SimpleList comments, Character battleCharacter, Character enemy) {
        this.app = app;
        this.textsRound0 = textsRound0;
        this.textsRound1 = textsRound1;
        this.textsRound2 = textsRound2;
        this.textsRound3 = textsRound3;
        this.textsRound4 = textsRound4;
        this.textsRound5 = textsRound5;
        this.squareX = xPositions;
        this.squareY = yPositions;
        this.game = game; // Guardar la referencia
        this.comments = comments;
        this.displaySpeed = 50;
        this.lastUpdate = 0;
        this.letterCount = 0;
        this.currentCommentIndex = 0;
        this.enemyDamageMessage = "";
        this.damageMessage = "";
        this.enemyTurnStartTime = 0;
        this.squareSize = 80;
        this.battleCharacter = battleCharacter;
        this.enemy = enemy;
    }

    public void start(int life) {
        isPlayerTurn = true;
        inBattle = true;
        playerHealth = life;
        enemyHealth = 10;
        selectedAction = 0; // Resetear la acción seleccionada al inicio de cada batalla
        round = 0; // Resetear las rondas
        damageMessage = ""; // Resetear mensaje de daño
        enemyDamageMessage = ""; // Resetear mensaje de daño del enemigo
        printNext = false;
        startBattleStartTime = app.millis(); // Guardar el tiempo de inicio
        showStartImage = true; // Activar la visualización de la imagen inicial
        areYouReady.play();
    }

    public void displayStatus() {
        app.fill(0);
        app.text("Player    " + playerHealth + "/10", 1140, 400);
        app.text(enemyHealth + "/10" + "    Enemy", 100, 120);
    }

    public void displaySquares() {
        if (inBattle) {
            Node textNodeRound0 = textsRound0.PTR;  // Recorrer la lista de textos
            Node textNodeRound1 = textsRound1.PTR;
            Node textNodeRound2 = textsRound2.PTR;  // Recorrer la lista de textos
            Node textNodeRound3 = textsRound3.PTR;
            Node textNodeRound4 = textsRound4.PTR;  // Recorrer la lista de textos
            Node textNodeRound5 = textsRound5.PTR;
            Node xNode = squareX.PTR;         // Recorrer la lista de posiciones X
            Node yNode = squareY.PTR;         // Recorrer la lista de posiciones Y
            int pos = 0;
            while (textNodeRound0 != null && textNodeRound1 != null && textNodeRound2 != null && textNodeRound3 != null && textNodeRound4 != null && textNodeRound5 != null) {
                pos++;
                app.fill(255);
                if (pos == 5) {
                    app.image(optionBox, (Integer) xNode.info, (Integer) yNode.info, squareSize + 350, squareSize + 80);
                } else {
                    app.image(optionBox, (Integer) xNode.info, (Integer) yNode.info, squareSize + 350, squareSize);
                }

                app.fill(0); // Color de texto blanco
                
                if (round == 0) {
                    app.text((String) textNodeRound0.info, (Integer) xNode.info + squareSize / 2, (Integer) yNode.info + squareSize / 2 - 10);
                }
                if (round == 1) {
                    app.text((String) textNodeRound1.info, (Integer) xNode.info + squareSize / 2, (Integer) yNode.info + squareSize / 2 - 10);
                }
                if (round == 2) {
                    app.text((String) textNodeRound2.info, (Integer) xNode.info + squareSize / 2, (Integer) yNode.info + squareSize / 2 - 10);
                }
                if (round == 3) {
                    app.text((String) textNodeRound3.info, (Integer) xNode.info + squareSize / 2, (Integer) yNode.info + squareSize / 2 - 10);
                }
                if (round == 4) {
                    app.text((String) textNodeRound4.info, (Integer) xNode.info + squareSize / 2, (Integer) yNode.info + squareSize / 2 - 10);
                }
                if (round == 5) {
                    app.text((String) textNodeRound5.info, (Integer) xNode.info + squareSize / 2, (Integer) yNode.info + squareSize / 2 - 10);
                }
                
                textNodeRound0 = textNodeRound0.next;
                textNodeRound1 = textNodeRound1.next;
                textNodeRound2 = textNodeRound2.next;
                textNodeRound3 = textNodeRound3.next;
                textNodeRound4 = textNodeRound4.next;
                textNodeRound5 = textNodeRound5.next;
                xNode = xNode.next;
                yNode = yNode.next;
            }
        }
    }

    public void playerAction() {
        if (isPlayerTurn && inBattle) {
            // Obtener el daño que corresponde a la ronda y al botón presionado
            int damage = damageMatrix[round][selectedAction - 1]; // Restar 1 porque las acciones están indexadas desde 0

            // Reducir la salud del enemigo
            enemyHealth -= damage;
            if(damage != 0){
              battleCharacter.vibrate();
            }
            // Mensaje de daño
            switch (damage){
                case 0:
                  damageMessage = "That wasn't a good choice. You caused no harm to the enemy.\nTry harder next time!";
                  break;
                case 1:
                  damageMessage = "A small hit, but it barely scratched the enemy.\nThink carefully to deal more damage!";
                  break;
                case 2:
                  damageMessage = "Not bad! You managed to weaken the enemy a little.\nStay sharp for better results!";
                  break;
                case 3:
                  damageMessage = "Great choice! You struck the enemy hard.\nKeep it up and aim for the perfect answer!";
                  break;
                case 4:
                  damageMessage = "Excellent decision! A critical blow to the enemy!\nYou're getting closer to victory!";
                  break;
                default:
                  damageMessage = "You dealt " + damage + " damage to the enemy!";
                  break;
            }
            
            enemyDamageMessage = "";
            if (enemyHealth <= 0) {
                System.out.print("you won");
                showYouWon = true;
                youWon1.play();
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
          // Mensaje de daño
          switch (enemyDamage){
              case 1:
                enemyDamageMessage = "Is that all you've got?\nYou're barely holding up!";
                break;
              case 2:
                enemyDamageMessage = "I can see you're struggling.\nMy attacks are starting to wear you down!";
                break;
              case 3:
                enemyDamageMessage = "You're feeling it now, aren't you?\nI'm just getting started!";
                break;
              case 4:
                enemyDamageMessage = "Your defenses are crumbling!\nYou can't keep this up much longer!";
                break;
              case 5:
                enemyDamageMessage = "A crushing blow!\nYou'll never recover from this!";
                break;
              default:
                enemyDamageMessage = "The enemy dealt " + enemyDamage + " damage to the you!";
                break;
          }
          // Verificar si la batalla ha terminado
          selectedAction = 0; // Resetear la acción seleccionada
          round++; // Incrementar la ronda
          damageMessage = "";
          enemy.vibrate();
          // Cambiar al siguiente comentario cuando cambia de ronda
          currentCommentIndex = (currentCommentIndex + 1) % comments.size();
          letterCount = 0;  // Reinicia el conteo de letras para el nuevo mensaje
          
          if (playerHealth <= 0) {
            //se devuelve la vida a 0 porque si es negativa no se puede dibujar en la barra de vida.
              this.playerHealth = 0;
              System.out.print("you lose");
              showYouLose = true;
              youLose1.play();
              startTime = millis();
              inBattle = false; // Terminar la batalla si el jugador muere
              game.setBattleState(false); // Actualizar battleState en WebWarriors
          } 
        }
    }

    public void displayTurn() {
        if (inBattle) {
            if (showStartImage) {
                // Mostrar la imagen inicial durante 5 segundos
                app.image(areYouReady, 0, 0, app.width, app.height); // Ajusta la imagen al tamaño de la pantalla
                if (app.millis() - startBattleStartTime > 6000) {
                    areYouReady.stop();
                    showStartImage = false; // Desactivar la imagen inicial después de 5 segundos
                }
            } else {
                // Aquí continúa la lógica normal de la batalla
                
                battleCharacter.display(app);
                enemy.display(app);
                if (isPlayerTurn) {
                    app.fill(0);
                    app.text("Your turn.\nChoose an action.", 80, 590);
                    app.image(textBox, 550, 50, 450, 250);
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
                        app.text(currentComment.substring(0, letterCount), 580, 100);
                    }
                } else {
                    app.fill(0);
                    app.rect(37, 530, 1440, 183);
                    app.fill(255);
                    // Mostrar el mensaje de daño después del turno del jugador
                    app.text(damageMessage, 72, 610);
                    if (app.millis() - enemyTurnStartTime >= 5000 && printNext == false) {
                        enemyAction();
                        enemyTurnStartTime = app.millis();
                        printNext = true;
                    } else if (app.millis() - enemyTurnStartTime <= Integer.MAX_VALUE) {
                        app.text(enemyDamageMessage, 72, 610);
                        app.fill(255);
                        if (printNext) {
                            app.image(next, 1200, 570, 100, 100);
                        }
                    } else if (playerHealth <= 0 || enemyHealth <= 0) {
                        inBattle = false;
                        game.setBattleState(false); // Actualizar battleState en WebWarriors
                    }
                }
            }
        }
    }

    
    public void updateEnemyLifeBar(PApplet app){
      switch (this.enemyHealth) {
          case 10:
              app.image(lifeBar10, 50, 140);
              break;
          case 9:
              app.image(lifeBar9, 50, 140);
              break;
          case 8:
              app.image(lifeBar8, 50, 140);
              break;
          case 7:
              app.image(lifeBar7, 50, 140);
              break;
          case 6:
              app.image(lifeBar6, 50, 140);
              break;
          case 5:
              app.image(lifeBar5, 50, 140);
              break;
          case 4:
              app.image(lifeBar4, 50, 140);
              break;
          case 3:
              app.image(lifeBar3, 50, 140);
              break;
          case 2:
              app.image(lifeBar2, 50, 140);
              break;
          case 1:
              app.image(lifeBar1, 50, 140);
              break;
          case 0:
              app.image(lifeBar0, 50, 140);
              break;
        }
    }
    
    public void updatePlayerLifeBar(PApplet app) {
      // Dibujar la barra de vida correspondiente
      switch (this.playerHealth) {
          case 10:
              app.image(lifeBar10, 1100, 420);
              break;
          case 9:
              app.image(lifeBar9, 1100, 420);
              break;
          case 8:
              app.image(lifeBar8, 1100, 420);
              break;
          case 7:
              app.image(lifeBar7, 1100, 420);
              break;
          case 6:
              app.image(lifeBar6, 1100, 420);
              break;
          case 5:
              app.image(lifeBar5, 1100, 420);
              break;
          case 4:
              app.image(lifeBar4, 1100, 420);
              break;
          case 3:
              app.image(lifeBar3, 1100, 420);
              break;
          case 2:
              app.image(lifeBar2, 1100, 420);
              break;
          case 1:
              app.image(lifeBar1, 1100, 420);
              break;
          case 0:
              app.image(lifeBar0, 1100, 420);
              break;
        }
    }
  
  
    // Método para iniciar el parpadeo al cambiar la vida
    public void setPlayerHealth(int newLife) {
        if (this.playerHealth != newLife) {
            this.playerHealth = newLife; // Actualizar la vida
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
