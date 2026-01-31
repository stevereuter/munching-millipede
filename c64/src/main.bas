rem the munching millipede by steve reuter 2024

#include "variables.bas"
  
startIntroScreen:
gosub introScreenSub

rem load game
#include "initGame.bas"

rem main loop
#include "gameLoop.bas"

rem game over
#include "gameOver.bas"

rem utility subs
#include "utilitySubs.bas"

#include "sound.bas"
#include "data.bas"
#include "intro.bas"
