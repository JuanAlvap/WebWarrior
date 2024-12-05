import processing.sound.*;

public class WebWarriors {
  private List playlist;
  private SoundFile currentPlayer;
  private DoublyNode currentSong;
  private PApplet app;
  private List platforms;
  private List battleList; // Lista de batallas
  private List spikes;
  private int activeBattleIndex; // Índice de la batalla activa
  private boolean battleState; // Controla si una batalla está en curso
  private boolean count;
  private SoundFile jumpSound;
  private SoundFile spikeHitSound;
  private SoundFile portalSound;
  private SoundFile bonusSound;
  private SoundFile victorySound;
  private SoundFile virusAttackSound;
  private SoundFile characterAttackSound;
  private int songStartTime;   // Momento en que inició la canción
  private int songDuration;    // Duración de la canción en milisegundos

  public WebWarriors(PApplet app) {
    this.app = app;
    this.playlist = new CircularDoublyList();
    this.platforms = new SimpleList();
    this.battleList = new SimpleList();
    this.spikes = new SimpleList();
    
    this.jumpSound = new SoundFile(app, "salto.mp3");
    this.spikeHitSound = new SoundFile(app, "dañoPincho.mp3");
    this.portalSound = new SoundFile(app, "portal.mp3");
    this.bonusSound = new SoundFile(app, "bonus.mp3");
    this.victorySound = new SoundFile(app, "victory.mp3");
    this.virusAttackSound = new SoundFile(app, "virusAttack.mp3");
    this.characterAttackSound = new SoundFile(app, "puños.mp3");
    
    this.activeBattleIndex = 0;
    this.battleState = false;
    this.count = true;
  }

  public void addBattle(Battle battle) {
    this.battleList.addNode(battle);
  }
  
  public void addSong(Object song){
    this.playlist.addNode(song);
    setupPlaylist();
  }
  
  public void addPlatform(Object platform){
    this.platforms.addNode(platform);
  }
  
  public void addSpike(Object spike){
    this.spikes.addNode(spike);
  }
  
  //BATTLE METHODS
  public void startBattle(int life) {
    if (((SimpleList)this.battleList).size() > 0) {
      Battle battle = (Battle) ((SimpleList)this.battleList).getNode(this.activeBattleIndex);
      this.battleState = true;
      battle.start(life); 
    }
  }

  public void nextBattle(int life) {
    if (this.activeBattleIndex < ((SimpleList)this.battleList).size() - 1) {
      this.activeBattleIndex++;
      startBattle(life);
    }
  }

  public int updateBattle(int life) {
    Battle battle = (Battle) ((SimpleList)this.battleList).getNode(this.activeBattleIndex);
    if (this.battleState && ((SimpleList)this.battleList).size() > 0) {
      app.image(combate, 0, 0);
      if(this.count){
        //se pasa la información de la vida en el juego
        battle.setPlayerHealth(life);
        this.count = false;
      }
      
      battle.updatePlayerLifeBar(app);
      battle.updateEnemyLifeBar(app);
      battle.displayStatus();
      battle.displaySquares();
      battle.displayTurn();
      if(battle.getEnemyHealth() == 0 || battle.getPlayerHealth() == 0){
        this.battleState = false;
        this.count = true;
      }
    }
    //se pasa la información de la vida después de la batalla
    return battle.getPlayerHealth();
  }

  public void mousePressed() {
    if (this.battleState && ((SimpleList)this.battleList).size() > 0) {
      Battle battle = (Battle) ((SimpleList)this.battleList).getNode(this.activeBattleIndex);
      battle.mousePressed();
    }
  }
  
  //MUSIC METHODS
  private void setupPlaylist() {
    // Selecciona una canción aleatoria para comenzar
    this.currentSong = (DoublyNode) this.playlist.getPTR();
    int randomStart = (int) app.random(0, ((CircularDoublyList)this.playlist).size());
    for (int i = 0; i <= randomStart; i++) {
      this.currentSong = (DoublyNode) this.currentSong.getNext();
    }
    playCurrentSong();
  }

  public void playCurrentSong() {
    if (this.currentPlayer != null && this.currentPlayer.isPlaying()) {
        this.currentPlayer.stop();
    }
    this.currentPlayer = new SoundFile(app, "data/" + (String) this.currentSong.getInfo());
    
    // Verifica que el archivo se cargue correctamente antes de configurar el volumen
    if (this.currentPlayer != null) {
        this.currentPlayer.amp(0.3); // Silencia el volumen
        this.currentPlayer.play();
        
        // Iniciar temporizador para controlar la duración
        this.songStartTime = app.millis();
        this.songDuration = (int) (this.currentPlayer.duration() * 1000); // Convertir duración a milisegundos
    }
  }

  public void nextSong() {
    this.currentSong = (DoublyNode) this.currentSong.getNext();
    playCurrentSong();
  }

  public void previousSong() {
    this.currentSong = (DoublyNode) this.currentSong.getPrev();
    playCurrentSong();
  }
  
  public void checkSongEnd() {
    if (millis() - this.songStartTime >= this.songDuration) {
        nextSong();  // Cambiar a la siguiente canción
    }
  }

  public void displayCurrentSong() {
    app.fill(255);
    app.text("Now Playing: " + this.currentSong.getInfo(), width/2-310, 30);
    app.fill(0);
  }
  
  // SOUND EFFECTS
  public void playJumpSound() {
    if (this.jumpSound != null) this.jumpSound.play();
  }
  
  public void playSpikeHitSound() {
    if (this.spikeHitSound != null) this.spikeHitSound.play();
  }
  
  public void playPortalSound() {
    if (this.portalSound != null) this.portalSound.play();
  }
  
  public void playBonusSound() {
    if (this.bonusSound != null) this.bonusSound.play();
  }
  
  public void playVictorySound() {
    if (this.victorySound != null) this.victorySound.play();
  }
  
  public void playVirusAttackSound() {
    if (this.virusAttackSound != null) this.virusAttackSound.play();
  }
  
  public void playCharacterAttackSound(){
    if (this.characterAttackSound != null) this.characterAttackSound.play();
  }
  
  //CHARACTER SELECTOR BUTTON
  public boolean isPointInTriangle(float px, float py, float x1, float y1, float x2, float y2, float x3, float y3) {
    float areaOrig = abs((x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1));
    float area1 = abs((x1 - px) * (y2 - py) - (x2 - px) * (y1 - py));
    float area2 = abs((x2 - px) * (y3 - py) - (x3 - px) * (y2 - py));
    float area3 = abs((x3 - px) * (y1 - py) - (x1 - px) * (y3 - py));
  
    return abs(area1 + area2 + area3 - areaOrig) < 1.0;
  }
  
  //GETTERS Y SETTERS
  public void setActiveBattle(int index){
    this.activeBattleIndex = index;
  }
  
  public boolean isBattleActive() {
    return battleState;
  }

  public void setBattleState(boolean state) {
    this.battleState = state;
  }
  
  public List getPlaylist(){
    return this.playlist;
  }
  
  public List getPlatforms(){
    return this.platforms;
  }
  
  public List getSpikes(){
    return this.spikes;
  }
  
  public SoundFile getCurrentPlayer(){
    return this.currentPlayer;
  }
  
}
