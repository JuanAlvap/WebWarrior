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
    private int[][] damageMatrix;
    
    private int currentCommentIndex; // Índice del comentario actual
    private int letterCount;         // Contador de letras mostradas
    private int lastUpdate;          // Tiempo del último incremento de letra
    private int displaySpeed;      // Tiempo entre letras (milisegundos)
    
    private Character battleCharacter;
    private Character enemy;
    
    private Movie youWon;
    private Movie youLose;
    
    private WebWarriors game; // Referencia a WebWarriors

    public Battle(PApplet app, int[][] damageMatrix, Movie youWon, Movie youLose, SimpleList textsRound0, SimpleList textsRound1, SimpleList textsRound2, SimpleList textsRound3, SimpleList textsRound4, SimpleList textsRound5, SimpleList xPositions, SimpleList yPositions, WebWarriors game, SimpleList comments, Character battleCharacter, Character enemy) {
        this.app = app;
        this.damageMatrix = damageMatrix;
        this.youWon = youWon;
        this.youLose = youLose;
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
        this.isPlayerTurn = true;
        this.inBattle = true;
        this.playerHealth = life;
        this.enemyHealth = 10;
        this.selectedAction = 0; // Resetear la acción seleccionada al inicio de cada batalla
        this.round = 0; // Resetear las rondas
        this.damageMessage = ""; // Resetear mensaje de daño
        this.enemyDamageMessage = ""; // Resetear mensaje de daño del enemigo
        this.printNext = false;
        this.startBattleStartTime = app.millis(); // Guardar el tiempo de inicio
        this.showStartImage = true; // Activar la visualización de la imagen inicial
        this.currentCommentIndex = 0;
        areYouReady.play();
    }

    public void displayStatus() {
        app.fill(0);
        app.text("Player    " + this.playerHealth + "/10", 1140, 400);
        app.text(this.enemyHealth + "/10" + "    Enemy", 100, 120);
    }

    public void displaySquares() {
        if (this.inBattle) {
            Node textNodeRound0 = this.textsRound0.getPTR();  // Recorrer la lista de textos
            Node textNodeRound1 = this.textsRound1.getPTR();
            Node textNodeRound2 = this.textsRound2.getPTR();  // Recorrer la lista de textos
            Node textNodeRound3 = this.textsRound3.getPTR();
            Node textNodeRound4 = this.textsRound4.getPTR();  // Recorrer la lista de textos
            Node textNodeRound5 = this.textsRound5.getPTR();
            Node xNode = this.squareX.getPTR();         // Recorrer la lista de posiciones X
            Node yNode = this.squareY.getPTR();         // Recorrer la lista de posiciones Y
            int pos = 0;
            while (textNodeRound0 != null && textNodeRound1 != null && textNodeRound2 != null && textNodeRound3 != null && textNodeRound4 != null && textNodeRound5 != null) {
                pos++;
                app.fill(255);
                if (pos == 5) {
                    app.image(optionBox, (Integer) xNode.getInfo(), (Integer) yNode.getInfo(), this.squareSize + 350, this.squareSize + 80);
                } else {
                    app.image(optionBox, (Integer) xNode.getInfo(), (Integer) yNode.getInfo(), this.squareSize + 350, this.squareSize);
                }

                app.fill(0); // Color de texto blanco
                
                if (round == 0) {
                    app.text((String) textNodeRound0.getInfo(), (Integer) xNode.getInfo() + this.squareSize / 2, (Integer) yNode.getInfo() + this.squareSize / 2 - 10);
                }
                if (round == 1) {
                    app.text((String) textNodeRound1.getInfo(), (Integer) xNode.getInfo() + this.squareSize / 2, (Integer) yNode.getInfo() + this.squareSize / 2 - 10);
                }
                if (round == 2) {
                    app.text((String) textNodeRound2.getInfo(), (Integer) xNode.getInfo() + this.squareSize / 2, (Integer) yNode.getInfo() + this.squareSize / 2 - 10);
                }
                if (round == 3) {
                    app.text((String) textNodeRound3.getInfo(), (Integer) xNode.getInfo() + this.squareSize / 2, (Integer) yNode.getInfo() + this.squareSize / 2 - 10);
                }
                if (round == 4) {
                    app.text((String) textNodeRound4.getInfo(), (Integer) xNode.getInfo() + this.squareSize / 2, (Integer) yNode.getInfo() + this.squareSize / 2 - 10);
                }
                if (round == 5) {
                    app.text((String) textNodeRound5.getInfo(), (Integer) xNode.getInfo() + this.squareSize / 2, (Integer) yNode.getInfo() + this.squareSize / 2 - 10);
                }
                
                textNodeRound0 = textNodeRound0.getNext();
                textNodeRound1 = textNodeRound1.getNext();
                textNodeRound2 = textNodeRound2.getNext();
                textNodeRound3 = textNodeRound3.getNext();
                textNodeRound4 = textNodeRound4.getNext();
                textNodeRound5 = textNodeRound5.getNext();
                xNode = xNode.getNext();
                yNode = yNode.getNext();
            }
        }
    }

    public void playerAction() {
        if (this.isPlayerTurn && this.inBattle) {
            // Obtener el daño que corresponde a la ronda y al botón presionado
            int damage = this.damageMatrix[this.round][this.selectedAction - 1]; // Restar 1 porque las acciones están indexadas desde 0

            // Reducir la salud del enemigo
            this.enemyHealth -= damage;
            game.playCharacterAttackSound();
            if(damage != 0){
              this.battleCharacter.vibrate();
            }
            // Mensaje de daño
            switch (damage){
                case 0:
                  this.damageMessage = "That wasn't a good choice. You caused no harm to the enemy.\nTry harder next time!";
                  break;
                case 1:
                  this.damageMessage = "A small hit, but it barely scratched the enemy.\nThink carefully to deal more damage!";
                  break;
                case 2:
                  this.damageMessage = "Not bad! You managed to weaken the enemy a little.\nStay sharp for better results!";
                  break;
                case 3:
                  this.damageMessage = "Great choice! You struck the enemy hard.\nKeep it up and aim for the perfect answer!";
                  break;
                case 4:
                  this.damageMessage = "Excellent decision! A critical blow to the enemy!\nYou're getting closer to victory!";
                  break;
                default:
                  this.damageMessage = "You dealt " + damage + " damage to the enemy!";
                  break;
            }
            
            this.enemyDamageMessage = "";
            if (this.enemyHealth <= 0) {
                showYouWon = true;
                this.youWon.play();
                startTime = millis();
                this.inBattle = false; // Terminar la batalla si el enemigo muere
                game.setBattleState(false); // Actualizar battleState en WebWarriors
            } else {
                this.isPlayerTurn = false;
                this.enemyTurnStartTime = millis(); // Marcar el inicio del turno enemigo
            }
        }
    }

    public void enemyAction() {
        if (!this.isPlayerTurn && this.inBattle) {
            
          // El enemigo hace un ataque
          int enemyDamage = (int) random(1, 5); // Daño aleatorio del enemigo
          game.playVirusAttackSound(); // corregir !!!!! !!!!! !!!!! !!!!! !!!!! !!!!! !!!!! !!!!! !!!!! !!!!! !!!!! !!!!! !!!!! !!!!! !!!!! !!!!! !!!!! !!!!!
          this.playerHealth -= enemyDamage;
          // Mensaje de daño
          switch (enemyDamage){
              case 1:
                this.enemyDamageMessage = "Is that all you've got?\nYou're barely holding up!";
                break;
              case 2:
                this.enemyDamageMessage = "I can see you're struggling.\nMy attacks are starting to wear you down!";
                break;
              case 3:
                this.enemyDamageMessage = "You're feeling it now, aren't you?\nI'm just getting started!";
                break;
              case 4:
                this.enemyDamageMessage = "Your defenses are crumbling!\nYou can't keep this up much longer!";
                break;
              case 5:
                this.enemyDamageMessage = "A crushing blow!\nYou'll never recover from this!";
                break;
              default:
                this.enemyDamageMessage = "The enemy dealt " + enemyDamage + " damage to the you!";
                break;
          }
          // Verificar si la batalla ha terminado
          this.selectedAction = 0; // Resetear la acción seleccionada
          this.round++; // Incrementar la ronda
          this.damageMessage = "";
          this.enemy.vibrate();
          // Cambiar al siguiente comentario cuando cambia de ronda
          this.currentCommentIndex = (this.currentCommentIndex + 1) % this.comments.size();
          this.letterCount = 0;  // Reinicia el conteo de letras para el nuevo mensaje
          
          if (this.playerHealth <= 0) {
            //se devuelve la vida a 0 porque si es negativa no se puede dibujar en la barra de vida.
              this.playerHealth = 0;
              showYouLose = true;
              this.youLose.play();
              startTime = millis();
              this.inBattle = false; // Terminar la batalla si el jugador muere
              game.setBattleState(false); // Actualizar battleState en WebWarriors
          } 
        }
    }

    public void displayTurn() {
        if (this.inBattle) {
            if (this.showStartImage) {
                // Mostrar la imagen inicial durante 5 segundos
                app.image(areYouReady, 0, 0, app.width, app.height); // Ajusta la imagen al tamaño de la pantalla
                if (app.millis() - this.startBattleStartTime > 6000) {
                    areYouReady.stop();
                    this.showStartImage = false; // Desactivar la imagen inicial después de 5 segundos
                }
            } else {
                // Aquí continúa la lógica normal de la batalla
                this.battleCharacter.display(app);
                this.enemy.display(app);
                if (this.isPlayerTurn) {
                    app.fill(0);
                    app.text("Your turn.\nChoose an action.", 80, 590);
                    app.image(textBox, 550, 50, 450, 250);
                    Object comment = this.comments.getNode(this.currentCommentIndex);
                    if (comment != null) {
                        String currentComment = (String) comment;
    
                        // Control de tiempo para mostrar letra por letra
                        if (app.millis() - this.lastUpdate > this.displaySpeed) {
                            if (this.letterCount < currentComment.length()) {
                                this.letterCount++;
                            }
                            this.lastUpdate = app.millis();
                        }
    
                        // Mostrar las letras hasta `letterCount`
                        app.fill(0);
                        app.text(currentComment.substring(0, this.letterCount), 580, 100);
                    }
                } else {
                    app.fill(0);
                    app.rect(37, 530, 1440, 183);
                    app.fill(255);
                    // Mostrar el mensaje de daño después del turno del jugador
                    app.text(this.damageMessage, 72, 610);
                    if (app.millis() - this.enemyTurnStartTime >= 5000 && this.printNext == false) {
                        enemyAction();
                        this.enemyTurnStartTime = app.millis();
                        this.printNext = true;
                    } else if (app.millis() - this.enemyTurnStartTime <= Integer.MAX_VALUE) {
                        app.text(this.enemyDamageMessage, 72, 610);
                        app.fill(255);
                        if (this.printNext) {
                            app.image(next, 1200, 570, 100, 100);
                        }
                    } else if (this.playerHealth <= 0 || this.enemyHealth <= 0) {
                        this.inBattle = false;
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
    
    public void setBattleCharacter(Character battleCharacter){
      this.battleCharacter = battleCharacter;
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
    
    public void mousePressed() {
        if (this.isPlayerTurn && this.inBattle) {
            // Aquí comprobamos si el jugador presionó alguno de los botones y asignamos la acción correspondiente
            if (app.mouseX >= 545 && app.mouseX <= 545 + this.squareSize + 350 && app.mouseY >= 537 && app.mouseY <= 537 + this.squareSize) {
                this.selectedAction = 1;
                playerAction();
            } else if (app.mouseX >= 1000 && app.mouseX <= 1000 + this.squareSize + 350 && app.mouseY >= 537 && app.mouseY <= 537 + this.squareSize) {
                this.selectedAction = 2;
                playerAction();
            } else if (app.mouseX >= 545 && app.mouseX <= 545 + this.squareSize + 350 && app.mouseY >= 630 && app.mouseY <= 630 + this.squareSize) {
                this.selectedAction = 3;
                playerAction();
            } else if (app.mouseX >= 1000 && app.mouseX <= 1000 + this.squareSize + 350 && app.mouseY >= 630 && app.mouseY <= 630 + this.squareSize) {
                this.selectedAction = 4;
                playerAction();
            }
        }else if(!this.isPlayerTurn && this.inBattle && this.printNext == true){
          if (app.mouseX >= 1200 && app.mouseX <= 1200 + 100 && app.mouseY >= 550 && app.mouseY <= 550 + 100) {
             this.isPlayerTurn = true;
             this.printNext = false;
          }
        }
    }
    
    //GETTERS Y SETTERS
    
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
}
