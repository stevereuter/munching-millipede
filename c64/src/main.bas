# the munching millipede (c) 2026 steviesaurus dev

# load all disc files
#include "fileLoader.bas"
#include "variables.bas"
  
startIntroScreen:
gosub introScreenSub

# load game
#include "initGame.bas"

# main loop
#include "gameLoop.bas"

# game over
#include "gameOver.bas"

# utility subs
#include "utilitySubs.bas"
#include "trainer.bas"

#include "sound.bas"
#include "intro.bas"
#include "data.bas"
