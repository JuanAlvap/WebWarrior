import processing.sound.*;

public class WebWarriors {
  private List playlist;
  private SoundFile currentPlayer;
  private DoublyNode currentSong;
  private PApplet app;
  private List platforms;
  private List battleList; // Lista de batallas
  private List spikes;
  private int activeBattleIndex = 0; // Índice de la batalla activa
  private boolean battleState = false; // Controla si una batalla está en curso
  private boolean count = true;

  public WebWarriors(PApplet app) {
    this.app = app;
    this.playlist = new CircularDoublyList();
    this.platforms = new SimpleList();
    this.battleList = new SimpleList();
    this.spikes = new SimpleList();

  }
  
  //BATTLE METHODS
  public void setActiveBattle(int index){
    this.activeBattleIndex = index;
  }
  
  public boolean isBattleActive() {
    return battleState;
  }

  public void setBattleState(boolean state) {
    this.battleState = state;
  }

  public void addBattle(Battle battle) {
    this.battleList.addNode(battle);
  }

  public void startBattle(int life) {
    if (((SimpleList)battleList).size() > 0) {
      Battle battle = (Battle) ((SimpleList)battleList).getNode(activeBattleIndex);
      battleState = true;
      battle.start(life); 
    }
  }

  public void nextBattle(int life) {
    if (activeBattleIndex < ((SimpleList)battleList).size() - 1) {
      activeBattleIndex++;
      startBattle(life);
    }
  }

  public int updateBattle(int life) {
    Battle battle = (Battle) ((SimpleList)battleList).getNode(activeBattleIndex);
    if (battleState && ((SimpleList)battleList).size() > 0) {
      app.image(combate, 0, 0);
      if(count){
        //se pasa la información de la vida en el juego
        battle.setPlayerHealth(life);
        count = false;
      }
      
      battle.updatePlayerLifeBar(app);
      battle.updateEnemyLifeBar(app);
      battle.displayStatus();
      battle.displaySquares();
      battle.displayTurn();
      if(battle.getEnemyHealth() == 0 || battle.getPlayerHealth() == 0){
        battleState = false;
        count = true;
      }
    }
    //se pasa la información de la vida después de la batalla
    return battle.getPlayerHealth();
  }

  public void mousePressed() {
    if (battleState && ((SimpleList)battleList).size() > 0) {
      Battle battle = (Battle) ((SimpleList)battleList).getNode(activeBattleIndex);
      battle.mousePressed();
    }
  }

  
  public List getPlaylist(){
    return this.playlist;
  }
  
  public void addSong(Object song){
    this.playlist.addNode(song);
    if (currentSong == null) {
      setupPlaylist();
    }
  }
  
  public void addPlatform(Object platform){
    this.platforms.addNode(platform);
  }
  
  public List getPlatforms(){
    return this.platforms;
  }
  
  public void addSpike(Object spike){
    this.spikes.addNode(spike);
  }
  
  public List getSpikes(){
    return this.spikes;
  }

  private void setupPlaylist() {
    // Selecciona una canción aleatoria para comenzar
    currentSong = (DoublyNode) playlist.PTR;
    int randomStart = (int) app.random(((CircularDoublyList)playlist).size());
    for (int i = 0; i < randomStart; i++) {
      currentSong = (DoublyNode) currentSong.next;
    }
    playCurrentSong();
  }

  public void playCurrentSong() {
    if (currentPlayer != null && currentPlayer.isPlaying()) {
      currentPlayer.stop();
    }
    currentPlayer = new SoundFile(app, "data/" + (String) currentSong.info);
    currentPlayer.play();
  }

  public void nextSong() {
    currentSong = (DoublyNode) currentSong.next;
    playCurrentSong();
  }

  public void previousSong() {
    currentSong = (DoublyNode) currentSong.prev;
    playCurrentSong();
  }

  public void displayCurrentSong() {
    app.background(255);
    app.textSize(24);
    app.fill(0);
    app.textAlign(PApplet.CENTER, PApplet.CENTER);
    app.text("Now Playing: " + currentSong.info, app.width / 2, app.height / 2);
  }
}
