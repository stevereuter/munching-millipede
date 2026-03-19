# the munching millipede v1.0.6
# by steviesaurus dev
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
#include "intro.bas"
#include "data.bas"
