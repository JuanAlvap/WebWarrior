//La clase del cronómetro
class Timer {
  private int startTime, pauseTime, totalPausedTime;
  private boolean running;
  private boolean paused;
  
  public Timer(){
    this.startTime = 0;
    this.pauseTime = 0;
    this.totalPausedTime = 0;
    this.running = false;
    this.paused = false;
  }
  //Inicia el cronómetro
  //Todo el cronómetro fue hecho con la función millis() la cual arroja el tiempo em milisegundos
  public void start() {
    if (!this.running) {
      this.startTime = millis() - this.totalPausedTime;
      this.running = true;
      this.paused = false;
    }
  }

  public void stop() {
    this.running = false;
    this.paused = false;
  }

  //"Pausa" el tiempo
  public void pause() {
    if (this.running && !this.paused) {
      this.pauseTime = millis();
      this.paused = true;
    }
  }

  //Resume el tiempo pausado anteriormente
  public void resume() {
    if (this.running && this.paused) {
      this.totalPausedTime += millis() - this.pauseTime;
      this.paused = false;
    }
  }

  //Si se llama a esta función se reinicia el tiempo
  public void restart() {
    this.startTime = millis();
    this.totalPausedTime = 0;
    this.running = true;
    this.paused = false;
  }

  //Tiempo total trasncurrido
  public int getElapsedTime() {
    int elapsed;
    if (this.running) {
      if (this.paused) {
        elapsed = this.pauseTime - this.startTime - this.totalPausedTime;
      } else {
        elapsed = millis() - this.startTime - this.totalPausedTime;
      }
    } else {
      elapsed = 0;
    }
    return elapsed;
  }

  //Estas funciones devuelven el tiempo transcurrido en milisegundos, segundos y minutos
  public int milisecond() {
    return (getElapsedTime() / 10) % 100;
  }

  public int second() {
    return (getElapsedTime() / 1000) % 60;
  }

  public int minute() {
    return (getElapsedTime() / (1000 * 60)) % 60;
  }


  //Muestra en pantalla el cronómetro
  public void time() {
    fill(255);
    //NF CONVIERTE NÚMEROS A STRING AÑADIENDO 0 A LA IZQUIERDA, POR ESO SE PONE COMO PARÁMETRO 2 PARA QUE SOLO MUESTRE 2 DÍGITOS
    textSize(40);
    text(nf(this.minute(), 2)+":"+nf(this.second(), 2)+":"+nf(this.milisecond(), 2), 600, 100);
  
    if (this.second() >= 50) {
      screen = 0;
      mainCharacter.getGifPlayer().setX(0);
      mainCharacter.getGifPlayer().setY(0);
      mainCharacter.setLife(10);
      backgroundOffset = 0;
      this.restart();
      battleFinished = true;
      booleanBattle1 = false;
      booleanBattle2 = false;
      booleanBattle3 = false;
      map1 = false;
      map2 = false;
      map3 = false;
    }
  }
}
