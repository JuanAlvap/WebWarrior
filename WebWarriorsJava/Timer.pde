//La clase del cronómetro
class Timer {
  int startTime = 0, pauseTime = 0, totalPausedTime = 0;
  boolean running = false;
  boolean paused = false;

  //Inicia el cronómetro
  //Todo el cronómetro fue hecho con la función millis() la cual arroja el tiempo em milisegundos
  void start() {
    if (!running) {
      startTime = millis() - totalPausedTime;
      running = true;
      paused = false;
    }
  }

  void stop() {
    running = false;
    paused = false;
  }

  //"Pausa" el tiempo
  void pause() {
    if (running && !paused) {
      pauseTime = millis();
      paused = true;
    }
  }

  //Resume el tiempo pausado anteriormente
  void resume() {
    if (running && paused) {
      totalPausedTime += millis() - pauseTime;
      paused = false;
    }
  }

  //Si se llama a esta función se reinicia el tiempo
  void restart() {
    startTime = millis();
    totalPausedTime = 0;
    running = true;
    paused = false;
  }

  //Tiempo total trasncurrido
  int getElapsedTime() {
    int elapsed;
    if (running) {
      if (paused) {
        elapsed = pauseTime - startTime - totalPausedTime;
      } else {
        elapsed = millis() - startTime - totalPausedTime;
      }
    } else {
      elapsed = 0;
    }
    return elapsed;
  }

  //Estas funciones devuelven el tiempo transcurrido en milisegundos, segundos y minutos
  int milisecond() {
    return (getElapsedTime() / 10) % 100;
  }

  int second() {
    return (getElapsedTime() / 1000) % 60;
  }

  int minute() {
    return (getElapsedTime() / (1000 * 60)) % 60;
  }


  //Muestra en pantalla el cronómetro
  void time() {
    fill(255);
    //NF CONVIERTE NÚMEROS A STRING AÑADIENDO 0 A LA IZQUIERDA, POR ESO SE PONE COMO PARÁMETRO 2 PARA QUE SOLO MUESTRE 2 DÍGITOS
    textSize(40);
    text(nf(this.minute(), 2)+":"+nf(this.second(), 2)+":"+nf(this.milisecond(), 2), 600, 100);
  
    //Cuando llegue a 100 segundos muera el personaje
    if (this.minute() == 1 && this.second() >= 40 ) {
      print("you died");
    }
  }
}
