rem the munching millipede by steviesaurus dev v1.0.1

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

#include "sound.bas"
#include "data.bas"
#include "intro.bas"
